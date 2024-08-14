#Requires AutoHotkey v2.0
#Include Rectangle.ahk
#Include Pixcel.ahk

class Rectangle {
    __New(x, y, width, height) {
        this.loc := Pixcel(x, y)
        this.width := width
        this.height := height
    }

    Contains(rect) {
        return (this.loc.x <= rect.loc.x && this.loc.y <= rect.loc.y &&
            (this.loc.x + this.width) >= (rect.loc.x + rect.width) &&
            (this.loc.y + this.height) >= (rect.loc.y + rect.height))
    }

    GetRight() {
        return this.loc.x + this.width
    }

    GetBottom() {
        return this.loc.y + this.height
    }

    GetCenter() {
        centerX := this.loc.x + this.width / 2
        centery := this.Loc.y + this.height / 2
        return Pixcel(centerX, centery)
    }

    static BoundingRectToRectangle(boundingRect) {
        return Rectangle.New(boundingRect.l, boundingRect.t, boundingRect.r, boundingRect.b)
    }
    static New(left, top, right, bottom) {
        x := left
        y := top
        width := right - left
        height := bottom - top
        return Rectangle(x, y, width, height)
    }
    static Empty() {
        return Rectangle(0, 0, 0, 0)
    }
}