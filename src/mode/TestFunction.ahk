; #include %A_ScriptDir%\src\util\MC_GameController.ahk

!F6::
	; IfExist, A_ScriptDir
	IfExist, %A_ScriptDir%\asd
	{

		msgbox "NOT"
	}
    ; targetX:=178
    ; targetY:=63
    ; MouseMove, %targetX%, %targetY%

    ; CoordMode, Pixel, Screen

    ; MouseMove, 758, 286
    ; msgbox "TEST"
    ; targetX:=758
    ; targetY:=286
    ; MouseMove, %targetX%, %targetY%

    ; BaseballAutoGui.updateStatus("player1Status","TEst")

return

