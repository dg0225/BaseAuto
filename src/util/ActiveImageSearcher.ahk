#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class ActiveImageSearcher{

 
    pathPrefix:="\Resource\Image\"
    percentage:=50
    
    
    __NEW(  _logger ){
        this.logger :=_logger
    }
    
      
    funcSearchImage(  ByRef intPosX, Byref intPosY, target ) {
        CoordMode, Pixel, Screen
        global ACTIVE_ID
        ; this.logger.debug( target "을 찾고 있습니다." )
        WinGetPos, winX, winY, winW, winH, %ACTIVE_ID%			
        ImageSearch, oX, oY, winX, winY, winX+winW, winY+winH, % "*" this.percentage " " A_ScriptDir this.pathPrefix target		
        If( ErrorLevel = 0 ){
            intPosX := oX
            intPosY := oY               
            this.logger.debug( target "을 찾았습니다. X=" intPosX ", Y=" intPosY )
            return true
        }else If(Errorlevel = 2){		
            this.logger.debug( "ERROR ---" target "파일자체가 존재하지 않습니다." )
            return false
        }
        return false
    }
   
}