#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class GameStartMode{

    logger:= new AutoLogger( "게임실행" ) 
    __NEW( controller ){
        this.gmaeController :=controller
    }

    checkAndRun(){
        counter:=0
        counter+=this.skipAndroidAds()
        counter+=this.checkGameDown()
        counter+=this.skipPopupAndAds()
        return counter
    }
    setPlayer( _player )
    {
        this.player:=_player
    }
    checkGameDown(){
        if ( this.gmaeController.searchImageFolder("게임실행모드\Button_GameIcon") ){
            this.player.setStay()
            this.logger.log("컴프야 게임을 실행합니다.: 15초 wait ")
            if( this.gmaeController.searchAndClickFolder("게임실행모드\Button_GameIcon") ){
                this.gmaeController.sleep(15)					
                return 1
            } 
        }
        return 0
    }
    skipAndroidAds(){

        if ( this.gmaeController.searchImageFolder("게임실행모드\Button_AdroidAds") ){
            this.player.setStay() 
            this.logger.log("안드로이드 광고를 클릭합니다.") 
            if( this.gmaeController.searchAndClickFolder("게임실행모드\Button_AdroidAds") ){
                return 1
            } 
        }
        return 0
    }
    skipPopupAndAds(){
        result:=0
        if ( this.gmaeController.searchImageFolder("게임실행모드\Button_NoMoreAds") ){
            this.player.setStay()
            this.logger.log("팝업 광고 등을 취소합니다..") 
            if ( this.gmaeController.searchAndClickFolder("게임실행모드\Button_NoMoreAds") = true ){
                result+=1
                result+=this.skipPopupAndAds()			
            }		
        }
        return result
    }

}