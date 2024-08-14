#Requires AutoHotkey v2.0

class Pixcel {
    __New(x, y) {
        this.x := x
        this.y := y
    }
    static Empty() {
        return Pixcel(0, 0)
    }
}