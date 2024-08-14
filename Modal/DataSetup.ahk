#Requires AutoHotkey v2.0
#Include ..\Lib\_JXON.ahk
#Include ..\Lib\UIA.ahk
#Include ..\Lib\GraphicsVision.ahk
#Include ..\Lib\Support.ahk
#Include ..\Lib\Console.ahk
#Include ..\Modal\BoundingBox.ahk
#Include ..\Modal\Pixcel.ahk
#Include ..\Modal\PixcelColor.ahk
#Include ..\Modal\Rectangle.ahk
#Include ..\Modal\SolderHeightDetect.ahk
#Include ..\Modal\PrinterInitialization.ahk
#Include ..\Constants.ahk

class DataSetup {
  __New(args := []) {
    this.Z2StencilGap := "0"
    this.stencilSearchFreq := "0"
    this.alignRetryCount := "0"
    this.markDistanceErr := "0"
  }

  class Handler {
    __New(args := []) {

    }
    start(dataSetup) {
      this.openDataSetupTab()
        .openComponentTab()
        .setZ2StencilGap_underCompTab(dataSetup.Z2StencilGap)
        .openVisionTab()
        .setSetStencilSearchFreq_underVisionTab(dataSetup.stencilSearchFreq)
        .setSetAlignRetryCount_underVisionTab(dataSetup.alignRetryCount)
        .setSetMarkDistanceErr_underVisionTab(dataSetup.markDistanceErr)
        .clickSaveDataApplyButton()
        .openPrintTab()
    }

    readJsonForSetup(programName) {
      Console.log("In readJsonForSetup()")
      String jsonFilePath := this.getDataSetupJsonFilePath()
      Console.log("In readJsonForSetup(): jsonFilePath: " jsonFilePath)
      if (!FileExist(jsonFilePath)) {
        Console.log("In readJsonForSetup(): DataSetup Json not found")
        return Response(false).setMesssage("DataSetup Json not found")
      }
      json := FileRead(jsonFilePath)
      DataSetup dataObj := Jxon_Load(&json)
      return Response(true).setData(dataObj).setMesssage("DataSetup Json loaded")
    }

    readProgramName() {
      Console.log("In readProgramName()")
      smoothMouseMove(fileName_bbox.getCenter(), MouseSpeed)
      Sleep(1000)
      graphic := GraphicsVision()
      if (!graphic.isGdipStarted()) {
        Console.log("In readProgramName() Error: GraphicsVision not initialized")
        return Response(false).setMesssage("GraphicsVision not initialized")
      }
      Console.log("In readProgramName() GraphicsVision initialized")
      searchFileName() {
        Console.log("In searchFileName(): Searching for file name")
        programName := graphic.TryDoOCR_InSearchArea(fileName_bbox.rect, 2000)
        Console.log("In searchFileName(): OCR Done for programName: " programName)
        return Response(true).setData(programName).setMesssage("OCR Done")
      }
      Response res := RetryForString(searchFileName, 5, false)
      Console.log("In readProgramName(): " res.message)
      return res
    }

    getDataSetupJsonFilePath() {
      filePath := ServerDir
      systemIpAddress := Network.Utils.GetIPv4Address()
      if (systemIpAddress.success) {
        if (systemIpAddress.data == "192.168.1.12") {
          filePath .= "\Line1"
        }
        else if (systemIpAddress.data == "192.168.1.22") {
          filePath .= "\Line3"
        }
        else if (systemIpAddress.data == "192.168.2.12") {
          filePath .= "\Line4"
        }
        else if (systemIpAddress.data == "192.168.2.22") {
          filePath .= "\Line5"
        }
        else {
          filePath .= "\Automate"
          Console.log("In getDataSetupJsonFilePath(): Unknown IP Address")
        }
        filePath .= "\Printer\Setup.json"
        return filePath
      }
    }

    setZ2StencilGap_underCompTab(value) {
      Console.log("In setZ2StencilGap_underCompTab(), value: " value " is to be set")
      smoothMouseMove(z2StencilTextView_bbox.getCenter(), MouseSpeed)
      Click("left")
      Send(value)
      Sleep(1000)
      Send("{Enter}")
      Console.log("In setZ2StencilGap_underCompTab(): Done, verification using ocr pending")
      Sleep(1000)
      return this
    }

