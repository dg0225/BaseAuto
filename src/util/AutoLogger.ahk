Class AutoLogger{

    baseDirectory:="Logs"
    
    __NEW( module , modulePath = "" ){
        this.module:=module
        this.directory:=modulePath
        
        FileCreateDir, % This.baseDirectory
        if( modulePath != "" ){
            tempDir := % This.baseDirectory "\" this.directory
            FileCreateDir, % tempDir
            this.directory:=tempDir
        }else{
            this.directory:=this.baseDirectory
        }
        
        this.debug("AutoLogger init....")
    }
   
   log( content , boolIsDebug=false)
   {        
        FormatTime, sFileName, %A_NOW%, MM월dd일
        FormatTime, TimeString, %A_NOW%, MM-dd tt hh시mm분ss초
        
		formattedContent:=% "`n[" TimeString "][" this.module "]: " content
        
		FileAppend, %formattedContent%, % this.directory "\log(" sFileName ").txt"	        
		
		global BaseballAutoGui
		formattedContent:="`n[" this.module "]: " content
		
		if( BaseballAutoGui != "" ){
			BaseballAutoGui.guiLog( this.module, "How", formattedContent)
		}
    }
	
	debug( content )
   {        
        FormatTime, sFileName, %A_NOW%, MM월dd일
        FormatTime, TimeString, %A_NOW%, MM-dd tt hh시mm분ss초
        
		formattedContent:=% "`n[" TimeString "][" this.module "]: " content
        FileAppend, %formattedContent%, % this.directory "\log(" sFileName ").txt"	        
    }
    
   
   
}