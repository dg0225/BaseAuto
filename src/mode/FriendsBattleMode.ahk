﻿#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class FriendsBattleMode{

    logger:= new AutoLogger( "친구대전" ) 

    closeChecker:=0

    __NEW( controller )
    {
        this.gameController :=controller
    }

    setPlayer( _player )
    {
        this.player:=_player
    }

    checkAndRun()
    {
        counter:=0

        counter+=this.startBattleMode( ) 	
        counter+=this.selectFriendsBattle( )
        counter:= this.selectTopFriends( )
        counter+=this.startFriendsBattle( )
        counter+=this.playFriendsBattle( ) 
        ; counter+=this.checkSlowAndChance( ) 
        counter+=this.checkPlaying( )

        counter+=this.checkGameResultWindow( )
        counter+=this.checkMVPWindow( )

        counter+=this.checkPopup( )        
        counter+=this.receiveReward( ) 	
        return counter
    }

    startBattleMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "친구 대전 을 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_대전_팀별") ){
                return 1
            }
        }
        return 0
    }
    
    selectFriendsBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2.대전모드_Base") ){		
            this.player.setStay()
            this.logger.log("친구 대전을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_친구대전") ){
                return 1
            }		 
        }
        return 0		
    }		

    selectTopFriends(){
        if ( this.gameController.searchImageFolder("친구대전\버튼_탑대상") ){		
            this.player.setStay()
            this.logger.log("젤 위 대상을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("친구대전\버튼_탑대상",0,30) ){
                return 1
            }		 
        }else{
            return 10
        }
        return 0	

    }

    startFriendsBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2-2.친구대전_Base") ){		 
            if ( this.gameController.searchImageFolder("친구대전\화면_대상선택상태") ){		
                this.player.setStay()
                this.logger.log("친구 대전을 시작합니다") 
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                    return 1
                }		 
            }else{
                this.logger.log("친구가 없어서 시작하지 않습니다.") 
                this.player.setFree()
                return 1
            }
        }
        return 0		
    }

    playFriendsBattle(){
        if ( this.gameController.searchImageFolder("친구대전\화면_친구대전준비") ){		
            this.player.setStay()
            this.logger.log("친구대전 경기를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.logger.log("5초 기다립니다") 
                this.gameController.sleep(5)
                return 1
            }		 
        }
        return 0		
    } 

    checkPopup(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("1.공통\버튼_팝업스킵" ) ){		
            if( this.gameController.searchAndClickFolder("1.공통\버튼_팝업스킵" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }
        }

        if ( this.gameController.searchImageFolder("친구대전\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("친구대전\화면_팝업체크\버튼_확인" ) ){
                if( localCounter > 5 ){
                    return localCounter
                }
                localCounter++ 
                this.checkPopup(localCounter)
            }			
        }
        return localCounter
    }

    checkPlaying(){
        ; 자동체크를 하기에는 위험한거 같아 그냥 2초씩 쉰다.
        ; if ( this.gameController.searchImageFolder("친구대전\화면_자동중" ) ){		
        ; this.player.setStay()
        this.gameController.sleep(2)
        ; return 1
        ; }
        return 0 
    }  

    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_경기_결과" ) ){		
            this.logger.log("경기 결과를 확인했습니다.") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                return 1
            }
        }
        return 0 
    }

    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("1.공통\화면_MVP" ) ){		
            this.logger.log("MVP 를 확인했습니다.") 
            if( this.gameController.searchAndClickFolder("1.공통\버튼_다음_확인" ) ){
                this.player.addResult()

                if( this.player.needToStopFriendsBattle() ){
                    this.logger.log("친구대전을 다 돌았습니다.") 
                    this.player.setBye()
                }else{
                    this.logger.log("친구 대전이 " this.player.getRemainFriendsBattleCount() "회 남았습니다." )                    
                    this.player.setFree()
                }
                return 1
            }
        }
        return 0 
    }

    receiveReward(){
        if ( this.gameController.searchImageFolder("친구대전\버튼_모두받기" ) ){		
            this.logger.log("받아라!! 보상 없어질라") 
            if( this.gameController.searchAndClickFolder("친구대전\버튼_모두받기" ) ){
                this.gameController.searchAndClickFolder("친구대전\버튼_모두받기\버튼_확인" )
                return 1
            }
        }
        return 0 
    }
}