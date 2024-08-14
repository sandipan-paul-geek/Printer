#Requires AutoHotkey v2.0

class PixcelColor {
    __New(pixcel, color) {
        this.pixcel := pixcel
        this.color := color
    }

    static HexToRGB(hexStr) {
        hex := "0x" hexStr
        return [
            (hex >> 16) & 0xFF,  ; Red
            (hex >> 8) & 0xFF,   ; Green
            hex & 0xFF           ; Blue
        ]
    }

    static AreColorsSimilar(color1, color2, tolerance) {
        color1RGB := PixcelColor.HexToRGB(color1)
        color2RGB := PixcelColor.HexToRGB(color2)

        for i, value in color1RGB {
            if (Abs(value - color2RGB[i]) > tolerance) {
                return false
            }
        }
        return true
    }

    static CheckPixelColors(pixelColorArray, tolerance := 50) {
        allColorsMatched := true
        Console.debug("Checking pixel colors")
        for pixelColor in pixelColorArray {
            Console.debug("Expected pixel color: " pixelColor.color " at " pixelColor.pixcel.x ", " pixelColor.pixcel.y)    
            color := PixelGetColor(pixelColor.pixcel.x, pixelColor.pixcel.y)
            colorHex := Format("{:06X}", color & 0xFFFFFF)
            Console.debug("Actual pixel color: " colorHex)
            expectedColorHex := pixelColor.color
            if !PixcelColor.AreColorsSimilar(expectedColorHex, colorHex, tolerance) {
                allColorsMatched := false
                Console.debug("Color not matched")
            }
            else {
                Console.debug("Color matched")
            }
        }
        return allColorsMatched
    }

}