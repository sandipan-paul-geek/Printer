#Requires AutoHotkey v2.0
#Include Modal\BoundingBox.ahk

MouseSpeed := 10
appPath := "D:\ESE_SPrint_Ver20.12.17C_Safe\ScreenPrint.exe"
Tesseract_Version := "5.3.0"
ServerIP := "172.16.16.14"
ServerDir := "\\" ServerIP "\Material"
; NetworksArray := [Network("172.34.34.0", "255.255.255.224"), Network("172.35.35.0", "255.255.255.224")]
NetworksArray := [Network("192.168.1.0", "255.255.255.224"), Network("192.168.2.0", "255.255.255.224")]
;========================================================================================================

OnInitializeClicked_DialogBox1_bbox := BoundingBox(Rectangle.New(276, 335, 1000, 650))
OnInitializeClicked_DialogBox2_bbox := BoundingBox(Rectangle.New(650, 90, 1179, 655))

InitializeNotDone_inside_bbox := BoundingBox(Rectangle.New(693, 940, 724, 970)).setPixcelColors([
    PixcelColor(Pixcel(917, 165), "ABABAB"),
    PixcelColor(Pixcel(924, 164), "B1B1B1"),
    PixcelColor(Pixcel(917, 171), "AEAEAE"),
    PixcelColor(Pixcel(927, 171), "ACACAC"),
])

InitializeNotDone_outside_bbox := BoundingBox(Rectangle.New(693, 940, 724, 970)).setPixcelColors([
    PixcelColor(Pixcel(707, 952), "AFAFAF"),
    PixcelColor(Pixcel(714, 952), "AFAFAF"),
    PixcelColor(Pixcel(707, 960), "BFBFBF"),
    PixcelColor(Pixcel(714, 955), "A9a9a9"),
])

fileName_bbox := BoundingBox(Rectangle.New(394, 2, 950, 25)).setText("")
initializationDone_bbox := BoundingBox(Rectangle.New(934, 150, 1070, 180)).setText("Initialization Done")
machineMode_Pause_bbox := BoundingBox(Rectangle.New(938, 241, 1025, 278)).setText("Pause")
pcb_Wiper_cycle_bbox := BoundingBox(Rectangle.New(810, 780, 950, 810))
solderHeightDetection_bbox := BoundingBox(Rectangle.New(701, 972, 837, 1016))
    .setText("Solder Height Detect")
    .setPixcelColors([
        PixcelColor(Pixcel(710, 1000), "FCBC46"),
        PixcelColor(Pixcel(730, 1000), "FCBC46"),
        PixcelColor(Pixcel(710, 1010), "FCBC46"),
        PixcelColor(Pixcel(730, 1010), "FCBC46"),
    ])

spiMonitoring_disabled_LED_bbox := BoundingBox(Rectangle.New(917, 990, 925, 1000))
    .setPixcelColors([
        PixcelColor(Pixcel(917, 990), "BABABA"),
        PixcelColor(Pixcel(925, 1000), "BFBFBF"),
        PixcelColor(Pixcel(925, 990), "BABABA"),
        PixcelColor(Pixcel(917, 1000), "BFBFBF"),
    ])

spiMonitoring_Btn_org_bbox := BoundingBox(Rectangle.New(946, 982, 1066, 1009)).setText("SPI Monitoring")
spiMonitoring_Btn_ForClick_bbox := BoundingBox(Rectangle.New(1060, 980, 1070, 1010))

;======= under setup tab ==============

setupTab_bbox := BoundingBox(Rectangle.New(680, 30, 800, 70)).setText("Setup")
setup_config_Button_bbox := BoundingBox(Rectangle.New(687, 86, 798, 115)).setText("Config")
setup_fiducialMark_Button_bbox := BoundingBox(Rectangle.New(685, 130, 800, 165)).setText("Fiducial Mark")

boardSizeTab_bbox := BoundingBox(Rectangle.New(20, 100, 177, 146)).setText("Board Size")
componentTab_bbox := BoundingBox(Rectangle.New(180, 100, 338, 148)).setText("Component")
squeegeeTab_bbox := BoundingBox(Rectangle.New(340, 100, 500, 147)).setText("Squeegee")
wiperTab_bbox := BoundingBox(Rectangle.New(500, 100, 660, 147)).setText("Wiper")
visionTab_bbox := BoundingBox(Rectangle.New(670, 106, 810, 140)).setText("Vision")
pasteInspectionTab_bbox := BoundingBox(Rectangle.New(823, 100, 982, 146)).setText("Paste Inspection")
saveDataApplyButton_bbox := BoundingBox(Rectangle.New(1170, 120, 1250, 140)).setText("Apply")

;======= under print tab ==============

printTabBtn_bbox := BoundingBox(Rectangle.New(542, 34, 660, 70)).setText("Print") ; { x: 602, y: 51 }

;======= under maintainance tab ==============

maintainanceTab_bbox := BoundingBox(Rectangle.New(818, 32, 940, 70)).setText("Maintenance") ; { x: 874, y: 51 }
initialzeButton_bbox := BoundingBox(Rectangle.New(825, 85, 935, 117)).setText("Initialization") ; { x: 874, y: 103 }
afterInitializeClicked_DialogButton_bbox := BoundingBox(Rectangle.New(770, 582, 895, 613)).setText("OK") ; { x: 829, y: 596 }
initialzeStartButton_bbox := BoundingBox(Rectangle.New(706, 574, 825, 614)).setText("Init. Start") ; { x: 760, y: 596 }
initialzeCloseButton_bbox := BoundingBox(Rectangle.New(1025, 572, 1123, 615)).setText("Close") ; { x: 1070, y: 590 }

;======= TextViews ==============
z2StencilTextView_bbox := BoundingBox(Rectangle.New(256, 436, 386, 455)).setText("0") ; { x: 325, y: 444 }
stencilSearchFreqTextView_bbox := BoundingBox(Rectangle.New(315, 263, 426, 284)).setText("0") ; {x: 367,y: 272}
alignRetryCountTextView_bbox := BoundingBox(Rectangle.New(317, 298, 425, 318)).setText("0") ; { x: 367,y: 307}
markDistanceTextView_bbox := BoundingBox(Rectangle.New(319, 377, 371, 396)).setText("0") ; {x: 346,y: 383}
