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
        loop, 2
        {
            player := new BaseAutoPlayer(A_Index)

            playerEnabled:= this.configFile.loadValue(PLAYER_KEY, player.getKeyEnable() )
            playerRole:= this.configFile.loadValue(PLAYER_KEY, player.getKeyRole() )
            playerTitle:= this.configFile.loadValue(PLAYER_KEY, player.getKeyAppTitle() )

            player.setEnabled(playerEnabled)
            player.setAppTitle(playerTitle)
            player.setRole(playerRole)
            
            if( A_Index = 1 )
            { 
                player.setEnabled(true)
                if( playerTitle = "" )
                    player.setAppTitle("(Hard)")
                if( playerRole = "" )
                    player.setRole("League")
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
        }

    }
}

class BaseAutoPlayer{
    
    __NEW( index , title:="(Main)", enabled:=false, role:="" ){
        this.index:=index
        this.appTitle:=title
        this.enabled:=enabled
        this.appRole:=role        
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
        this.appRole:=role
    }

    getKeyEnable(){
        return % "player" this.index "Enabled"
    }
    getKeyRole(){
        return % "player" this.index "Role"
    }
    getKeyAppTitle(){
        return % "player" this.index "AppTitle"
    }
    getKeyStatus(){
        return % "player" this.index "Status"
    }




}