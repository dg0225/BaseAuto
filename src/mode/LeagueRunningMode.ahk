#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class LeagueRunningMode{

    logger:= new AutoLogger( "리그모드" ) 
    modeStatus:= "START"

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
        counter+=this.skippLeagueSchedule( )
        counter+=this.skippBattleHistory( )
        counter+=this.choicePlayType( )
        counter+=this.checkSpeedUp()
        counter+=this.skippPlayLineupStatus( )		
        counter+=this.checkSpeedUp()	
		counter+=this.skippChanceStatus( )		
        counter+=this.activateAutoPlay( )				
        counter+=this.skipLevelUpOrPopUp()
        counter+=this.checkGameResultWindow()
        counter+=this.checkMVPWindow()
        counter+=this.checkTotalLeagueEnd()
        return counter
    }

    startLeagueInMainWindow()
    {
        if ( this.gameController.searchImageFolder("리그모드\Window_Main") ){		
            this.logger.log(this.player.getAppTitle() " 리그를 돌겠습니다.")
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("리그모드\Button_league") ){
                return 1
            }			
        }
        return 0		
    }
    skippLeagueSchedule(){
        if ( this.gameController.searchImageFolder("리그모드\화면_경기일정") ){		
            this.logger.log("경기 일정 화면을 넘어갑니다.")
            this.player.setStay()
            if ( this.gameController.searchImageFolder("리그모드\화면_도전과제_상태\초과1단계") ){
                if ( this.gameController.searchImageFolder("리그모드\화면_도전과제_상태\화면_리그경기") ){
                    this.logger.log("초과 1단계 이상을 달성했습니다.")
                    this.player.setNeedSkip(true)
                }else{
                    this.logger.log("이미 포스트 시즌입니다.")
                    this.player.setPostSeason()
                } 
            }else{
                this.player.setNeedSkip(false)
            }
            if ( this.player.getWaitingResult() ){				
                this.logger.log(this.player.getAppTitle() " 정상 종료를 요청을 확인했습니다.")
                if ( this.gameController.searchImageFolder("리그모드\버튼_플레이시작_게임시작") ){
                    this.logger.log(this.player.getAppTitle() " 바이 바이.")
                    this.player.setBye()
                }else if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
                    this.logger.log("정상 요청이지만 이어하기를 수행했습니다.")
					this.gameController.sleep(15)				
                    return 1
                }
            }else{ 
                if ( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_게임시작") ){
                    return 1
                }else if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
					this.logger.log("경기가 이어합니다. 15초 기다립니다.")
					this.gameController.sleep(15)				
                    return 1
                }
            }		 
        }
        return 0		
    }		

    skippBattleHistory(){
        if ( this.gameController.searchImageFolder("리그모드\화면_상대전적") ){
            this.logger.log("전적 화면을 넘어갑니다.")
            this.player.setStay()
            if ( this.player.getWaitingResult() ){								
                if ( this.gameController.searchImageFolder("리그모드\버튼_플레이시작_게임시작") ){
                    this.logger.log(this.player.getAppTitle() " 정상 종료를 요청을 확인 하였습니다.")
                    this.player.setBye()
                }else if ( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
                    this.logger.log("중단 된 경기가 있습니다.. 15초")					
                    this.gameController.sleep(15)				
                    return 1
                }
            }else{
                if ( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_게임시작") ){
                    this.logger.log("경기가 시작 됩니다. 15초 기다립니다.")
                    this.gameController.sleep(15)
                    return 1
                }else if ( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
                    this.logger.log("경기가 이어합니다. 15초 기다립니다.")
                    this.gameController.sleep(15)				
                    return 1
                }
            }		 
        }
        return 0		
    }	
    choicePlayType(){
        if ( this.gameController.searchImageFolder("리그모드\Window_ChoicePlayType") ){
            this.player.setStay()
            if ( this.player.getBattleType() = "수비" ) {
                this.logger.log("수비 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyDepence") ){
                    this.gameController.sleep(2)
                    return 1
                }
            } else if( this.player.getBattleType() = "공격" ){
                this.logger.log("공격 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyOppence") ){
                    this.gameController.sleep(2)
                    return 1
                }
            }else{
                this.logger.log("전체 플레이 방식을 선택합니다.") 
                if ( this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_FullPlay") ){
                    this.gameController.sleep(2)
                    return 1
                }
            } 
        }

        return 0		
    }

    skippPlayLineupStatus(){
        result:=0
        if ( this.gameController.searchImageFolder("리그모드\Button_skipBeforePlay") ){
            this.logger.log(this.player.getAppTitle() " 라인업 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\Button_skipBeforePlay") = true ){				
				this.gameController.sleep(1)
                result+=1
                result+=this.skippPlayLineupStatus()			
            }					
        }        
        return result
    }
	skippChanceStatus(){
	   if ( this.gameController.searchImageFolder("리그모드\화면_찬스상황") ){
            this.logger.log(this.player.getAppTitle() " 찬스상황 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\화면_찬스상황\Button_취소") ){
                return 1
            }			
        }		
	}
    checkTotalLeagueEnd(){
        if ( this.gameController.searchImageFolder("리그모드\화면_리그_완전종료") ){
            this.logger.log(this.player.getAppTitle() " 리그가 종료 되었습니다. 우승했길....") 
            this.player.setRealFree()
        }
        return 0				
    }

    activateAutoPlay(){
        global baseballAutoConfig
        if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") ){

            this.gameController.sleep(2)			
            if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") ){
                this.logger.log("자동 방식을 활성화 합니다.") 
				WinGetPos, , , winW, winH, % this.player.getAppTitle
				if( winW < 630 )
                    this.gameController.clickRatioPos(0.744, 0.114, 10)
                else
                    this.gameController.clickRatioPos(0.76, 0.097, 20)

                this.gameController.sleep(2)			
                if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") != true ){
                    this.logger.log(this.player.getAppTitle() " 자동 게임이 시작되었습니다.") 
                    this.player.setFree()
                    return 1
                }
            }else{
                ;this.logger.log(this.player.getAppTitle() " 자동 게임이 진행 중인것으로 보입니다.") 
                this.player.setFree()
                return 1
            }

        }
        return 0		
    } 
    checkSpeedUp(){
        result:=0
        if ( this.gameController.searchImageFolder("리그모드\button_playSlow") ){
            this.logger.log("자동은 빠르게 ") 
            if ( this.gameController.searchAndClickFolder("리그모드\button_playSlow" ) = true){				
                if ( this.gameController.searchImageFolder("리그모드\화면_자동이닝설정") ){
                    this.logger.log("자동 이닝 관련 팝업이 나와 버렸습니다... 아 타이밍") 
                    if ( this.gameController.searchAndClickFolder("리그모드\화면_자동이닝설정\버튼_X" ) = true){
                        this.checkSpeedUp()
                    }
                }		
                return 1
            }
        }
        return 0		
    }
    checkAutoPlayEnding(){
        if ( this.gameController.searchImageFolder("리그모드\화면_결과_타구장" ) ){		
            this.logger.log("경기 종료를 확인했습니다.") 
            this.player.setStay()
            this.player.addResult()
            ; this.gameController.sleep(10)
            if( this.gameController.searchAndClickFolder("리그모드\화면_결과_타구장" ) ){
                return 1
            }			
        }else{
            if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){ 
                this.gameController.sleep(4)			
                if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){								
                    this.logger.log("플레이 오프 경기가 종료 된거 같습니다") 				
                    if( this.gameController.searchAndClickFolder("리그모드\화면_결과_플레이오프" ) ){
                        this.gameController.sleep(3)			
                        if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){
                            this.logger.log("오류 인거 같으니 넘어가준다.") 
                            this.player.setFree()
                            return 0
                        }else{
                            this.player.setStay()
                            this.player.addResult()
                            return 1
                        }				

                    }

                }
            } 
        }
        return 0
    }
    skipLevelUpOrPopUp(){
        if ( this.gameController.searchImageFolder("리그모드\화면_결과_레벨업_성장" ) ){		
            this.logger.log("레벨업이나 성장을 무시합니다.") 
            this.player.setStay()
            if ( this.gameController.searchAndClickFolder("리그모드\버튼_결과_레벨업_성장_X" ) ){
                return 1
            }

        }
        return 0 
    }
    checkGameResultWindow(){
        if ( this.gameController.searchImageFolder("리그모드\화면_결과_경기결과" ) ){		
            this.logger.log("경기 결과를 확인했습니다.") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("리그모드\버튼_결과_다음_확인" ) ){
                return 1
            }

        }
        return 0 
    }
    checkMVPWindow(){
        if ( this.gameController.searchImageFolder("리그모드\화면_결과_MVP" ) ){		
            this.logger.log("MVP 를 확인했습니다.") 
            this.player.setStay()
            if( this.gameController.searchAndClickFolder("리그모드\버튼_결과_다음_확인" ) ){
                return 1
            }

        }
        return 0 
    }

	/*
	checkAutoPlayEnding(){
		loop 
		{
			if( this.gameController.searchImageFolder("리그모드\화면_결과_타구장" ) ){		
				; 타구장 결과
				this.logger.log("경기 종료를 확인했습니다.")        
				break	
			}else{
				this.logger.log("경기 종료를 기다립니다.")        
				this.gameController.sleep(10)
			}
			
			if( A_index > 12 ){
				this.logger.log("2분 경과 다른 상태를 체크 합니다.")        				
				return
			}
		}
		
		; if( GuiBoolScreenShotResult = true )
			; funcCaptureSubScreen( "reward" )
			; fPrintStatus("전투 완료가 확인되었습니다.")				
	}
    */
}