#Requires AutoHotkey v2.0

class Console {
    static log(message) {
        logDir := ".\Logs"
        filePath := logDir "\" FormatTime("", "dd-MM-yyyy") ".txt"
        if (!DirExist(logDir)) {
            DirCreate(logDir)
        }
        currentDateTime := FormatTime("", "dd-MM-yyyy HH:mm:ss")
        FileAppend(currentDateTime ": " message "`n", filePath)  ; Ensure newline with `n
    }

    static error(message) {
        logDir := ".\Logs"
        filePath := logDir "\" FormatTime("", "dd-MM-yyyy") ".txt"
        if (!DirExist(logDir)) {
            DirCreate(logDir)
        }
        currentDateTime := FormatTime("", "dd-MM-yyyy HH:mm:ss")
        FileAppend(currentDateTime ": ERROR - " message "`n", filePath)  ; Ensure newline with `n
    }

    static warn(message) {
        logDir := ".\Logs"
        filePath := logDir "\" FormatTime("", "dd-MM-yyyy") ".txt"
        if (!DirExist(logDir)) {
            DirCreate(logDir)
        }
        currentDateTime := FormatTime("", "dd-MM-yyyy HH:mm:ss")
        FileAppend(currentDateTime ": WARNING - " message "`n", filePath)  ; Ensure newline with `n
    }

    static debug(message) {
        logDir := ".\Logs"
        filePath := logDir "\" FormatTime("", "dd-MM-yyyy") ".txt"
        if (!DirExist(logDir)) {
            DirCreate(logDir)
        }
        currentDateTime := FormatTime("", "dd-MM-yyyy HH:mm:ss")
        FileAppend(currentDateTime ": DEBUG - " message "`n", filePath)  ; Ensure newline with `n
    }
}
