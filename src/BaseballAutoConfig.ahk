#include %A_ScriptDir%\src\util\IniController.ahk
class BaseballAutoConfig{
	
    __NEW( configFileName ){
        this.configFile := new IniController( configFileName )

		This.players := []
        This.enabledPlayers:= []
        this.initConfig()
    }
    getDefaultPlayer(){
        return this.players[1]
    }
    getLastGuiPosition( ByRef posX, ByRef posY)
    {
        posX:= this.configFile.loadValue("GUI_POSITION", "MAIN_X")
        posY:= this.configFile.loadValue("GUI_POSITION", "MAIN_Y")
        ; ToolTip, "posX " %posX% "  posY" %posY% 
        if ( posX = "" ) 
            posX:=1150
        if ( posY = "" ) 
            posY:=0
    }
    setLastGuiPosition( posX, posY)
    {
        this.configFile.saveValue("GUI_POSITION", "MAIN_X", posx)
        this.configFile.saveValue("GUI_POSITION", "MAIN_Y", posy)
    }

    initConfig(){

        PLAYER_KEY:="PLAYERS_CONFIG"
        loop, 4
        {
            player := new BaseAutoPlayer(A_Index)

            playerEnabled:= this.configFile.loadValue(PLAYER_KEY, player.getKeyEnable() )
            playerRole:= this.configFile.loadValue(PLAYER_KEY, player.getKeyRole() )
            playerTitle:= this.configFile.loadValue(PLAYER_KEY, player.getKeyAppTitle() )
			playerBattleType:= this.configFile.loadValue(PLAYER_KEY, player.getKeyBattleType() )

            player.setEnabled(playerEnabled)
            player.setAppTitle(playerTitle)
            player.setRole(playerRole)           
			player.setBattleType(playerBattleType)
            if( A_Index = 1 )
            { 
                player.setEnabled(true)
                if( playerTitle = "" )
                    player.setAppTitle("(Hard)")
                if( playerRole = "" )
                    player.setRole("League")
					
				if (playerBattleType="")	
					player.setBattleType("A")
				
            }
            if( player.getEnabled() ){
                this.enabledPlayers.push(player)

            }
            ; msgbox % "player " A_Index " Enabled : " player["ENABLE"] " Title: " player["TITLE"] " Role : "player["ROLE"]
            this.players.Push( player)
        }
    }

    saveConfig(){

        PLAYER_KEY:="PLAYERS_CONFIG"
        for index, element in this.players
        {
            this.configFile.saveValue(PLAYER_KEY,element.getKeyEnable(), element.getEnabled()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyAppTitle(), element.getAppTitle()) 
            this.configFile.saveValue(PLAYER_KEY,element.getKeyRole(), element.getRole()) 
			this.configFile.saveValue(PLAYER_KEY,element.getKeyBattleType(), element.getBattleType()) 
        }

    }
}

class BaseAutoPlayer{
    
    __NEW( index , title:="(Main)", enabled:=false, role:="" ){
        this.index:=index
        this.appTitle:=title
        this.enabled:=enabled
        this.appRole:=role        
		this.status:="UNKNOWN"
		this.battleType:="A"
    }

    getEnabled(){
        return this.enabled
    }

    getRole(){
        return this.appRole
    }
    getAppTitle(){
        return this.appTitle
    }
	needToStay(){
		if( this.status = "UNKNOWN" or this.status ="AUTO" )
			return false
		else
			return true
	}
	setStay(){
		global baseballAutoGui
		
		this.status:="ING"
		baseballAutoGui.updateStatus( this.getKeyStatus(), this.status)
	}
	setFree(){
		global baseballAutoGui
		
		this.status:="AUTO"	
		baseballAutoGui.updateStatus( this.getKeyStatus(), this.status)
	}

    setEnabled( bool ){
        if( bool = true or bool="true" or bool=1)
            this.enabled:=true
        else
            this.enabled:=false
    }

    setAppTitle( title ){
        this.AppTitle:=title            
    }
    setRole( role ){
		; if( role != "")
        this.appRole:=role
    }

	getBattleType(){
		return this.battleType
	
	}
	setBattleType( _battleType){
		; if( _battleType !="")
			this.battleType:=_battleType
	}
	
	
    getKeyEnable(){
        return % "player" this.index "Enabled"
    }
    getKeyRole(){
        return % "player" this.index "Role"
    }
	getKeyBattleType(){
        return % "player" this.index "BattleType"
    }
    getKeyAppTitle(){
        return % "player" this.index "AppTitle"
    }
    getKeyStatus(){
        return % "player" this.index "Status"
    }

}