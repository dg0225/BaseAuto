#include %A_ScriptDir%\src\util\MC_GameController.ahk

!F6::
    localController := new MC_GameController()
    localController.setActiveId("(MEmu1)")
    localController.clickRatioPos(0.80, 0.12, 20)
    
return
