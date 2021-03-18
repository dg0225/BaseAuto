#SingleInstance, Force

#include %A_ScriptDir%\src\external\Gdip_all.ahk
#include %A_ScriptDir%\src\external\Gdip_ImageSearch.ahk
#include %A_ScriptDir%\src\util\AutoLogger.ahk

Class InActiveImageSearcher{

    pathPrefix:="\Resource\Image\"
    percentage:=30
    currentHwnd:=""
    ; currentTargetTitle:=""

    __NEW( _logger ){
        global DEFAULT_APP_ID
        this.logger :=_logger
        ; this.currentTargetTitle:=DEFAULT_APP_ID
        this.currentHwnd:=WinExist(DEFAULT_APP_ID)
    }
    possible(){
        ; this.currentTargetTitle:=DEFAULT_APP_ID
        ; this.logger.log( this.currentTargetTitle "를 확인합니다" )
        return this.currentHwnd
    }
    setActiveId( targetId ){
        ; this.logger.log( targetId "를 설정합니다" )
        ; this.currentTargetTitle:=targetId
        this.currentHwnd:=WinExist(targetId)
    }
    ; funcSearchImage( ByRef intPosX, Byref intPosY, target ) {

    ;     CoordMode, Pixel, Screen

    ;     ; this.logger.debug( target "을 찾고 있습니다." )
    ;     WinGetPos, winX, winY, winW, winH, % this.currentTargetTitle		

    ;     target:=% A_ScriptDir this.pathPrefix target	

    ;     ImageSearch, oX, oY, winX, winY, winX+winW, winY+winH, % "*" this.percentage " " target		
    ;     If( ErrorLevel = 0 ){
    ;         intPosX := oX
    ;         intPosY := oY 
    ;         ; this.logger.debug( target "을 찾았습니다. X=" intPosX ", Y=" intPosY )
    ;         return true
    ;     }else If(Errorlevel = 2){		
    ;         ; this.logger.debug( "ERROR ---" target "파일자체가 존재하지 않습니다." )
    ;         return false
    ;     }
    ;     return false
    ; }

    prepare(){
        this.pToken:=Gdip_Startup() 
        this.pBitmapHayStack:=Gdip_BitmapFromhwnd(this.currentHwnd) 
    }
    done(){
        Gdip_DisposeImage(this.pBitmapHayStack)
        Gdip_Shutdown(this.pToken)
    }
    funcSearchImage( ByRef intPosX, ByRef intPosY, target, fullSet:=false) {
        ; target:=% A_ScriptDir this.pathPrefix target
        if( fullSet ){
            this.prepare()
        }
        findResult:=false 
        pBitmapNeedle:=Gdip_CreateBitmapFromFile(A_ScriptDir this.pathPrefix target)         
        ; Sleep, 1000
        if Gdip_ImageSearch( this.pBitmapHayStack,pBitmapNeedle, resultList ,0,0,0,0,10,0x000000,1,1) { 
            StringSplit, LISTArray, resultList, `, 
            intPosX:=LISTArray1 
            intPosY:=LISTArray2
            ; this.logger.log( target "을 찾았습니다. X=" intPosX ", Y=" intPosY )
            findResult:=true
            Gdip_DisposeImage(pBitmapNeedle)
        }
        else {
            ; this.logger.log( target "을 찾지 못했습니다." )
            findResult:=false
            Gdip_DisposeImage(pBitmapNeedle)
        }
        if( fullSet){
            this.done()
        }
        return findResult
    }
}