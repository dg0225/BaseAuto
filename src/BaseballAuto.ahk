#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

#include %A_ScriptDir%\src\mode\GameStarterMode.ahk
#include %A_ScriptDir%\src\mode\LeagueRunningMode.ahk

Class BaseballAuto{
    __NEW(){

        this.init()
    }

    logger:= new AutoLogger( "시 스 템" )
    ; macroGui := new MC_MacroGui( logger )

    gameController := new MC_GameController()
    modeArray := []

    init(){

        this.modeArray.Push( new GameStartMode( this.gameController ) ) 
        this.modeArray.Push( new LeagueRunningMode( this.gameController ) ) 
        this.logger.log("BaseballAuto Ready !")
    }

    start(){
        global BaseballAutoGui, baseballAutoConfig, globalCurrentPlayer,globalContinueFlag

        if ( ! this.started ){
            this.started:=true
            this.running:=true
            this.logger.log("BaseballAuto Started!!")

            BaseballAutoGui.started()

            while( this.running = true ){ 
                if ( baseballAutoConfig.enabledPlayers.length() = 0 ){
                    this.running:=false
                    this.logger.log("가능한 AppPlayer가 없습니다.")
                }

                for playerIndex, player in baseballAutoConfig.enabledPlayers{
                    globalCurrentPlayer:=player
                    globalCurrentPlayer.setCheck()
                    if( globalCurrentPlayer.needToStop()){
                        baseballAutoConfig.enabledPlayers.remove(playerIndex)
                        if( baseballAutoConfig.enabledPlayers.length() = 0 )
                            this.running:=false
                        continue
                    }
                    this.gameController.setActiveId(player.getAppTitle())
                    globalContinueFlag:=false
                    
                    while( this.running = true ){
                        localChecker:=0
                        if not ( this.gameController.checkAppPlayer() ){
                            this.logger.log("Application Title을 확인하세요 변경 후 save ")

                            baseballAutoConfig.enabledPlayers.remove(playerIndex)
                            if( baseballAutoConfig.enabledPlayers.length() = 0 )
                                this.running:=false 
                            break
                        }					
                        for index, gameMode in this.modeArray ; Enumeration is the recommended approach in most cases.
                        {
                            gameMode.setPlayer(player) 
                            localChecker+=gameMode.checkAndRun()
                        } 
                        this.gameController.sleep(3) 						
                        this.logger.log( player.getAppTitle() " = LocalChecker Count=" localChecker)
                        if ( !player.needToStay() ){ 
                            ; this.logger.log( "AUTO_PLAYING 확인. " globalCurrentPlayer.getAppTitle())
                            break
                        }else{
                            ; Stay 를 벗어 나게 해주자
                            if ( localChecker = 0 ){
                                this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 풀어주자")
                                this.player.setUnkown()
                                break
                            }                             
                        }
                    } 
                    globalCurrentPlayer.setCheckDone()

                } 
            }

        }else{ 
            this.logger.log("BaseballAuto Already Started!!")
        }
        this.logger.log("BaseballAuto Done!!")
        this.stop()
    }
    tryStop(){
        this.logger.log("try to stop!")
        this.running := false
    }
    stop(){
        global BaseballAutoGui
        if ( this.started ){
            this.started:=false
            this.logger.log("BaseballAuto Stopped!!")
            BaseballAutoGui.stopped()

        }else{
            this.logger.log("BaseballAuto Already Stopped!!")

        }
    }

    reload(){
        this.logger.log(" reload Call")
    }

}
