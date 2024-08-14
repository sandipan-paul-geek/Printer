#Requires AutoHotkey v2.0

class ThreadManager {
  stopThread := false
  pauseThread := false
  state := "Not Started"
  uiHandlingTask := ""

  __New(taskFunc := "") {
    if IsObject(taskFunc) && (taskFunc is Func) {
      this.uiHandlingTask := taskFunc
    }
  }

  Start(taskFunc := "") {
    if (this.state = "Running") {
      MsgBox "Thread is already running."
      return
    }

    if IsObject(taskFunc) && (taskFunc is Func) {
      this.uiHandlingTask := taskFunc
    }

    if !IsObject(this.uiHandlingTask) || !(this.uiHandlingTask is Func) {
      MsgBox "No task function provided or invalid function."
      return
    }

    this.stopThread := false
    this.pauseThread := false
    this.state := "Running"

    ; Start the thread by calling the ThreadTask method
    this.ThreadTask()
  }

  Stop() {
    if (this.state != "Running") {
      MsgBox "Thread is not running."
      return
    }
    this.stopThread := true
    this.state := "Stopped"
  }

  Pause() {
    if (this.state != "Running") {
      MsgBox "Thread is not running, cannot pause."
      return
    }
    this.pauseThread := true
    this.state := "Paused"
  }

  Resume() {
    if (this.state != "Paused") {
      MsgBox "Thread is not paused, cannot resume."
      return
    }
    this.pauseThread := false
    this.state := "Running"
  }

  GetState() {
    return this.state
  }

  ThreadTask() {
    Loop {
      if (this.stopThread) {
        MsgBox "Thread is stopping..."
        break
      }

      ; If paused, wait here until resumed
      while (this.pauseThread) {
        Sleep(100)  ; Check every 100ms to see if we should resume
      }

      ; Execute the task function
      this.uiHandlingTask.Call()
    }
  }
}