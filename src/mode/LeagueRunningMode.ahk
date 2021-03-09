#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

Class LeagueRunningMode{

    logger:= new AutoLogger( "리그모드" ) 
    modeStatus:= "START"
    __NEW( controller ){
        this.gameController :=controller
    }
	
	setPlayer( _player )
	{
		this.player:=_player
	}
    checkAndRun(){
        this.startLeagueInMainWindow(  ) 	
        this.skippLeagueSchedule(  )
        this.skippBattleHistory(  )
        this.choicePlayType(  )
		this.checkSpeedUp()
        this.skippPlayLineupStatus(  )
		this.checkSpeedUp()
        this.activateAutoPlay(  )		
        this.checkAutoPlayEnding()
        this.skipLevelUpOrPopUp()
        this.checkGameResultWindow()
        this.checkMVPWindow()
        
    }
    startLeagueInMainWindow(){
        if ( this.gameController.searchImageFolder("리그모드\Window_Main") ){		
			this.player.setStay()
            this.logger.log(this.player.getAppTitle() " 리그를 돌겠습니다.")
            ; Loop상 일단 클리만 수행한다.
            this.gameController.searchAndClickFolder("리그모드\Button_league")
            ; if( this.gameController.searchAndClickFolder("리그모드\Button_league")  ){
            ; this.skippLeagueSchedule()
            ; }
        }
    }
	skippLeagueSchedule(){
        if ( this.gameController.searchImageFolder("리그모드\화면_경기일정") ){		
			if( this.player.getWaitingResult() ){				
				if( this.gameController.searchImageFolder("리그모드\버튼_플레이시작_게임시작") ){
					this.logger.log("정상 종료를 요청 하였습니다.")
					this.player.setBye()
				}else if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
					this.logger.log("중단 된 경기가 있습니다..")					
				}
			}else{
				this.logger.log("일정 화면을 넘어갑니다.")
				if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_게임시작") ){
				
				}else if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
				
				}
			}		  
        }
    }		
	
   skippBattleHistory(){
        if ( this.gameController.searchImageFolder("리그모드\화면_상대전적") ){
            
			if( this.player.getWaitingResult() ){				
				if( this.gameController.searchImageFolder("리그모드\버튼_플레이시작_게임시작") ){
					this.logger.log("정상 종료를 요청 하였습니다.")
					this.player.setBye()
				}else if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
					this.logger.log("중단 된 경기가 있습니다.. 10초")					
					this.gameController.sleep(10)				
				}
			}else{
				this.logger.log("전적 화면을 넘어갑니다.")
				if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_게임시작") ){
					this.logger.log("경기가 시작 됩니다. 10초 기다립니다.")
					this.gameController.sleep(10)
				}else if( this.gameController.searchAndClickFolder("리그모드\버튼_플레이시작_이어하기") ){
					this.logger.log("경기가 이어합니다. 10초 기다립니다.")
					this.gameController.sleep(10)				
				}
			}		           
        }		
    }	
    choicePlayType(){
        if ( this.gameController.searchImageFolder("리그모드\Window_ChoicePlayType") ){
			this.player.setStay()
			if( this.player.getBattleType() = "D" ){
				this.logger.log("수비 방식을 선택합니다.") 
				this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyDepence")
			} else if( this.player.getBattleType() = "O" ){
				this.logger.log("공격 방식을 선택합니다.") 
				this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_OnlyOppence")
			}else{
				this.logger.log("전체 플레이 방식을 선택합니다.") 
				this.gameController.searchAndClickFolder("리그모드\Window_ChoicePlayType\Button_FullPlay")
			}            
			this.gameController.sleep(2)
        }
    }

    skippPlayLineupStatus(){
        if ( this.gameController.searchImageFolder("리그모드\Button_skipBeforePlay") ){
            this.logger.log(this.player.getAppTitle() " 라인업 등을 넘어갑니다.") 
            if( this.gameController.searchAndClickFolder("리그모드\Button_skipBeforePlay") = true ){
                this.skippPlayLineupStatus()			
            }		
        }
		
		if ( this.gameController.searchImageFolder("리그모드\화면_찬스상황") ){
            this.logger.log(this.player.getAppTitle() " 찬스상황 등을 넘어갑니다.") 
            this.gameController.searchAndClickFolder("리그모드\화면_찬스상황\Button_취소")                
        }		
    }
	checkTotalLeagueEnd(){
		if ( this.gameController.searchImageFolder("리그모드\리그모드\화면_리그_완전종료") ){
			this.player.setRealFree()
		}		
	}
	
    activateAutoPlay(){
        global  baseballAutoConfig
        if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") ){
            ; if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop\check_Stop") ){
            ; 자동 중 다시 자동 play를 하지 말아라...				
            this.gameController.sleep(2)			
            if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") ){
                this.logger.log("자동 방식을 활성화 합니다.") 

                if( baseballAutoConfig.enabledPlayers.length() > 1 )
					this.gameController.clickRatioPos(0.744, 0.114, 10)
                else
                    this.gameController.clickRatioPos(0.76, 0.097, 20)
					
                this.gameController.sleep(2)			
                if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop") != true ){
                    this.player.setFree()
                    return true
                }
            }else{
                this.player.setFree()
            }
        }
    } 
    checkSpeedUp(){
        if ( this.gameController.searchImageFolder("리그모드\button_playSlow") ){
            this.logger.log("자동은 빠르게 ") 
            if( this.gameController.searchAndClickFolder("리그모드\button_playSlow" ) = true){
				if ( this.gameController.searchImageFolder("리그모드\화면_자동이닝설정") ){
					if( this.gameController.searchAndClickFolder("리그모드\화면_자동이닝설정\버튼_X" ) = true){
						this.checkSpeedUp()
					}
				}		
			}
        }		
    }
    checkAutoPlayEnding(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_타구장" ) ){		
			this.player.setStay()
            this.logger.log("경기 종료를 확인했습니다.") 
            ; this.gameController.sleep(10)
            this.gameController.searchAndClickFolder("리그모드\화면_결과_타구장" ) 
        }else{
			if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){
				; if ( this.gameController.searchImageFolder("리그모드\WIndow_GameStop\check_Stop") ){
				; 자동 중 다시 자동 play를 하지 말아라...
				this.gameController.sleep(3)			
				if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){					
					this.logger.log("플레이 오프 류 종료") 				
					this.gameController.searchAndClickFolder("리그모드\화면_결과_플레이오프" )            
					this.gameController.sleep(3)			
					if ( this.gameController.searchImageFolder("리그모드\화면_결과_플레이오프") ){
						this.logger.log("오류 인거 같으니 넘어가준다.") 
						this.player.setFree()
					}else{
						this.player.setStay()
					}				
				}
			}
		}
    }
    skipLevelUpOrPopUp(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_레벨업_성장" ) ){		
			this.player.setStay()
            this.logger.log("레벨업이나 성장을 무시합니다.") 
            this.gameController.searchAndClickFolder("리그모드\버튼_결과_레벨업_성장_X" ) 
        }		
    }
    checkGameResultWindow(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_경기결과" ) ){		
			this.player.setStay()
            this.logger.log("경기 결과를 확인했습니다.") 
            this.gameController.searchAndClickFolder("리그모드\버튼_결과_다음_확인" ) 
        }			
    }
    checkMVPWindow(){
        if( this.gameController.searchImageFolder("리그모드\화면_결과_MVP" ) ){		
			this.player.setStay()
            this.logger.log("MVP 를 확인했습니다.") 
            ; this.gameController.sleep(10)
            this.gameController.searchAndClickFolder("리그모드\버튼_결과_다음_확인" ) 
        }			
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