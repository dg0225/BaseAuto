#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class HomrunDerbyMode{

    logger:= new AutoLogger( "홈런더비" ) 

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

        counter+=this.startSpecialMode( ) 	
        counter+=this.selectHomrunDerby( )
        counter+=this.startHomerunDerby( )
        counter+=this.skipPlayerProfile( )
        ; counter+=this.checkSlowAndChance( ) 

        counter+=this.checkGameResultWindow( )
        counter+=this.checkMVPWindow( )
        counter+=this.receiveReward( ) 	
        counter+=this.checkPopup( )
        counter+=this.checkPlaying( )
        counter+=this.checkFriendsBattleClose( )
        return counter
    }

    startSpecialMode(){
        if ( this.gameController.searchImageFolder("0.기본UI\0.메인화면_Base") ){
            this.logger.log(this.player.getAppTitle() "홈런더비를 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("0.기본UI\0.메인화면_버튼_스페셜_팀별") ){
                return 1
            }
        }
        return 0
    }

    selectHomrunDerby(){
        if ( this.gameController.searchImageFolder("0.기본UI\3.스페셜모드_Base") ){		
            this.player.setStay()
            this.logger.log("홈런 더비를 선택합니다") 
            if ( this.gameController.searchAndClickFolder("0.기본UI\3.스페셜모드_버튼_홈런더비") ){
                return 1
            }		 
        }
        return 0		
    }		

    startHomerunDerby(){
        if ( this.gameController.searchImageFolder("0.기본UI\3-1.홈런더비_Base") ){		 
            this.logger.log("홈런 더비를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("1.공통\버튼_게임시작") ){ 
                this.logger.log("6초 기다립니다") 
                this.gameController.sleep(6)
                return 1
            }		 
        }
        return 0		
    }
    skipPlayerProfile(){
        if ( this.gameController.searchAndClickFolder("홈런더비모드\화면_투수프로필") ){		 
            this.logger.log("홈런 더비 프로필 클릭 합니다~") 
            this.gameController.sleep(1)
            this.logger.log("홈런 더비 시작 하자!!") 
            this.gameController.clickRatioPos(0.5, 0.6, 80)
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
        ; 아직 아래 없음
        if ( this.gameController.searchImageFolder("홈런더비모드\화면_팝업체크" ) ){		
            this.logger.log("팝업을 제거합니다. 보상을 안받았나.") 
            if( this.gameController.searchAndClickFolder("홈런더비모드\화면_팝업체크\버튼_확인" ) ){
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

    checkFriendsBattleClose(){
        ; 더이상 돌 친구가 없다 등을 체크하던가
        ; 횟수 제한을 여기에다 넣도록 하자.
        ; if ( this.gameController.searchImageFolder("친구대전\화면_친구대전종료" ) ){		
        ;     this.player.setStay()
        ;     this.logger.log("친구대전은 다 돌았네요") 
        ;     if( this.gameController.searchAndClickFolder("친구대전\화면_친구대전종료\버튼_확인" ) ){
        ;         this.player.setFree()
        ;         return 1
        ;     }
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
                this.player.setFree()
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