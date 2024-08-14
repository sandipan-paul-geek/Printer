#Requires AutoHotkey v2.0
#Include ../Lib/Console.ahk
#Include ../Lib/Support.ahk
#Include ../Constants.ahk

class MainTabs {

  ClickPrintTab() {
    Console.log("In openPrintTab()")
    smoothMouseMove(printTabBtn_bbox.getCenter(), MouseSpeed)
    Click("left")
    Console.log("In openPrintTab(): printTabBtn_bbox clicked")
    Sleep(1000)
    return this
  }

   ClickSetupTab() {
    Console.log("In openDataSetupTab()")
    smoothMouseMove(setupTab_bbox.getCenter(), MouseSpeed)
    Click("left")
    Console.log("In openDataSetupTab(): setupTab_bbox clicked")
    Sleep(1000)
    return MainTabs.Setup()
  }
  class Setup {
    ClickConfigMenuItem() {
      Console.log("In ClickConfigMenuItem()")
      smoothMouseMove(setup_config_Button_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In ClickConfigMenuItem(): setup_config_Button_bbox clicked")
      Sleep(1000)
    }
    ClickFiducialMarkMenuItem() {
      Console.log("In ClickFiducialMarkMenuItem()")
      smoothMouseMove(setup_fiducialMark_Button_bbox.getCenter(), MouseSpeed)
      Click("left")
      Console.log("In ClickFiducialMarkMenuItem(): setup_fiducialMark_Button_bbox clicked")
      Sleep(1000)
    }
  }
}