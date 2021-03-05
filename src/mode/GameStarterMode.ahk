#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class GameStartMode{

    logger:= new AutoLogger( "게임실행" ) 
    __NEW( controller ){
        this.gmaeController :=controller
    }

    checkAndRun(){
        this.skipAndroidAds()
        this.checkGameDown()
        this.skipPopupAndAds()

        ; return ImageSearcher.funcSearchImage(a,b,"asdf.png")
        ; return ImageSearcher.funcSearchImage()

    }

    checkGameDown(){
        if ( this.gmaeController.searchImageFolder("게임실행모드\Button_GameIcon") ){
            this.logger.log("컴프야 게임을 실행합니다.: 15초 wait ")
            this.gmaeController.searchAndClickFolder("게임실행모드\Button_GameIcon") 
            this.gmaeController.sleep(15)					
        }
    }
    skipAndroidAds(){
        if ( this.gmaeController.searchImageFolder("게임실행모드\Button_AdroidAds") ){
            this.logger.log("안드로이드 광고 ㅠㅠ") 
            this.gmaeController.searchAndClickFolder("게임실행모드\Button_AdroidAds",0,30) 
        }
    }
    skipPopupAndAds(){
        if ( this.gmaeController.searchImageFolder("게임실행모드\Button_NoMoreAds") ){
            this.logger.log("팝업 광고 등을 취소합니다..") 
            if( this.gmaeController.searchAndClickFolder("게임실행모드\Button_NoMoreAds") = true ){
                this.skipPopupAndAds()			
            }		
        }
    }

}