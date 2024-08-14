#Requires AutoHotkey v2.0
#Include ../Modal/Response.ahk

CoordMode("Mouse", "Screen")

CheckTesseractInstallation() {
    Response res := ExecuteCmd("where tesseract", true)
    if (!res.success) {
        return Response(false).setMesssage("Could not determine Tesseract installation status.")
    }
    String output := res.data
    if (InStr(output, "INFO: Could not find files for the given pattern(s).")) {
        return Response(false).setMesssage("Tesseract is not installed.")
    } else if (StrLen(output) > 0) {
        return Response(true).setMesssage("Tesseract is installed at: " output)
    } else {
        return Response(false).setMesssage("Could not determine Tesseract installation status.")
    }
}

CheckTesseractVersion(requiredVersion) {
     Response res := ExecuteCmd("tesseract -v")
    if (!res.success) {
        return Response(false).setMesssage("Could not determine Tesseract version")
    }
    String output := res.data
    if (InStr(output, "INFO: Could not find files for the given pattern(s).")) {
        return Response(false).setMesssage("Tesseract is not installed.")
    } else if (InStr(output, "tesseract")) {
        try {
            String versionLine := StrSplit(output, "`n")[1]
            versionLine := StrSplit(versionLine, "v")[2]
            installedVersion := SubStr(versionLine, 1, 5)
            if (CompareVersions(installedVersion, requiredVersion) >= 0) {
                return Response(true).setMesssage("Tesseract is installed with version " installedVersion ", which meets or exceeds the required version " requiredVersion ".")
            }
            return Response(false).setMesssage("Tesseract is installed with version " installedVersion ", but it does not meet the required version " requiredVersion ".")
        } catch Error as e {
            return Response(false).setMesssage("Could not extract the Tesseract version from the output.")
        }
    } else {
        return Response(false).setMesssage("Could not determine Tesseract installation status.")
    }
}

CompareVersions(version1, version2) {
    v1Parts := StrSplit(version1, ".")
    v2Parts := StrSplit(version2, ".")
    Loop 3 {
        if (v1Parts[A_Index] > v2Parts[A_Index]) {
            return 1
        } else if (v1Parts[A_Index] < v2Parts[A_Index]) {
            return -1
        }
    }
    return 0
}

ExecuteCmd(command, waitForCompletion := true) {
    Console.log("In ExecuteCmd(): " command)
    try {
        Console.log("In ExecuteCmd(), Executing command: " command ", waitForCompletion: " waitForCompletion)
        tempFile := A_Temp "\tesseract_check_output.txt"
        if (waitForCompletion) {
            RunWait("cmd /c " command " > " tempFile " 2>&1", "", "Hide")
        } else {
            Run("cmd /c " command " > " tempFile " 2>&1", "", "Hide")
        }
        Console.log("In ExecuteCmd(), Execution finished for command: " command)
        output := FileRead(tempFile)
        if FileExist(tempFile) {
            FileDelete(tempFile)
        }
        return Response(true).setData(output).setMesssage("Command executed successfully.")
    }
    catch {
        Console.log("In ExecuteCmd(), Error in ExecuteCmd(): " A_LastError)
        return Response(false).setMesssage("Error executing command.")
    }
}

smoothMouseMove(pixcel, speed) {
    MouseGetPos(&currentX, &currentY)
    Console.debug("cx, cy: " currentX ", " currentY ", px, py: " pixcel.x ", " pixcel.y ", speed: " speed)
    steps := Sqrt((pixcel.x - currentX) ** 2 + (pixcel.y - currentY) ** 2) / speed
    if (steps < 1) {
        Console.debug("steps: " steps ". Seems like the distance is too short. Moving directly to the destination.")
        MouseMove(pixcel.x, pixcel.y, 0)
        return
    }
    Console.debug("steps: " steps)
    xIncrement := (pixcel.x - currentX) / steps
    Console.debug("xIncrement: " xIncrement)
    yIncrement := (pixcel.y - currentY) / steps
    Console.debug("yIncrement: " yIncrement)
    Console.debug("In loop")
    Loop steps {
        currentX += xIncrement
        currentY += yIncrement
        Console.debug("cx, cy: " currentX ", " currentY)
        MouseMove(currentX, currentY, 0)
        Sleep(10) ; Adjust the sleep time for smoother/slower movement
    }
    MouseMove(pixcel.x, pixcel.y, 0) ; Ensure the final position is accurate
    Console.debug("Out loop`n`n")
}

RetryForBoolean(func, retryCount, delay := 1000) {
    currentRetry := 0
    while (currentRetry < retryCount) {
        if (func()) {
            return true
        }
        currentRetry++
        Sleep(delay)
    }
    return false
}

RetryForString(func, retryCount, willReturnEmptyStr := false, delay := 1000) {
    Console.log("In RetryForString()")
    currentRetry := 0
    while (currentRetry < retryCount) {
        Console.log("In RetryForString(): currentRetry: " currentRetry)
        result := func()
        if ((willReturnEmptyStr && result != "") || (!willReturnEmptyStr && result == "")) {
            currentRetry++
            Sleep(delay)
            continue
        }
        Console.log("In RetryForString(): String found: " result)
        return Response(true).setData(result).setMesssage("String found: " result)
    }
    Console.log("In RetryForString(): String not found.")
    return Response(false).setMesssage("String not found.")
}

; currently this function has some bug and not working as expected
ObjectToString(obj, singleLine := true) {
    str := ""
    separator := singleLine ? ", " : "`n"  ; Choose separator based on singleLine flag

    ; Iterate over object keys and values
    for key in obj.Keys() {
        value := obj[key]
        str .= key ": " value separator
    }

    ; Remove the trailing separator
    if (StrLen(separator) > 0) {
        str := str.SubStr(1, -StrLen(separator))
    }
    return str
}