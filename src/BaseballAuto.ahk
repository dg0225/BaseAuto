#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

#include %A_ScriptDir%\src\mode\GameStarterMode.ahk
#include %A_ScriptDir%\src\mode\LeagueRunningMode.ahk
#include %A_ScriptDir%\src\mode\RealTimeBattleMode.ahk

Class BaseballAuto{
    __NEW(){

        this.init()
    }

    logger:= new AutoLogger( "시 스 템" )
    ; macroGui := new MC_MacroGui( logger )

    gameController := new MC_GameController()
    typePerMode := Object()
    

    init(){

        
        this.typePerMode["리그"]:=[]
        this.typePerMode["리그"].Push(new GameStartMode( this.gameController ) ) 
        this.typePerMode["리그"].Push(new LeagueRunningMode( this.gameController ) ) 

        this.typePerMode["대전"]:=[]
        this.typePerMode["대전"].Push(new GameStartMode( this.gameController ) ) 
        this.typePerMode["대전"].Push(new RealTimeBattleMode( this.gameController ) ) 

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
                                        
                    if( globalCurrentPlayer.needToStop()){
                        baseballAutoConfig.enabledPlayers.remove(playerIndex)
                        if( baseballAutoConfig.enabledPlayers.length() = 0 )
                            this.running:=false
                        continue
                    }

                    globalCurrentPlayer.setCheck()
                    this.gameController.setActiveId(player.getAppTitle())
                    globalContinueFlag:=false

                    loopCount:=0
                    while( this.running = true ){
                        localChecker:=0
                        if not ( this.gameController.checkAppPlayer() ){
                            this.logger.log("Application Title을 확인하세요 변경 후 save ")

                            baseballAutoConfig.enabledPlayers.remove(playerIndex)
                            if( baseballAutoConfig.enabledPlayers.length() = 0 )
                                this.running:=false 
                            break
                        }                    
                        
                        ; msgbox % this.typePerMode[globalCurrentPlayer.getRole()]
                        modeList:= this.typePerMode[globalCurrentPlayer.getRole()]
                        for index, gameMode in modeList ; Enumeration is the recommended approach in most cases.
                        {
                            gameMode.setPlayer(player) 
                            localChecker+=gameMode.checkAndRun()
                        } 
                        if( globalCurrentPlayer.getRole() ="리그")
                            this.gameController.sleep(3)
                        ; this.logger.log( player.getAppTitle() " checker count=" localChecker)
                        if ( !player.needToStay() ){ 
                            ; this.logger.log( "AUTO_PLAYING 확인. " globalCurrentPlayer.getAppTitle())
                            break
                        }else{
                            ; Stay 를 벗어 나게 해주자
                            if ( localChecker = 0 ){
                                if( globalCurrentPlayer.getRole() ="리그"){
                                    if ( loopCount > 60 ){
                                        this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 풀어주자")
                                        player.setUnknwon()
                                    }
                                }else{
                                    if ( loopCount > 180 ){
                                        this.logger.log("ERROR : 갇혀 있으면 다른애들이 불쌍하다.. 풀어주자")
                                        player.setUnknwon()
                                    }
                                }
                                loopCount+=1
                            } else{
                                loopCount:=0
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
