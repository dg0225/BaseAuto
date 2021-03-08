#include %A_ScriptDir%\src\util\MC_GameController.ahk

!F6::
    localController := new MC_GameController()
    localController.setActiveId("(1)")
    ; localController.clickRatioPos(0.80, 0.12, 20)
    localController.clickRatioPos(0.744, 0.114, 10)
return
