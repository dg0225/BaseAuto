#include %A_ScriptDir%\src\BaseballAuto.ahk
#include %A_ScriptDir%\src\BaseballAutoGui.ahk
#include %A_ScriptDir%\src\util\IniController.ahk
#include %A_ScriptDir%\src\util\MC_Information.ahk

; #include %A_ScriptDir%\src\gui\MC_MacroGui.ahk

ACTIVE_ID:="(Hard)"
BooleanDebugMode:=true

baseballAutoGui := new BaseballAutoGui("baseball")
baseballAuto := new BaseballAuto()
baseballAutoConfig := new IniController( A_ScriptDir "/Config/main.ini" )
basballAutoInfo :=new MC_Information( baseballAutoConfig)

xPos:= baseballAutoConfig.loadValue("GUI_POSITION", "MAIN_X")
yPos:= baseballAutoConfig.loadValue("GUI_POSITION", "MAIN_Y")
(xPos = "") ? (xPos:=1150):
(yPos = "") ? (yPos:=0):   
baseballAutoGui.show( xPos , yPos )


^F9::
	baseballAuto.start()
return 

^F10::
    baseballAuto.stop()
return 


^F12:: 
    WinActivate BaseAuto.ahk
	Send, ^s
	
	global baseballAuto
    baseballAuto.reload()
    Reload
return 


baseballGuiClose:
{
	global baseballAutoGui
	title := baseballAutoGui.getTitle()   
	WinGetPos, posx, posy, width, height, %title%   
	baseballAutoConfig.saveValue("GUI_POSITION", "MAIN_X", posx)
	baseballAutoConfig.saveValue("GUI_POSITION", "MAIN_Y", posy)
	ExitApp
}

#include %A_ScriptDir%\src\mode\TestFunction.ahk