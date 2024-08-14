#Requires AutoHotkey v2
#include Gdip_All.ahk

CoordMode "Mouse", "Screen"

class GraphicsVision {
    __New() {
        this.pToken := Gdip_Startup()
    }
    isGdipStarted() {
        return this.pToken
    }   
    shutdown() {
        Gdip_Shutdown(this.pToken)
    }
    BitmapFromScreen() {
        pBitmap := Gdip_BitmapFromScreen()
        return pBitmap
    }
    CreateBitmap(width, height) {
        pBitmap := Gdip_CreateBitmap(width, height)
        return pBitmap
    }
    GraphicsFromImage(pBitmap) {
        G := Gdip_GraphicsFromImage(pBitmap)
        return G
    }
    DrawImage(G, pBitmap, x, y, w, h, srcX, srcY, srcW, srcH) {
        Gdip_DrawImage(G, pBitmap, x, y, w, h, srcX, srcY, srcW, srcH)
    }
    DeleteGraphics(G) {
        Gdip_DeleteGraphics(G)
    }
    DisposeImage(pBitmap) {
        Gdip_DisposeImage(pBitmap)
    }
    SaveBitmapToFile(pBitmap, filePath) {
        Gdip_SaveBitmapToFile(pBitmap, filePath)
    }
    GetNewFilePath() {
        return A_Temp "\cropped_image.png"
    }
    CaptureAndCrop(rect) {
        if !(rect.loc.x && rect.loc.y && rect.width && rect.height)
            return ""
        pBitmap := this.BitmapFromScreen()
        pCropped := this.CreateBitmap(rect.width, rect.height)
        G := this.GraphicsFromImage(pCropped)
        this.DrawImage(G, pBitmap, 0, 0, rect.width, rect.height, rect.loc.x, rect.loc.y, rect.width, rect.height)
        this.DeleteGraphics(G)
        this.DisposeImage(pBitmap)

        croppedImageFilePath := this.GetNewFilePath()
        this.SaveBitmapToFile(pCropped, croppedImageFilePath)
        this.DisposeImage(pCropped)
        return croppedImageFilePath
    }

    DoOCR(croppedImageFilePath) {
        outputFile := StrReplace(croppedImageFilePath, ".png", "")
        RunWait("tesseract.exe " croppedImageFilePath " " outputFile " -l eng --psm 6", , "Hide")
        return FileRead(outputFile ".txt")
    }

    DoOCR_InSearchArea(ocrSearchingRect) {
        croppedImageFilePath := this.CaptureAndCrop(ocrSearchingRect)
        if (!croppedImageFilePath) {
            return ""
        }
        text := this.DoOCR(croppedImageFilePath)
        return text
    }

    TryDoOCR_InSearchArea(ocrSearchingRect, timeout := 5000) {
        detectedText := ""
        startTime := A_TickCount
        Loop {
            text := this.DoOCR_InSearchArea(ocrSearchingRect)
            if (text) {
                detectedText := text
                break
            }
            if ((A_TickCount - startTime) > timeout) {
                break
            }
            Sleep(500)
        }
        return Trim(detectedText, "`n")
    }
}
