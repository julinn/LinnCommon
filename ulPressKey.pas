unit ulPressKey;

interface

uses
  uVKeyPress, Classes, SysUtils;

  function ul_GetKeyID(sKeyName: string): Integer;
  procedure ul_PressKey(sKeyName: string);
  function ul_GetDocmd(sText: string; var sCmd: string): Boolean;
  procedure ul_DoSingleCmd(sCmd: string);

implementation

function ul_GetKeyID(sKeyName: string): Integer;
var
  iKeyID: Integer;
begin
  if sKeyName= 'BACK' then iKeyID := vck_BACK else                                //Backspace¼ü
  if sKeyName= 'TAB' then iKeyID := vck_TAB else                                  //Tab¼ü                                               
  if sKeyName= 'CLEAR' then iKeyID := vck_CLEAR else                              //Clear¼ü£¨NumLock¹Ø±ÕÊ±µÄÊý×Ö¼üÅÌ5£©                 
  if sKeyName= 'RETURN' then iKeyID := vck_RETURN else                            //Enter¼ü
  if sKeyName= 'ENTER' then iKeyID := vck_RETURN else
  if sKeyName= '»Ø³µ' then iKeyID := vck_RETURN else                                       
  if sKeyName= 'SHIFT' then iKeyID := vck_SHIFT else                              //Shift¼ü                                             
  if sKeyName= 'CONTROL' then iKeyID := vck_CONTROL else                          //Ctrl¼ü                                              
  if sKeyName= 'MENU' then iKeyID := vck_MENU else                                //Alt¼ü                                               
  if sKeyName= 'PAUSE' then iKeyID := vck_PAUSE else                              //Pause¼ü                                             
  if sKeyName= 'CAPITAL' then iKeyID := vck_CAPITAL else                          //CapsLock¼ü                                          
  if sKeyName= 'ESCAPE' then iKeyID := vck_ESCAPE else                            //Ese¼ü
  if sKeyName= 'ESC' then iKeyID := vck_ESCAPE else 
  if sKeyName= 'SPACE' then iKeyID := vck_SPACE else                              //Spacebar¼ü
  if sKeyName= '¿Õ¸ñ' then iKeyID := vck_SPACE else                                                                 
  if sKeyName= 'PRIOR' then iKeyID := vck_PRIOR else                              //PageUp¼ü                                            
  if sKeyName= 'NEXT' then iKeyID := vck_NEXT else                                //PageDomw¼ü                                          
  if sKeyName= 'END' then iKeyID := vck_END else                                  //End¼ü                                               
  if sKeyName= 'HOME' then iKeyID := vck_HOME else                                //Home¼ü                                              
  if sKeyName= 'LEFT' then iKeyID := vck_LEFT else                                //LEFTARROW¼ü(¡û)                                     
  if sKeyName= 'UP' then iKeyID := vck_UP else                                    //UPARROW¼ü(¡ü)                                       
  if sKeyName= 'RIGHT' then iKeyID := vck_RIGHT else                              //RIGHTARROW¼ü(¡ú)                                    
  if sKeyName= 'DOWN' then iKeyID := vck_DOWN else                                //DOWNARROW¼ü(¡ý)                                     
  if sKeyName= 'Select' then iKeyID := vck_Select else                            //Select¼ü                                            
  if sKeyName= 'PRINT' then iKeyID := vck_PRINT else                              //                                                    
  if sKeyName= 'EXECUTE' then iKeyID := vck_EXECUTE else                          //EXECUTE¼ü                                           
  if sKeyName= 'SNAPSHOT' then iKeyID := vck_SNAPSHOT else                        //;//44;                                              
  if sKeyName= 'Insert' then iKeyID := vck_Insert else                            //Ins¼ü(NumLock¹Ø±ÕÊ±µÄÊý×Ö¼üÅÌ0)                     
  if sKeyName= 'Delete' then iKeyID := vck_Delete else                            //Del¼ü(NumLock¹Ø±ÕÊ±µÄÊý×Ö¼üÅÌ.)                     
  if sKeyName= 'HELP' then iKeyID := vck_HELP else                                //Help¼ü                                              
                                                                                 //                                                    
  if sKeyName= '0' then iKeyID := vck_0 else                                      //0¼ü                                                 
  if sKeyName= '1' then iKeyID := vck_1 else                                      //1¼ü                                                 
  if sKeyName= '2' then iKeyID := vck_2 else                                      //2¼ü                                                 
  if sKeyName= '3' then iKeyID := vck_3 else                                      //3¼ü                                                 
  if sKeyName= '4' then iKeyID := vck_4 else                                      //4¼ü                                                 
  if sKeyName= '5' then iKeyID := vck_5 else                                      //5¼ü                                                 
  if sKeyName= '6' then iKeyID := vck_6 else                                      //6¼ü                                                 
  if sKeyName= '7' then iKeyID := vck_7 else                                      //7¼ü                                                 
  if sKeyName= '8' then iKeyID := vck_8 else                                      //8¼ü                                                 
  if sKeyName= '9' then iKeyID := vck_9 else                                      //9¼ü                                                 
  if sKeyName= 'A' then iKeyID := vck_A else                                      //A¼ü                                                 
  if sKeyName= 'B' then iKeyID := vck_B else                                      //B¼ü                                                 
  if sKeyName= 'C' then iKeyID := vck_C else                                      //C¼ü                                                 
  if sKeyName= 'D' then iKeyID := vck_D else                                      //D¼ü                                                 
  if sKeyName= 'E' then iKeyID := vck_E else                                      //E¼ü                                                 
  if sKeyName= 'F' then iKeyID := vck_F else                                      //F¼ü                                                 
  if sKeyName= 'G' then iKeyID := vck_G else                                      //G¼ü                                                 
  if sKeyName= 'H' then iKeyID := vck_H else                                      //H¼ü                                                 
  if sKeyName= 'I' then iKeyID := vck_I else                                      //I¼ü                                                 
  if sKeyName= 'J' then iKeyID := vck_J else                                      //J¼ü                                                 
  if sKeyName= 'K' then iKeyID := vck_K else                                      //K¼ü                                                 
  if sKeyName= 'L' then iKeyID := vck_L else                                      //L¼ü                                                 
  if sKeyName= 'M' then iKeyID := vck_M else                                      //M¼ü                                                 
  if sKeyName= 'N' then iKeyID := vck_N else                                      //N¼ü                                                 
  if sKeyName= 'O' then iKeyID := vck_O else                                      //O¼ü                                                 
  if sKeyName= 'P' then iKeyID := vck_P else                                      //P¼ü                                                 
  if sKeyName= 'Q' then iKeyID := vck_Q else                                      //Q¼ü                                                 
  if sKeyName= 'R' then iKeyID := vck_R else                                      //R¼ü                                                 
  if sKeyName= 'S' then iKeyID := vck_S else                                      //S¼ü                                                 
  if sKeyName= 'T' then iKeyID := vck_T else                                      //T¼ü                                                 
  if sKeyName= 'U' then iKeyID := vck_U else                                      //U¼ü                                                 
  if sKeyName= 'V' then iKeyID := vck_V else                                      //V¼ü                                                 
  if sKeyName= 'W' then iKeyID := vck_W else                                      //W¼ü                                                 
  if sKeyName= 'X' then iKeyID := vck_X else                                      //X¼ü                                                 
  if sKeyName= 'Y' then iKeyID := vck_Y else                                      //Y¼ü                                                 
  if sKeyName= 'Z' then iKeyID := vck_Z else                                      //Z¼ü                                                 
                                                                                 //                                                    
  if sKeyName= 'LWIN' then iKeyID := vck_LWIN else                                //×ówin¼ü                                             
  if sKeyName= 'RWIN' then iKeyID := vck_RWIN else                                //ÓÒwin¼ü                                             
  if sKeyName= 'APPS' then iKeyID := vck_APPS else                                //ÓÒCtrl×ó±ß¼ü£¬µã»÷Ïàµ±ÓÚµã»÷Êó±êÓÒ¼ü£¬»áµ¯³ö¿ì½Ý²Ëµ¥
                                                                                 //                                                    
  if sKeyName= 'NUMPAD0' then iKeyID := vck_NUMPAD0 else                          //Êý×Ö¼ü0¼ü                                           
  if sKeyName= 'NUMPAD1' then iKeyID := vck_NUMPAD1 else                          //Êý×Ö¼ü1¼ü                                           
  if sKeyName= 'NUMPAD2' then iKeyID := vck_NUMPAD2 else                          //Êý×Ö¼ü2¼ü                                           
  if sKeyName= 'NUMPAD3' then iKeyID := vck_NUMPAD3 else                          //Êý×Ö¼ü3¼ü                                           
  if sKeyName= 'NUMPAD4' then iKeyID := vck_NUMPAD4 else                          //Êý×Ö¼ü4¼ü                                           
  if sKeyName= 'NUMPAD5' then iKeyID := vck_NUMPAD5 else                          //Êý×Ö¼ü5¼ü                                           
  if sKeyName= 'NUMPAD6' then iKeyID := vck_NUMPAD6 else                          //Êý×Ö¼ü6¼ü                                           
  if sKeyName= 'NUMPAD7' then iKeyID := vck_NUMPAD7 else                          //Êý×Ö¼ü7¼ü                                           
  if sKeyName= 'NUMPAD8' then iKeyID := vck_NUMPAD8 else                          //Êý×Ö¼ü8¼ü                                           
  if sKeyName= 'NUMPAD9' then iKeyID := vck_NUMPAD9 else                          //Êý×Ö¼ü9¼ü                                           
  if sKeyName= 'MULTIPLY' then iKeyID := vck_MULTIPLY else                        //Êý×Ö¼üÅÌÉÏµÄ*¼ü                                     
  if sKeyName= 'ADD' then iKeyID := vck_ADD else                                  //Êý×Ö¼üÅÌÉÏµÄ+¼ü                                     
  if sKeyName= 'SEPARATOR' then iKeyID := vck_SEPARATOR else                      //Separator¼ü                                         
  if sKeyName= 'SUBTRACT' then iKeyID := vck_SUBTRACT else                        //Êý×Ö¼üÅÌÉÏµÄ-¼ü                                     
  if sKeyName= 'DECIMAL' then iKeyID := vck_DECIMAL else                          //Êý×Ö¼üÅÌÉÏµÄ.¼ü                                     
  if sKeyName= 'DIVIDE' then iKeyID := vck_DIVIDE else                            //Êý×Ö¼üÅÌÉÏµÄ/¼ü                                     
                                                                                 //                                                    
  if sKeyName= 'F1' then iKeyID := vck_F1 else                                    //F1¼ü                                                
  if sKeyName= 'F2' then iKeyID := vck_F2 else                                    //F2¼ü                                                
  if sKeyName= 'F3' then iKeyID := vck_F3 else                                    //F3¼ü                                                
  if sKeyName= 'F4' then iKeyID := vck_F4 else                                    //F4¼ü                                                
  if sKeyName= 'F5' then iKeyID := vck_F5 else                                    //F5¼ü                                                
  if sKeyName= 'F6' then iKeyID := vck_F6 else                                    //F6¼ü                                                
  if sKeyName= 'F7' then iKeyID := vck_F7 else                                    //F7¼ü                                                
  if sKeyName= 'F8' then iKeyID := vck_F8 else                                    //F8¼ü                                                
  if sKeyName= 'F9' then iKeyID := vck_F9 else                                    //F9¼ü                                                
  if sKeyName= 'F10' then iKeyID := vck_F10 else                                  //F10¼ü                                               
  if sKeyName= 'F11' then iKeyID := vck_F11 else                                  //F11¼ü                                               
  if sKeyName= 'F12' then iKeyID := vck_F12 else                                  //F12¼ü                                               
  if sKeyName= 'NUMLOCK' then iKeyID := vck_NUMLOCK else                          //NumLock¼ü                                           
  if sKeyName= 'SCROLL' then iKeyID := vck_SCROLL else                            //ScrollLock¼ü                                        
                                                                                 //                                                    
  if sKeyName= ';' then iKeyID := vck_Fenhao else                            //;(·ÖºÅ)
  if sKeyName= '=' then iKeyID := vck_DengHao else                          //=¼ü
  if sKeyName= ',' then iKeyID := vck_DouHao else                            //,¼ü(¶ººÅ)
  if sKeyName= '-' then iKeyID := vck_Jianhao else                          //-¼ü(¼õºÅ)
  if sKeyName= '.' then iKeyID := vck_JuHao else                              //.¼ü(¾äºÅ)
  if sKeyName= '/' then iKeyID := vck_ZuoXieGang else                    ///¼ü
  if sKeyName= '`' then iKeyID := vck_EscDian else                          //`¼ü(EscÏÂÃæ)
  if sKeyName= '[' then iKeyID := vck_ZuoZhongKuoHao else            //[¼ü
  if sKeyName= '\' then iKeyID := vck_YouXieGang else                    //\¼ü
  if sKeyName= ']' then iKeyID := vck_YouZhongKuoHao else            //]¼ü
  if sKeyName= 'YinHao' then iKeyID := vck_YinHao else                            //'¼ü(ÒýºÅ)
     iKeyID := 0;
  Result := iKeyID;
