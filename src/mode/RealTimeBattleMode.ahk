#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class RealTimeBattleMode{

    logger:= new AutoLogger( "실시간배틀" ) 

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
        counter+=this.startLeagueInMainWindow( ) 	
        counter+=this.selectRealTimeBattle( )
        counter+=this.startRealTImeBattle( )
        counter+=this.playStartRealTimeBattle( ) 
        counter+=this.runBunt( )
        counter+=this.runStrike( )
        counter+=this.skippPlayLineupStatus( )
        counter+=this.checkPopup( )
        counter+=this.checkBattleEnd( )

        return counter
    }

    startLeagueInMainWindow()
    {
        if ( this.gameController.searchImageFolder("리그모드\Window_Main") ){		
            this.logger.log(this.player.getAppTitle() "실시간 배틀을 시작합니다")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("실시간대전\버튼_메인대전_팀별") ){
                return 1
            }			
        }
        return 0		
    }
    selectRealTimeBattle(){
        if ( this.gameController.searchImageFolder("실시간대전\화면_대전모드") ){		
            this.player.setStay()
            this.logger.log("실시간 대전을 선택합니다") 
            if ( this.gameController.searchAndClickFolder("실시간대전\버튼_실시간대전") ){
                return 1
            }		 
        }
        return 0		
    }		
    startRealTimeBattle(){
        if ( this.gameController.searchImageFolder("실시간대전\화면_실시간대전") ){		
            this.player.setStay()
            this.logger.log("실시간 대전을 시작합니다") 
            if ( this.gameController.searchAndClickFolder("실시간대전\버튼_실시간대전_시작") ){
                this.logger.log("15초 기다립니다") 
                this.gameController.sleep(15)
                return 1
            }		 
        }
        return 0		
    }
    playStartRealTimeBattle(){
        if ( this.gameController.searchImageFolder("실시간대전\버튼_경기시작") ){		
            this.player.setStay()
            this.logger.log("경기를 시작합니다") 
            if ( this.gameController.searchAndClickFolder("실시간대전\버튼_경기시작") ){
                return 1
            }		 
        }
        return 0		
    } 
    runBunt(){
        if ( this.gameController.searchAndClickFolder("실시간대전\실행_번트") ){
            this.gameController.sleep(3)			
            return 1
        }
        return 0		
    }
    runStrike(){
        if ( this.gameController.searchAndClickFolder("실시간대전\실행_속구") ){
            return this.runStrike()
        }
        return 0		
    }
    skippPlayLineupStatus(){
        if ( this.gameController.searchImageFolder("실시간대전\버튼_스킵스킵") ){
            this.logger.log(this.player.getAppTitle() " - 스킵합니다") 
            if( this.gameController.searchAndClickFolder("실시간대전\버튼_스킵스킵") = true ){				
                return 1			
            }
        }
        return 0 
    }
    checkPopup(){
        if ( this.gameController.searchImageFolder("실시간대전\화면_매칭취소" ) ){		
            this.logger.log("팝업이 떴네.") 
            if( this.gameController.searchAndClickFolder("실시간대전\화면_매칭취소\버튼_확인" ) ){
                return 1
            }			
        }
        return 0

    }
    checkBattleEnd(){
        if ( this.gameController.searchImageFolder("실시간대전\화면_경기결과" ) ){		
            this.logger.log("대전 종료를 확인했습니다.") 
            this.player.setFree()
            this.player.addResult()
            if( this.gameController.searchAndClickFolder("실시간대전\버튼_다음" ) ){
                return 1
            }			
        }
        return 0
    }

    skippChanceStatus(){
        if ( this.gameController.searchImageFolder("리그모드\화면_찬스상황") ){
            this.logger.log(this.player.getAppTitle() " 찬스상황 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\화면_찬스상황\Button_취소") ){
                return 1
            }			
        }		
    }

}