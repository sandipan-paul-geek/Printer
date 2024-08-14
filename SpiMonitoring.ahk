#Requires AutoHotkey v2.0
#Include Lib\UIA.ahk
#Include Constants.ahk
#Include Lib\Support.ahk
#Include Modal\BoundingBox.ahk
#Include Modal\MainTabs.ahk
#Include Modal\Rectangle.ahk
#Include Modal\Response.ahk
#Include Modal\PixcelColor.ahk


CoordMode("Mouse", "Screen")
class SpiMonitoring {
	static spiMonitoring_Btn_ForClick_bbox := BoundingBox(Rectangle.New(60, 80, 260, 100))
	static spiMonitoring_SampleDataSize_bbox := BoundingBox(Rectangle.New(437,64,500,79))
	static spiMonitoring_SkipDataSize_bbox := BoundingBox(Rectangle.New(437, 84, 500, 98))
	static spiMonitoring_CollectDataSize_bbox := BoundingBox(Rectangle.New(437, 106, 500, 120))
	static spiMonitoring_Close_btn_bbox := BoundingBox(Rectangle.New(815, 4, 852, 14))

	getSpiMonitoring_ON_btn_bbox(topRefPixcel) {
		spiMonitoring_OFF_btn_bbox := BoundingBox(Rectangle.New(200, 80, 260, 100)).setPixcelColors([PixcelColor(Pixcel(274, 90), "FF3B20")]).setText("OFF")
		spiMonitoring_OFF_btn_bbox.rect.loc.x += topRefPixcel.x
		spiMonitoring_OFF_btn_bbox.rect.loc.y += topRefPixcel.y
		return spiMonitoring_OFF_btn_bbox 
	}

	start(dataSetup) {
		MainTabs().ClickPrintTab()
		this.openSpiMonitoring()
		Response res := this.checkIfSpiMonitoringDialogGetOpened()
		if (res.success) {
			spiMonitoring_bbox := res.data
			
		}
	}
	checkIfSpiMonitoringDialogGetOpened() {
		newWinClass := "ahk_class #32770"
		WinWait(newWinClass)
		WinRestore(newWinClass)
		maxState := WinGetMinMax(newWinClass)
		if (maxState != 1) {
			WinMaximize(newWinClass)
		}
		hwnd := "ahk_exe ScreenPrint.exe"
		ScreenPrintEl := UIA.ElementFromHandle(hwnd)
		if (ScreenPrintEl)
		{
			ScreenPrintEl.Highlight()
			parentRect := Rectangle.BoundingRectToRectangle(ScreenPrintEl.BoundingRectangle)
			childEl := ScreenPrintEl.FindElement({ AutomationId: "1234", ClassName: "MFCGridCtrl", LocalizedType: "pane", Type: "Pane" })
			if (childEl)
			{
				childEl.Highlight()
				contained := parentRect.Contains(Rectangle.BoundingRectToRectangle(childEl.BoundingRectangle))
				return Response(true).setMesssage("Spi Monitoring Dialog Opened").setData(parentRect)
			}
		}
		return Response(false).setMesssage("Spi Monitoring Dialog Not Opened")
	}

	isSpiMonitoringEnabled() {
		BoundingBox spiLed := spiMonitoring_disabled_LED_bbox
		isDisabled := spiLed.CheckPixelColors()
		return isDisabled
	}

	openSpiMonitoring() {
		smoothMouseMove(spiMonitoring_Btn_ForClick_bbox.getCenter(), mouseSpeed)
		Click("left")
		Sleep(1000)
	}


}
^+n::
{

	WinGetPos(&winX, &winY, &winWidth, &winHeight)
	MsgBox("Window X: " winX ", Y: " winY "Width: " winWidth ", Height: " winHeight)

	MouseGetPos(&mouseX, &mouseY)
	MsgBox(mouseX ", " mouseX)
}