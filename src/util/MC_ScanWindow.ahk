
Class MC_ScanWindow {

    static widthToScan=200
    static heightToScan=50
    
    KEY_ESC:=27
    KEY_F:=70
    KEY_C:=67
    KEY_S:=83
    __NEW(name){
        This.Name := Name 
        This.Title:= "ScanWindow-" name
        This.Controls := Object()
        Gui, % This.Name ":+LastFound"
        This.Hwnd := WinExist()
        this.clicked:=false
        this.initWindow()
    }

    initWindow(){
        Gui, % This.Name ":Default"

        ; Gui , -Border +Resize -Caption +AlwaysOnTop
        Gui ,-Caption +Resize  +AlwaysOnTop
        Gui , color, 0xFFFFFF

        Gui, % This.Name ":Show", % "w" MC_ScanWindow.widthToScan " h" MC_ScanWindow.heightToScan , % This.Title
        WinSet, Transparent, 70, % This.Title
        
        OnMessage(0x201, this.onMouseClick.Bind(this))
        OnMessage(0x200, this.onMouseMove.Bind(this))
        ; this.closeObj:=ObjBindMethod(this, "onCloseWindow", this.Hwnd)
        ; onMessage(0x112,this.onCloseWindow.Bind(this))
        onMessage(0x100,this.onKeyDown.Bind(this))
    } 
    onKeyDown( wParam, lParam, msg, hwnd){
        ; ToolTip, % " wParam:" wParam " lParam:" lParam " msg:" msg " hwnd:" hwnd
        if ( hwnd != this.Hwnd){
            return
        }
        if ( wParam = this.KEY_ESC ){
            this.closeGui(this)
            ; Gui, % This.Name ":Destroy"
            ; ToolTip, "ESC Input"
        } else if (wParam = this.KEY_F){
            ToolTip, "F Input"
        }        
    }
    closeGui(){
        ToolTip, "I'm ???"
        Gui, % This.Name ":Default"
        Gui, Destroy        
    }
    ; onCloseWindow( wParam, lParam, msg, hwnd){
    ;     ToolTip, "I'SUPER Die"
    ;     if ( hwnd != this.Hwnd){
    ;         return
    ;     }        

    ;     ; ToolTip, % " wParam:" wParam " lParam:" lParam " msg:" msg " hwnd:" hwnd
    ;     ToolTip, "I'm Die"
    ; }

    onMouseMove( wparam, lParam, msg, hwnd ){	
        if ( hwnd != this.Hwnd){

            return
        }        

        if ( wParam = 1 ){
            PostMessage, 0XA1, 2,,, % This.Title

            return
        }else{           
            if( this.clicked ){
                this.clicked:=false
                WinGetPos, posX, posY, winWidth, winHeight, % this.Title
                WinGetPos, posX1, posY1, winWidth1, winHeight1, "(MEmu1)"
                tooltip, % "PosX:" posX " posY:" posY " winWidth:" winWidth " winHeight:" winHeight "`n" "PosX:" posX1 " posY:" posY1 " winWidth:" winWidth1 " winHeight:" winHeight1
            }	
        }
        ; if( GetKeyState (LButton ) ){

        ; }

    }
    onMouseClick( wParam, lParam, msg, hwnd){
        if ( hwnd != this.Hwnd){
            return
        }
        this.clicked:=true        
    }

}