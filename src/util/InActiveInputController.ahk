#include %A_ScriptDir%\src\util\AutoLogger.ahk

class InActiveInputController{

 
    __NEW(  logger ){
        this.logger :=logger
    }

    click( x, y ) {
        global ACTIVE_ID	      
        WinGetPos, winX, winY, winW, winH, %ACTIVE_ID%
        px:=x-winX
        py:=y-winy
        this.fixedClick(px, py )             
    }

    fixedClick( posX, posY ){
        global ACTIVE_ID,BooleanDebugMode
        if( BooleanDebugMode = true ){
            this.logger.debug(" fixed Click Position " posX ", " posY )            
        }    
        lParam:= posX|posY<< 16        
        PostMessage, 0x201, 1, %lParam%, , %ACTIVE_ID% ;WM_LBUTTONDOWN
        sleep, 50	
        PostMessage, 0x202, 0, %lParam%, , %ACTIVE_ID% ;WM_LBUTTONUP       
    }
}