#Requires AutoHotkey v2
#Include Lib\Gdip_All.ahk

mGui := Gui("+ToolWindow +AlwaysOnTop")

varStartX := 0
varStartY := 0
varEndX := 0
varEndY := 0
drawing := false
guiShown := false

DrawRectangle() {
    global mGui, varStartX, varStartY, varEndX, varEndY, drawing, guiShown

    if !guiShown {
        mGui.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight)
        guiShown := true

        hdc := DllCall("GetDC", "ptr", mGui.HWND, "ptr")
        hdcMem := DllCall("CreateCompatibleDC", "ptr", hdc, "ptr")
        hbm := DllCall("CreateCompatibleBitmap", "ptr", hdc, "int", A_ScreenWidth, "int", A_ScreenHeight, "ptr")
        oldBmp := DllCall("SelectObject", "ptr", hdcMem, "ptr", hbm, "ptr")
    }

    MouseGetPos(&varEndX, &varEndY)

    

    graphics := Gdip_GraphicsFromHDC(hdcMem)
    brush := Gdip_BrushCreateSolid(0x80FFFF00) ; Translucent yellow color (ARGB: Alpha 0x80, Red 0xFF, Green 0xFF, Blue 0x00)
    pen := Gdip_CreatePen(0xFFFF0000, 3) ; Yellow border (ARGB: Alpha 0xFF, Red 0xFF, Green 0x00, Blue 0x00)

    ; Ensure starting and ending coordinates are properly ordered
    x1 := Min(varStartX, varEndX)
    y1 := Min(varStartY, varEndY)
    x2 := Max(varStartX, varEndX)
    y2 := Max(varStartY, varEndY)
    w := x2 - x1
    h := y2 - y1

    ; Draw the rectangle
    Gdip_DrawRectangle(graphics, pen, x1, y1, w, h)
    Gdip_FillRectangle(graphics, brush, x1, y1, w, h)

    ; Release resources
    Gdip_DeleteGraphics(graphics)
    Gdip_DeleteBrush(brush)
    Gdip_DeletePen(pen)

    ; Copy drawn content to GUI
    DllCall("BitBlt", "ptr", hdc, "int", 0, "int", 0, "int", A_ScreenWidth, "int", A_ScreenHeight, "ptr", hdcMem, "int", 0, "int", 0, "uint", 0x00CC0020) ; SRCCOPY

    ; ; Clean up
    ; DllCall("SelectObject", "ptr", hdcMem, "ptr", oldBmp, "ptr")
    ; DllCall("DeleteObject", "ptr", hbm)
    ; DllCall("DeleteDC", "ptr", hdcMem)
    ; DllCall("ReleaseDC", "ptr", mGui.HWND, "ptr", hdc)

    ; Display coordinates in a tooltip
    ToolTip("X: " x1 "`nY: " y1 "`nW: " w "`nH: " h)

    ; Check if mouse button is released to stop drawing
    if (!GetKeyState("LButton", "P")) {
        drawing := false
        mGui.Destroy()
        ToolTip()
        MsgBox("Rectangle coordinates:" . "`n" .
            "X: " x1 . "`n" .
            "Y: " y1 . "`n" .
            "Width: " w . "`n" .
            "Height: " h)
    }
}

^!r:: {
    token := Gdip_Startup()
    drawing := true
    guiShown := false

    MouseGetPos(&varStartX, &varStartY) ; Capture starting position

    Loop {
        if (!drawing) {
            Gdip_Shutdown(token)
            break
        }
        DrawRectangle()
        Sleep(10)
    }
}
