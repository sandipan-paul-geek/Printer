#Requires AutoHotkey v2.0
#Include PixcelColor.ahk
#Include ..\Constants.ahk
#Include ..\Lib\Support.ahk
#Include PrinterInitialization.ahk

class SolderHeightDetection {
	__New() {
		PrinterInitialization printerInit := PrinterInitialization()
	}

	isSolderHeightDetectionEnabled() {

		return PixcelColor.CheckPixelColors(solderHeightDetection_bbox.pixcelColors, 10)
	}

	enableSolderHeightDetection() {
		smoothMouseMove(solderHeightDetection_bbox.getCenter(), MouseSpeed)
		if (!this.isSolderHeightDetectionEnabled()) {
			MsgBox("Not Enabled")
			smoothMouseMove(solderHeightDetection_bbox.getCenter(), MouseSpeed)
			Click("left")
			MsgBox("Now Enabled")
			Sleep(1000)

		}
		else {
			MsgBox("Already Enabled")
		}
	}

	disableSolderHeightDetection() {
		smoothMouseMove(solderHeightDetection_bbox.getCenter(), MouseSpeed)
		if (this.isSolderHeightDetectionEnabled()) {
			smoothMouseMove(solderHeightDetection_bbox.getCenter(), MouseSpeed)
			Click("left")
			Sleep(1000)
		}
	}
}