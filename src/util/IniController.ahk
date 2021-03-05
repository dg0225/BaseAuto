Class IniController{

   __New( strFileName ){
      this.iniFile:=strFileName
   }

   loadValue( strTitle, strKey ){ 
      IniRead, value, % this.iniFile ,%strTitle%, %strKey%
      IfEqual value, ERROR
      {
         value:=""
      } 
      return value
   } 

   saveValue( strTitle, strKey , strValue ){
      IniWrite, %strValue%, % this.iniFile , %strTitle%, %strKey% 
   }
}
