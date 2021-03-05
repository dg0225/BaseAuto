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
        global BaseballAutoGui, baseballAutoConfig

        if ( ! this.started ){
            this.started:=true
            this.running:=true
            this.logger.log("BaseballAuto Started!!")

            BaseballAutoGui.started()
            this.gameController.setActiveId(baseballAutoConfig.getDefaultPlayer().getAppTitle())

            counter:=1 
            while( this.running = true ){
                if not ( this.gameController.checkAppPlayer() ){
                    this.logger.log("Application Title을 확인하세요 변경 후 save ")
                    break
                }

                for index, gameMode in this.modeArray ; Enumeration is the recommended approach in most cases.
                {
                    ; this.logger.debug(  "Element number " . index . " is " . gameMode )                                     
                    gameMode.checkAndRun()
                }

                this.gameController.sleep(5) 
                counter++

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
