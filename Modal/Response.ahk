#Requires AutoHotkey v2.0

class Response {
  __New(isSuccess) {
    this.success := isSuccess
    this.data := ""
    this.message := ""
  }
  setData(data) {
    this.data := data
    return this
  }
  setMesssage(message) {
    this.message := message
    return this
  }
}