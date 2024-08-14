#Requires AutoHotkey v2.0

class BoundingBox {
    __New(rect) {
        this.rect := rect
        this.pixcelColors := []
        this.text := ""
    }
    setPixcelColors(pixcelColors) {
        this.pixcelColors := pixcelColors
        return this
    }
    setRectangle(left, top, right, bottom) {
        this.rect := Rectangle.New(left, top, right, bottom)
        return this
    }
    setText(text) {
        this.text := text
        return this
    }
    getCenter() {
     return this.rect.GetCenter()
    }
}