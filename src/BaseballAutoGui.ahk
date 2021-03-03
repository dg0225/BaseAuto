#include %A_ScriptDir%\src\gui\MC_GuiObject.ahk
; #include %A_ScriptDir%\src\gui\MC_MacroGui.ahk

Class BaseballAutoGui{
	width:=330
	maxGroupWidth := this.width-20
	
	__NEW( title ){
		this.guiMain := new MC_GuiObj(title)	
		this.mainHeight:=this.init()
		; this.guiMain.Show()			
		this.guiMain.OnEvent("Close", "this.guiClosed")
		; myGui.OnEvent("Close", "myGui_Close")
; myGui_Close(thisGui) {  ; Declaring this parameter is optional.
    ; if MsgBox("Are you sure you want to close the GUI?",, "y/n") = "No"
        ; return true  ; true = 1
	}

	show( posX, posY){	
		this.guiMain.Show( "x" posX . "y" . posY . "w" this.width . " h" . this.mainHeight )			
		; this.guiMain.Show(  )			
		; this.guiMain.Show( "w" this.width . " h" . totalHeight )			
	}
	changeContents( onlyMain ){
		if( onlyMain ){
			this.guiMain.Show( "w" . this.width . " h" . this.mainHeight )			
		}else{		
			this.guiMain.Show( "w" . this.width . " h" . this.totalHeight )			
		}
	
	}
	getTitle(){
		return this.guiMain.getTitle()
	}
	getName(){
		return this.guiMain.getName()
	}
	

	init(){
		mainHeight:=5
		mainHeight+=this.initPlayerWindow(mainHeight)		
		mainHeight+=this.initButtonWindow(mainHeight)
		mainHeight+=this.initLogWindow(mainHeight)		
		
		this.totalHeight:=mainHeight+this.initConfigWindow(mainHeight)+5
		return mainHeight
	}
	initPlayerWindow( _height ){
		currentWindowHeight:=150
		
		this.guiMain.addGroupBox("Players", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )
		; this.guiMain.Add("GroupBox", "먼저돌기", "x" xGuiStart " y" yPos " w" width_RunFirst " h" height_RunFirst,, 0)           
		this.guiMain.Add("CheckBox", "Player1 :", "T", "player1Enabled",0)
		this.guiMain.Add("CheckBox", "Player2 :", "B", "player2Enabled",0)
		this.guiMain.Add("CheckBox", "Player3 :", "B", "player3Enabled",0)
		this.guiMain.Add("CheckBox", "Player4 :", "B", "player4Enabled",0)
		this.guiMain.Add("CheckBox", "Player5 :", "B", "player5Enabled",0)
		this.guiMain.Add("CheckBox", "Player6 :", "B", "player6Enabled",0)
		
		this.guiMain.Add("Edit", "1", "xs+85 ys+15 w70 ", "player1Id",0)
		this.guiMain.Add("Edit", "2", "B", "player2Id",0)
		this.guiMain.Add("Edit", "3", "B", "player3Id",0)
		this.guiMain.Add("Edit", "4", "B", "player4Id",0)
		this.guiMain.Add("Edit", "5", "B", "player5Id",0)
		this.guiMain.Add("Edit", "6", "B", "player6Id",0)
		
		this.guiMain.Add("ComboBox", "League|ETC", "xs+165 ys+15 +Center w70 h100 ","player1Role",0)
		this.guiMain.Add("ComboBox", "League|ETC", "B","player2Role",0)
		this.guiMain.Add("ComboBox", "League||ETC", "B","player3Role",0)
		this.guiMain.Add("ComboBox", "League||ETC", "B","player4Role",0)
		this.guiMain.Add("ComboBox", "League||ETC", "B","player5Role",0)
		this.guiMain.Add("ComboBox", "League||ETC", "B","player6Role",0)
		; this.guiMain.AddTextField("ComboBox", "ComboBox1", "Option1|Option2", 160, "xs +Center")
		
		this.guiMain.Add("Text", "Unknown", "xs+245 ys+20 +Center ", "player1Status",0)
		this.guiMain.Add("Text", "Unknown", "B", "player2Status",0)
		this.guiMain.Add("Text", "Unknown", "B", "player3Status",0)
		this.guiMain.Add("Text", "Unknown", "B", "player4Status",0)
		this.guiMain.Add("Text", "Unknown", "B", "player5Status",0)
		this.guiMain.Add("Text", "Unknown", "B", "player6Status",0)
		
		; Default Value but erease later
		this.guiMain.Controls["player1Enabled"].Set(1)
		this.guiMain.Controls["player2Enabled"].Set(1)
		this.guiMain.Controls["player1Id"].setText("(Hard)")
		this.guiMain.Controls["player2Id"].setText("(Support)")
		
		this.guiMain.Controls["player1Role"].select("League")
		this.guiMain.Controls["player2Role"].select("ET")
				
		return currentWindowHeight
	}
	initButtonWindow(_height){
		currentWindowHeight=50
		this.guiMain.addGroupBox("Buttons", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )
		
		this.guiMain.Add("Button", "시작[F9]", "w90 h30 xs+10 ys+15 section", "GuiStartButton", 0)
		this.guiMain.Controls["GuiStartButton"].BindMethod(this.startByGui.Bind(this))
		
		this.guiMain.Add("Button", "종료[F10]", "w90 h30 xs ys +Hidden", "GuiStopButton", 0)
		this.guiMain.Controls["GuiStopButton"].BindMethod(this.stopByGui.Bind(this))
		
		vIcon_resume=%A_ScriptDir%\Resource\Image\resume.png
		vIcon_pause=%A_ScriptDir%\Resource\Image\pause.png
		
		this.guiMain.Add("Picture", vIcon_resume, "w24 h24 x+5 yp+4 +Hidden", "GuiResumeButton", 0)
		this.guiMain.Add("Picture", vIcon_pause, "w24 h24 xp yp +Hidden", "GuiPauseButton", 0)

		this.guiMain.Controls["GuiResumeButton"].BindMethod(this.resumeByGui.Bind(this))
		this.guiMain.Controls["GuiPauseButton"].BindMethod(this.pauseByGui.Bind(this))	
		
		this.guiMain.Add("Button", "리로드[F12]", "w90 h30 X+5 yp-4 ", "GuiReloadButton", 0)
		this.guiMain.Controls["GuiReloadButton"].BindMethod(this.reloadByGui.Bind(this))
		
		this.guiMain.Add("Button", "설정", "w70 h30 X+10  ", "GuiConfigButton", 0)

		this.guiMain.Controls["GuiConfigButton"].BindMethod(this.configByGui.Bind(this))
		
		return currentWindowHeight
		
	}
	
	initLogWindow(_height){
		currentWindowHeight=200
		this.guiMain.Add("Text", "Start     ", "x10 	y" _height+5 "w200 section", "GuiLoggerTitle",0)
		this.guiMain.Add("Edit", "Logs", "Readonly xp y+5 w" this.maxGroupWidth-1 " h" currentWindowHeight-30 , "GuiLoggerLogging",0)
		; this.guiMain.addGroupBox("Logs", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )
		
		
		; this.guiMain.Add("Text", "GoodDay", "x+15 	yp w100", "GuiLoggerSubTitle",0)
		
		
		return currentWindowHeight+5
	}
	
	guiLog( title, subTitle, logMessage ){
		currentLog:=this.guiMain.Controls["GuiLoggerLogging"].get()
		this.guiMain.Controls["GuiLoggerLogging"].set( logMessage currentLog )
		this.guiMain.Controls["GuiLoggerTitle"].set( title )
	}
	initConfigWindow(_height){
		currentWindowHeight=80
		this.guiMain.addGroupBox("Config", 10, _height , this.maxGroupWidth, currentWindowHeight , , true )
		this.guiMain.Add("CheckBox", "usd Pushbullet    ", "T", "configPushbulletEnabled",0)
		this.guiMain.Add("CheckBox", "SchreenShot Error", "B", "configScreenShotOnError",0)
		
		return currentWindowHeight
	}
	
	getPaused(){	
		return this.BoolPaused
	}
	startByGui() { 
		global baseballAuto
		
		
		
		baseballAuto.start()
	}
	guiClosed(){
	
		msgbox "Closed"
	}
	stopByGui() { 
		global baseballAuto
		baseballAuto.stop()
	}
	
	configByGui( thisGui ){
			
		this.changeContents( this.toggleConfig)
		this.toggleConfig?this.toggleConfig:=false:this.toggleConfig:=true
	
	}
	
	reloadByGui() { 
		global baseballAuto, baseballAutoConfig
		baseballAuto.reload()
	
		title := this.getTitle()   
		WinGetPos, posx, posy, width, height, %title%   
		baseballAutoConfig.saveValue("GUI_POSITION", "MAIN_X", posx)
		baseballAutoConfig.saveValue("GUI_POSITION", "MAIN_Y", posy)
		
		
		Reload
	}
	started(){
		; msgbox % "Started " this.BoolPaused
		this.statusPaused:=false
		
		this.guiMain.Controls["GuiStopButton"].show()
		this.guiMain.Controls["GuiPauseButton"].show()		
		; this.guiMain.Controls["GuiResumeButton"].show()		
		this.guiMain.Controls["GuiStartButton"].hide()
	}
	pauseByGui(){
		if( this.statusPaused = false ){
			this.statusPaused:= true
			this.guiMain.Controls["GuiPauseButton"].hide()		
			this.guiMain.Controls["GuiResumeButton"].show()					
			pause
		}
	}
	resumeByGui(){
		if( this.statusPaused = true ){
			this.statusPaused:= false
			this.guiMain.Controls["GuiPauseButton"].show()		
			this.guiMain.Controls["GuiResumeButton"].hide()		
			pause
		}
	}
	stopped(){
		this.guiMain.Controls["GuiStopButton"].hide()
		this.guiMain.Controls["GuiPauseButton"].hide()
		this.guiMain.Controls["GuiResumeButton"].hide()
		this.guiMain.Controls["GuiStartButton"].show()
	}
	Activate(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="") { 
        MsgBox % "You've really done it now.`r`nCtrlHwnd= " CtrlHwnd "`r`nGuiEvent = " GuiEvent "`r`nEventInfo = " EventInfo "`r`nErrLevel = " ErrLevel
    }

	TestRoutine(){
		MsgBox % "You've activated the test subroutine!"
	}
}





; ACTIVE_ID:="(Hard)"
; BooleanDebugMode:=true

; baseballAuto := new BaseballAuto()
; baseballAutoGui := new BaseballAutoGui()