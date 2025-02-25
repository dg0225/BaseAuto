﻿#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class RankingBattleMode{

    logger:= new AutoLogger( "랭킹대전" ) 
    
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
        counter+=this.startFriendsBattle( )
        counter+=this.playFriendsBattle( ) 
        counter+=this.checkSlowAndChance( ) 

        counter+=this.checkGameResultWindow( )
        counter+=this.checkMVPWindow( )
        counter+=this.checkPopup( )
        counter+=this.checkPlaying( )
        counter+=this.checkRankingClose( )
        return counter
    }

    startBattleMode()
    {
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){		
            this.logger.log(this.player.getAppTitle() "랭킹 대전 을 시작합니다")
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
            this.logger.log("랭킹 대전을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\2.대전모드_버튼_랭킹대전") ){
                return 1
            }		 
        }
        return 0		
    }		
    startFriendsBattle(){
        if ( this.gameController.searchImageFolder("0.기본UI\2-1.랭킹대전_Base") ){		

            if ( this.gameController.searchImageFolder("랭대모드\화면_상대있음") ){		
                this.player.setStay()
                this.logger.log("랭킹 대전을 시작합니다") 
                if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){                    
                    return 1
                }		 
            }else{
                this.closeChecker++                
                this.logger.log("랭대 다 돈거 같아 시작하지 않습니다. .." + this.closeChecker) 
                if( this.closeChecker > 2 ){
                    this.closeChecker:=0
                    this.player.setBye()
                }else{
                    this.player.setFree()
                }                
                return 1
            }
        }
        return 0		
    }
    playFriendsBattle(){
        if ( this.gameController.searchImageFolder("랭대모드\화면_랭킹대전준비") ){		
            this.player.setStay()
            this.logger.log("경기를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){
                this.logger.log("4초 기다립니다") 
                this.gameController.sleep(4)
                return 1
            }		 
        }
        return 0		
    } 

    checkSlowAndChance(counter:=0){
        localCounter:=counter
        if ( this.gameController.searchImageFolder("1.공통\화면_찬스" ) ){		
            this.logger.log("찬스는 하지 않겠다") 
            if( this.gameController.searchAndClickFolder("1.공통\화면_찬스\버튼_취소" ) ){
                if( localCounter > 5 )
                    return localCounter
                localCounter++
                this.checkSlowAndChance(localCounter)
            }			
        }
        if( this.gameController.searchAndClickFolder("1.공통\버튼_빠르게" ) ){
            this.logger.log("빠르게 빠르게..") 
            localCounter++ 
            return localCounter
        }			
        return localCounter
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

        if ( this.gameController.searchImageFolder("랭대모드\화면_팝업체크" ) ){		
            this.logger.log("주말 팝업인가.") 
            if( this.gameController.searchAndClickFolder("랭대모드\화면_팝업체크\버튼_확인" ) ){
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
        if ( this.gameController.searchImageFolder("랭대모드\화면_자동중" ) ){		
            this.player.setStay()
            this.gameController.sleep(2)
            return 1
        }
        return 0 
    }

    checkRankingClose(){
        if ( this.gameController.searchImageFolder("랭대모드\화면_랭대종료" ) ){		
            this.player.setStay()
            
            this.logger.log("랭대는 이제 다 돌았네요") 
            if( this.gameController.searchAndClickFolder("랭대모드\화면_랭대종료\버튼_확인" ) ){
                this.player.setFree()
                return 1
            }
        }
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
                this.closeChecker:=0
                this.player.addResult()
                this.player.setFree()                            
                return 1
            }
        }
        return 0 
    }

}