end;

procedure ul_PressKey(sKeyName: string);
var
  iKeyID: Integer;
begin
  iKeyID := ul_GetKeyID(sKeyName);
  if iKeyID > 0 then                           
    uVKeyPress.vpk_PressKey(iKeyID);
end;

function ul_GetDocmd(sText: string; var sCmd: string): Boolean;
var
  tStr: TStrings;
begin
  Result := False;
  sCmd := '';
  if sText = '' then
    Exit;
  try
    sText := StringReplace(sText, #$D#$A, '', [rfReplaceAll]);
    tStr := TStringList.Create;
    tStr.Delimiter := ';';
    tStr.DelimitedText := sText;
    if tStr.Count > 0 then
    begin
      sCmd := sText;
      Result := True;
    end;
  finally
    tStr.Free;
  end;
end;

procedure ul_DoSingleCmd(sCmd: string);
var
  iX, iY, iDelay: Integer;
  sSub: string;
  tStr: TStrings;
begin
  if Pos('move', sCmd) > 0 then
  begin
    sSub := StringReplace(sCmd, 'move', '', []);
    sSub := StringReplace(sSub, '(', '', []);
    sSub := StringReplace(sSub, ')', '', []);
    sSub := StringReplace(sSub, ' ', '', []);
    try
      tStr := TStringList.Create;
      tStr.DelimitedText := sSub;
      tStr.Delimiter := ',';
      iX := StrToIntDef(tStr[0], 0);
      iY := StrToIntDef(tStr[1], 0);
      uVKeyPress.vpk_MoveMouseToPosit(iX, iY);      
    finally
      tStr.Free;
    end;
  end
  else if Pos('click', sCmd) > 0 then
  begin
    uVKeyPress.vpk_MouseLeft;
  end
  else if Pos('rclick', sCmd) > 0 then
  begin
    uVKeyPress.vpk_MouseRight;
  end
  else if Pos('double', sCmd) > 0 then
  begin
    uVKeyPress.vpk_MouseDoubleClik;
  end
  else if Pos('press', sCmd) > 0then
  begin
    sSub := StringReplace(sCmd, 'press', '', []);
    sSub := StringReplace(sSub, '(', '', []);
    sSub := StringReplace(sSub, ')', '', []);
    sSub := StringReplace(sSub, ' ', '', []);
    ul_PressKey(sSub);
  end
  else if Pos('delay', sCmd) > 0 then
  begin
    sSub := StringReplace(sCmd, 'delay', '', []);
    sSub := StringReplace(sSub, '(', '', []);
    sSub := StringReplace(sSub, ')', '', []);
    sSub := StringReplace(sSub, ' ', '', []);
    iDelay := StrToIntDef(sSub, 1000);
    uVKeyPress.vpk_Delay(iDelay);
  end
  else if Pos('//', sCmd) > 0 then
  begin
    //
  end
  else if Pos('alt', sCmd) > 0 then
  begin
    sSub := StringReplace(sCmd, 'alt', '', []);
    sSub := StringReplace(sSub, '(', '', []);
    sSub := StringReplace(sSub, ')', '', []);
    sSub := StringReplace(sSub, ' ', '', [rfReplaceAll]);
    uVKeyPress.vpk_Alt_PressKey(ul_GetKeyID(sSub));
  end
  else if Pos('ctrl', sCmd) > 0 then
  begin
    sSub := StringReplace(sCmd, 'ctrl', '', []);
    sSub := StringReplace(sSub, '(', '', []);
    sSub := StringReplace(sSub, ')', '', []);
    sSub := StringReplace(sSub, ' ', '', [rfReplaceAll]);
    uVKeyPress.vpk_Ctrl_PressKey(ul_GetKeyID(sSub));
  end;
    Exit;
end;

end.