    setSetStencilSearchFreq_underVisionTab(searchFreq) {
      Console.log("In setSetStencilSearchFreq_underVisionTab(), searchFreq: " searchFreq " is to be set")
      smoothMouseMove(stencilSearchFreqTextView_bbox.getCenter(), MouseSpeed)
      Click("left")
      Send(searchFreq)
      Sleep(1000)
      Send("{Enter}")
      Console.log("In setSetStencilSearchFreq_underVisionTab(): Done, verification using ocr pending")
      Sleep(1000)
      return this
    }

    setSetAlignRetryCount_underVisionTab(count) {
      Console.log("In setSetAlignRetryCount_underVisionTab(), count: " count " is to be set")
      smoothMouseMove(alignRetryCountTextView_bbox.getCenter(), MouseSpeed)
      Click("left")
      Send(count)
      Sleep(1000)
      Send("{Enter}")
      Console.log("In setSetAlignRetryCount_underVisionTab(): Done, verification using ocr pending")
      Sleep(1000)
      return this
    }

    setSetMarkDistanceErr_underVisionTab(count) {
      Console.log("In setSetMarkDistanceErr_underVisionTab(), count: " count " is to be set")
      smoothMouseMove(markDistanceTextView_bbox.getCenter(), MouseSpeed)
      Click("left")
      Send(count)
      Sleep(1000)
      Send("{Enter}")
      Console.log("In setSetMarkDistanceErr_underVisionTab(): Done, verification using ocr pending")
      Sleep(1000)
      return this
    }


    openBoardSizeTab() {
      Console.log("In openBoardSizeTab()")
      smoothMouseMove(boardSizeTab_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In openBoardSizeTab(): boardSizeTab_bbox clicked")
      Sleep(1000)
      return this
    }
    openPrintTab() {
      MainTabs().ClickPrintTab()
      return this
    }
    openDataSetupTab() {
      MainTabs().ClickPrintTab().ClickSetupTab().ClickConfigMenuItem()
      return this
    }
    openComponentTab() {
      Console.log("In openComponentTab()")
      smoothMouseMove(componentTab_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In openComponentTab(): componentTab_bbox clicked")
      Sleep(1000)
      return this
    }

    openSquegeeTab() {
      Console.log("In openSquegeeTab()")
      smoothMouseMove(squeegeeTab_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In openSquegeeTab(): squeegeeTab_bbox clicked")
      Sleep(1000)
      return this
    }

    openWiperTab() {
      Console.log("In openWiperTab()")
      smoothMouseMove(wiperTab_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In openWiperTab(): wiperTab_bbox clicked")
      Sleep(1000)
      return this
    }

    openVisionTab() {
      Console.log("In openVisionTab()")
      smoothMouseMove(visionTab_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In openVisionTab(): visionTab_bbox clicked")
      Sleep(1000)
      return this
    }

    openPasteInspectionTab() {
      Console.log("In openPasteInspectionTab()")
      smoothMouseMove(pasteInspectionTab_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In openPasteInspectionTab(): pasteInspectionTab_bbox clicked")
      Sleep(1000)
      return this
    }


    clickSaveDataApplyButton() {
      Console.log("In clickSaveDataApplyButton()")
      smoothMouseMove(saveDataApplyButton_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In clickSaveDataApplyButton(): saveDataApplyButton_bbox clicked")
      Sleep(1500)

      Console.log("In clickSaveDataApplyButton(): Looking for Save Dialog")
      saveDialogTitle := "ScreenPrint"
      saveDialogWindow := UIA.ElementFromHandle("ScreenPrint ahk_exe ScreenPrint.exe")
      yesButton := saveDialogWindow.FindElement({ AutomationId: "6", Name: "Yes" })
      if (!yesButton) {
        Console.log("In clickSaveDataApplyButton(): Yes button not found")
        return
      }
      Console.log("In clickSaveDataApplyButton(): Yes button found")
      yesButton.SetFocus()
      yesButton.Highlight()
      yesButton.Click()
      Console.log("In clickSaveDataApplyButton(): Yes button clicked")
      Sleep(1000)
      return this
    }
  }

}