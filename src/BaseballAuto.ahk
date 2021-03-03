#include %A_ScriptDir%\src\util\AutoLogger.ahk
#include %A_ScriptDir%\src\util\MC_GameController.ahk

#include %A_ScriptDir%\src\mode\GameStarterMode.ahk
#include %A_ScriptDir%\src\mode\LeagueRunningMode.ahk



Class BaseballAuto{
	__NEW(){
	
		this.init()
	}

    systemFileLogger:= new AutoLogger( "시 스 템" )
	; macroGui := new MC_MacroGui( systemFileLogger )
	
    gameController := new MC_GameController()
    modeArray := []
    
    init(){
        
        this.modeArray.Push( new GameStartMode( this.gameController ) )     
		this.modeArray.Push( new LeagueRunningMode( this.gameController ) )     
		this.systemFileLogger.log("BaseballAuto Ready !")
    }
      
    start(){
		global BaseballAutoGui
        
        if ( ! this.started ){
            this.started:=true
            this.systemFileLogger.log("BaseballAuto Started!!")
            
           BaseballAutoGui.started()
            
            counter:=1   
            while( this.started = true ){
                
            
            
                for index, gameMode in this.modeArray ; Enumeration is the recommended approach in most cases.
                {
                    ; this.systemFileLogger.debug(  "Element number " . index . " is " . gameMode )                                     
                    gameMode.checkAndRun()
                }
                
				this.gameController.sleep(5)                
                counter++
				
            }            
        }else{            
			this.systemFileLogger.log("BaseballAuto Already Started!!")
        }
        this.systemFileLogger.log("BaseballAuto Done!!")
    }
    
    stop(){
		global BaseballAutoGui
                if (  this.started ){
            this.started:=false
			BaseballAutoGui.stopped()
			this.systemFileLogger.log("BaseballAuto Stopped!!")
     
        }else{
			this.systemFileLogger.log("BaseballAuto Already Stopped!!")
            
        }
    }
    
    reload(){
        this.systemFileLogger.log(" reload Call")
    }

}
