#Requires AutoHotkey v2.0
#Include Lib\_JXON.ahk
#Include Modal\SolderHeightDetect.ahk
#Include Modal\PrinterInitialization.ahk
#Include Modal\DataSetup.ahk
#Include Modal\Response.ahk
#Include Modal\Network.ahk
#Include Modal\MainTabs.ahk
#Include Lib\Support.ahk
#Include Constants.ahk
#Include Lib\ThreadManager.ahk

CoordMode("Mouse", "Screen")

programInitTest() {
	Console.log("============ Program Init Test Started ============")
	response := CheckTesseractInstallation()
	Console.log(response.message)
	if (response.success) {
		response := CheckTesseractVersion(Tesseract_Version)
		Console.log(response.message)
		if (response.success) {
			response := Network.Utils.GetIPv4Address()
			Console.log(response.message)
			if (response.success) {
				String ipAddress := response.data
				response := Network.Utils.IsInSmtNetwork(ipAddress)
				Console.log(response.message)
				if (response.success) {
					response := Network.Utils.isServerConnected(ServerIP)
					Console.log(response.message)
					if (response.success) {
						if (DirExist(ServerDir)) {
							Console.log("Server Directory Exists")
							Console.log("============ Program Init Test Passed ============")
							return true
						}
					}
				}
			}
		}
	}
	Console.log("============ Program Init Test Failed ============")
	return false
}

main() {
	if (!programInitTest()) {
		return
	}
	; else {
	; 	return
	; }

	PrinterInitialization printerInit := PrinterInitialization()
	initializationDone := printerInit.initializeSystem()
	if (initializationDone)
	{
		Console.log("Initialization and Now in data setup")
		SolderHeightDetection().enableSolderHeightDetection()
		; SpiMonitoring().enableSpiMonitoring()

		DataSetup.Handler setupHandler := DataSetup.Handler()
		Response res := setupHandler.readProgramName()
		if (res.success) {
			String programName := res.data
			res := setupHandler.readJsonForSetup(programName)
			if (res.success) {
				DataSetup setupData := res.data
				setupHandler.start(setupData)
			}
		}
	}
	else {
		Console.log("Rechecking stat: Not Initialized!")
	}
}
manager := ThreadManager()

uiTask() {
	ToolTip "UI task is running... " A_Index
	Sleep(50)
}

test() {
	manager.Start(uiTask)
}

^+n:: {
	
	test()
}
^!x:: manager.Stop()
^!p:: manager.Pause()
^!r:: manager.Resume()
^!c:: MsgBox "Thread state: " manager.GetState()