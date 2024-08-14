#Requires AutoHotkey v2.0
#Include ..\Lib\UIA.ahk
#Include ..\Lib\GraphicsVision.ahk
#Include ..\Lib\Support.ahk
#Include ..\Lib\Console.ahk
#Include BoundingBox.ahk
#Include PixcelColor.ahk
#Include Rectangle.ahk
#Include ..\Constants.ahk

class PrinterInitialization {
	__New(args := []) {

	}
	static dialog1Text := "Make sure that the squeegee holder and backup blocks are removed."
	check_DialogBoxRect1_OnInitializeClicked_LINE2() {
		try {
			hwnd := "ahk_exe ScreenPrint.exe"
			ScreenPrintEl := UIA.ElementFromHandle(hwnd)
			if (ScreenPrintEl)
			{
				ScreenPrintEl.Highlight()
				parentRect := Rectangle.BoundingRectToRectangle(ScreenPrintEl.BoundingRectangle)
				isWithinSearchArea := OnInitializeClicked_DialogBox1_bbox.rect.Contains(parentRect)
				if (isWithinSearchArea) {
					childEl := ScreenPrintEl.FindElement({ AutomationId: "7008", Name: PrinterInitialization.dialog1Text })
					if (childEl)
					{
						childEl.Highlight()
						contained := parentRect.Contains(Rectangle.BoundingRectToRectangle(childEl.BoundingRectangle))
						return contained
					}
				}
			}
			return -1
		}
		catch {
			return -1
		}
	}

	check_DialogBoxRect2_OnInitializeClicked_LINE2() {
		try {
			hwnd := "ahk_exe ScreenPrint.exe"
			ScreenPrintEl := UIA.ElementFromHandle(hwnd)
			if (ScreenPrintEl)
			{
				ScreenPrintEl.Highlight()
				parentRect := Rectangle.BoundingRectToRectangle(ScreenPrintEl.BoundingRectangle)
				isWithinSearchArea := OnInitializeClicked_DialogBox2_bbox.rect.Contains(parentRect)
				if (isWithinSearchArea) {
					childE2 := ScreenPrintEl.FindElement({ LocalizedType: "title bar", Type: "TitleBar" })
					if (childE2) {
						childE2.Highlight()
						isContained := parentRect.Contains(Rectangle.BoundingRectToRectangle(childE2.BoundingRectangle))
						return isContained
					}
				}
			}
			return -1
		}
		catch {
			return -1
		}
	}

	isNotInitialiazed() {
		smoothMouseMove(InitializeNotDone_outside_bbox.getCenter(), MouseSpeed)
		return PixcelColor.CheckPixelColors(InitializeNotDone_outside_bbox.pixcelColors)
	}

	startInitializeMachine() {
		Console.log("startInitializeMachine() called.")
		try {
			smoothMouseMove(maintainanceTab_bbox.getCenter(), MouseSpeed)
			Click("left")
			Console.log("maintainanceTab_bbox clicked")
			Sleep(1000)
			smoothMouseMove(initialzeButton_bbox.getCenter(), MouseSpeed)
			Click("left")
			Console.log("initialzeButton_bbox clicked")
			Sleep(1000)

			stage1() {
				initDialog1 := this.check_DialogBoxRect1_OnInitializeClicked_LINE2()
				if (initDialog1 == -1 || initDialog1 == 0) {
					Console.log("Required Initialize DialogBox 1 not found.")
					return false
				}
				return true
			}

			stage2() {
				this.closeInitializeDialogBox1()
				initDialog2 := this.check_DialogBoxRect2_OnInitializeClicked_LINE2()
				if (initDialog2 == -1 || initDialog2 == 0) {
					Console.log("Required Initialize DialogBox 2 not found.")
					return false
				}
				smoothMouseMove(initialzeStartButton_bbox.getCenter(), MouseSpeed)
				Click("left")
				return true
			}
			if (RetryForBoolean(stage1, 3, 1000)) {
				return RetryForBoolean(stage2, 3, 1000)
			}
		} catch {

		}
		return false
	}

	closeInitializeDialogBox1() {
		smoothMouseMove(afterInitializeClicked_DialogButton_bbox.getCenter(), MouseSpeed)
		Click("left")
		Sleep(2000)
	}

	closeInitializeDialogBox2() {
		smoothMouseMove(initialzeCloseButton_bbox.getCenter(), MouseSpeed)
		Click("left")
		Sleep(1000)
	}

	initializeSystem()
	{
		Console.log("Auto Initialization Started")
		isNotInitiated := this.isNotInitialiazed()
		if (isNotInitiated == -1) {
			Console.log("Initialization check failed! Call Sandipan.")
			return
		}
		if (isNotInitiated) {
			Console.log("Machine is not Initialized.`nGoing to Initialize the Machine")
			this.startInitializeMachine()
			initializationDone := false
			timeout := 90 * 1000 ;
			startTime := A_TickCount

			graphics := GraphicsVision()
			if (!graphics) {
				Console.log("Error: GraphicsVision not initialized")
				return
			}
			Loop {
				scanResult := graphics.TryDoOCR_InSearchArea(initializationDone_bbox.rect, 2000)
				if (!(scanResult == initializationDone_bbox.text)) {
					scanResult := graphics.TryDoOCR_InSearchArea(machineMode_Pause_bbox.rect, 2000)
					if (scanResult == machineMode_Pause_bbox.text) {
						Console.log("Initialization done.")
						initializationDone := true
						break
					}
				}
				if (A_TickCount - startTime > timeout) {
					break
				}
				Sleep(1000)
			}
			graphics.shutdown()
			Console.log("Rechecking Initialization")
			isNotInitiated := this.isNotInitialiazed()

			return initializationDone && !isNotInitiated
		}
		return true
	}
}