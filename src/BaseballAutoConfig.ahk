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
    setWantToResult(){
        for index,player in this.enabledPlayers
        {
            player.setWantToWaitResult() 
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

    __NEW( index , title:="(Main)", enabled:=false, role:="League" ){
        this.index:=index
        this.appTitle:=title
        this.enabled:=enabled
        this.appRole:=role 
        this.watingResult:=false
        this.status:="Unknwon"
        this.battleType:="D"
        this.result:=0
    } 
    getResult(){
        return this.result
    }
    addResult(){
        this.result+=1
        this.setGuiResult()
    } 
    setGuiResult( ){
        global baseballAutoGui		 
        baseballAutoGui.updateStatus( this.getKeyResult(), this.result)
    }
    setNeedSkip(){
        this.setResultColor(true)
    }
    setResultColor( changeColor:=false){
        global baseballAutoGui		
        baseballAutoGui.updateResultColor( this.getKeyResult(), this.result, changeColor)	
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
        if( this.status = "Unknwon" or this.status ="자동중" or this.status ="리그종료" or this.status ="끝")
            return false
        else
            return true
    }
    needToStop(){
        if( this.status ="끝")
            return true
        else
            return false
    }
    setWantToWaitResult(){
        this.watingResult:=true
    }
    getWaitingResult(){
        return this.watingResult
    }
    setCheck(){
        this.setStatusColor( true)
    }
    setCheckDone(){
        this.setStatusColor(false)
    }
    setStay(){
        this.setStatus("조작중")
    }
    setBye(){
        this.setStatus("끝")
    }
    setRealFree(){
        this.setStatus("리그종료")		
    }
    setFree(){
        this.setStatus("자동중")		
    }
    setUnkown(){
        this.setStatus("Unknwon")		
    }

    getStatus(){
        return this.status
    }
    setStatus( status ){
        global baseballAutoGui		
        this.status:=status
        baseballAutoGui.updateStatus( this.getKeyStatus(), this.status, changeColor)
    }
    setStatusColor( changeColor:=false){
        global baseballAutoGui		
        baseballAutoGui.updateStatusColor( this.getKeyStatus(), this.status, changeColor)	
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
    getKeyResult(){
        return % "player" this.index "Result"
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