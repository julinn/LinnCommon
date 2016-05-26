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
  if sKeyName= 'BACK' then iKeyID := vck_BACK else                                //Backspace��
  if sKeyName= 'TAB' then iKeyID := vck_TAB else                                  //Tab��                                               
  if sKeyName= 'CLEAR' then iKeyID := vck_CLEAR else                              //Clear����NumLock�ر�ʱ�����ּ���5��                 
  if sKeyName= 'RETURN' then iKeyID := vck_RETURN else                            //Enter��
  if sKeyName= 'ENTER' then iKeyID := vck_RETURN else
  if sKeyName= '�س�' then iKeyID := vck_RETURN else                                       
  if sKeyName= 'SHIFT' then iKeyID := vck_SHIFT else                              //Shift��                                             
  if sKeyName= 'CONTROL' then iKeyID := vck_CONTROL else                          //Ctrl��                                              
  if sKeyName= 'MENU' then iKeyID := vck_MENU else                                //Alt��                                               
  if sKeyName= 'PAUSE' then iKeyID := vck_PAUSE else                              //Pause��                                             
  if sKeyName= 'CAPITAL' then iKeyID := vck_CAPITAL else                          //CapsLock��                                          
  if sKeyName= 'ESCAPE' then iKeyID := vck_ESCAPE else                            //Ese��
  if sKeyName= 'ESC' then iKeyID := vck_ESCAPE else 
  if sKeyName= 'SPACE' then iKeyID := vck_SPACE else                              //Spacebar��
  if sKeyName= '�ո�' then iKeyID := vck_SPACE else                                                                 
  if sKeyName= 'PRIOR' then iKeyID := vck_PRIOR else                              //PageUp��                                            
  if sKeyName= 'NEXT' then iKeyID := vck_NEXT else                                //PageDomw��                                          
  if sKeyName= 'END' then iKeyID := vck_END else                                  //End��                                               
  if sKeyName= 'HOME' then iKeyID := vck_HOME else                                //Home��                                              
  if sKeyName= 'LEFT' then iKeyID := vck_LEFT else                                //LEFTARROW��(��)                                     
  if sKeyName= 'UP' then iKeyID := vck_UP else                                    //UPARROW��(��)                                       
  if sKeyName= 'RIGHT' then iKeyID := vck_RIGHT else                              //RIGHTARROW��(��)                                    
  if sKeyName= 'DOWN' then iKeyID := vck_DOWN else                                //DOWNARROW��(��)                                     
  if sKeyName= 'Select' then iKeyID := vck_Select else                            //Select��                                            
  if sKeyName= 'PRINT' then iKeyID := vck_PRINT else                              //                                                    
  if sKeyName= 'EXECUTE' then iKeyID := vck_EXECUTE else                          //EXECUTE��                                           
  if sKeyName= 'SNAPSHOT' then iKeyID := vck_SNAPSHOT else                        //;//44;                                              
  if sKeyName= 'Insert' then iKeyID := vck_Insert else                            //Ins��(NumLock�ر�ʱ�����ּ���0)                     
  if sKeyName= 'Delete' then iKeyID := vck_Delete else                            //Del��(NumLock�ر�ʱ�����ּ���.)                     
  if sKeyName= 'HELP' then iKeyID := vck_HELP else                                //Help��                                              
                                                                                 //                                                    
  if sKeyName= '0' then iKeyID := vck_0 else                                      //0��                                                 
  if sKeyName= '1' then iKeyID := vck_1 else                                      //1��                                                 
  if sKeyName= '2' then iKeyID := vck_2 else                                      //2��                                                 
  if sKeyName= '3' then iKeyID := vck_3 else                                      //3��                                                 
  if sKeyName= '4' then iKeyID := vck_4 else                                      //4��                                                 
  if sKeyName= '5' then iKeyID := vck_5 else                                      //5��                                                 
  if sKeyName= '6' then iKeyID := vck_6 else                                      //6��                                                 
  if sKeyName= '7' then iKeyID := vck_7 else                                      //7��                                                 
  if sKeyName= '8' then iKeyID := vck_8 else                                      //8��                                                 
  if sKeyName= '9' then iKeyID := vck_9 else                                      //9��                                                 
  if sKeyName= 'A' then iKeyID := vck_A else                                      //A��                                                 
  if sKeyName= 'B' then iKeyID := vck_B else                                      //B��                                                 
  if sKeyName= 'C' then iKeyID := vck_C else                                      //C��                                                 
  if sKeyName= 'D' then iKeyID := vck_D else                                      //D��                                                 
  if sKeyName= 'E' then iKeyID := vck_E else                                      //E��                                                 
  if sKeyName= 'F' then iKeyID := vck_F else                                      //F��                                                 
  if sKeyName= 'G' then iKeyID := vck_G else                                      //G��                                                 
  if sKeyName= 'H' then iKeyID := vck_H else                                      //H��                                                 
  if sKeyName= 'I' then iKeyID := vck_I else                                      //I��                                                 
  if sKeyName= 'J' then iKeyID := vck_J else                                      //J��                                                 
  if sKeyName= 'K' then iKeyID := vck_K else                                      //K��                                                 
  if sKeyName= 'L' then iKeyID := vck_L else                                      //L��                                                 
  if sKeyName= 'M' then iKeyID := vck_M else                                      //M��                                                 
  if sKeyName= 'N' then iKeyID := vck_N else                                      //N��                                                 
  if sKeyName= 'O' then iKeyID := vck_O else                                      //O��                                                 
  if sKeyName= 'P' then iKeyID := vck_P else                                      //P��                                                 
  if sKeyName= 'Q' then iKeyID := vck_Q else                                      //Q��                                                 
  if sKeyName= 'R' then iKeyID := vck_R else                                      //R��                                                 
  if sKeyName= 'S' then iKeyID := vck_S else                                      //S��                                                 
  if sKeyName= 'T' then iKeyID := vck_T else                                      //T��                                                 
  if sKeyName= 'U' then iKeyID := vck_U else                                      //U��                                                 
  if sKeyName= 'V' then iKeyID := vck_V else                                      //V��                                                 
  if sKeyName= 'W' then iKeyID := vck_W else                                      //W��                                                 
  if sKeyName= 'X' then iKeyID := vck_X else                                      //X��                                                 
  if sKeyName= 'Y' then iKeyID := vck_Y else                                      //Y��                                                 
  if sKeyName= 'Z' then iKeyID := vck_Z else                                      //Z��                                                 
                                                                                 //                                                    
  if sKeyName= 'LWIN' then iKeyID := vck_LWIN else                                //��win��                                             
  if sKeyName= 'RWIN' then iKeyID := vck_RWIN else                                //��win��                                             
  if sKeyName= 'APPS' then iKeyID := vck_APPS else                                //��Ctrl��߼�������൱�ڵ������Ҽ����ᵯ����ݲ˵�
                                                                                 //                                                    
  if sKeyName= 'NUMPAD0' then iKeyID := vck_NUMPAD0 else                          //���ּ�0��                                           
  if sKeyName= 'NUMPAD1' then iKeyID := vck_NUMPAD1 else                          //���ּ�1��                                           
  if sKeyName= 'NUMPAD2' then iKeyID := vck_NUMPAD2 else                          //���ּ�2��                                           
  if sKeyName= 'NUMPAD3' then iKeyID := vck_NUMPAD3 else                          //���ּ�3��                                           
  if sKeyName= 'NUMPAD4' then iKeyID := vck_NUMPAD4 else                          //���ּ�4��                                           
  if sKeyName= 'NUMPAD5' then iKeyID := vck_NUMPAD5 else                          //���ּ�5��                                           
  if sKeyName= 'NUMPAD6' then iKeyID := vck_NUMPAD6 else                          //���ּ�6��                                           
  if sKeyName= 'NUMPAD7' then iKeyID := vck_NUMPAD7 else                          //���ּ�7��                                           
  if sKeyName= 'NUMPAD8' then iKeyID := vck_NUMPAD8 else                          //���ּ�8��                                           
  if sKeyName= 'NUMPAD9' then iKeyID := vck_NUMPAD9 else                          //���ּ�9��                                           
  if sKeyName= 'MULTIPLY' then iKeyID := vck_MULTIPLY else                        //���ּ����ϵ�*��                                     
  if sKeyName= 'ADD' then iKeyID := vck_ADD else                                  //���ּ����ϵ�+��                                     
  if sKeyName= 'SEPARATOR' then iKeyID := vck_SEPARATOR else                      //Separator��                                         
  if sKeyName= 'SUBTRACT' then iKeyID := vck_SUBTRACT else                        //���ּ����ϵ�-��                                     
  if sKeyName= 'DECIMAL' then iKeyID := vck_DECIMAL else                          //���ּ����ϵ�.��                                     
  if sKeyName= 'DIVIDE' then iKeyID := vck_DIVIDE else                            //���ּ����ϵ�/��                                     
                                                                                 //                                                    
  if sKeyName= 'F1' then iKeyID := vck_F1 else                                    //F1��                                                
  if sKeyName= 'F2' then iKeyID := vck_F2 else                                    //F2��                                                
  if sKeyName= 'F3' then iKeyID := vck_F3 else                                    //F3��                                                
  if sKeyName= 'F4' then iKeyID := vck_F4 else                                    //F4��                                                
  if sKeyName= 'F5' then iKeyID := vck_F5 else                                    //F5��                                                
  if sKeyName= 'F6' then iKeyID := vck_F6 else                                    //F6��                                                
  if sKeyName= 'F7' then iKeyID := vck_F7 else                                    //F7��                                                
  if sKeyName= 'F8' then iKeyID := vck_F8 else                                    //F8��                                                
  if sKeyName= 'F9' then iKeyID := vck_F9 else                                    //F9��                                                
  if sKeyName= 'F10' then iKeyID := vck_F10 else                                  //F10��                                               
  if sKeyName= 'F11' then iKeyID := vck_F11 else                                  //F11��                                               
  if sKeyName= 'F12' then iKeyID := vck_F12 else                                  //F12��                                               
  if sKeyName= 'NUMLOCK' then iKeyID := vck_NUMLOCK else                          //NumLock��                                           
  if sKeyName= 'SCROLL' then iKeyID := vck_SCROLL else                            //ScrollLock��                                        
                                                                                 //                                                    
  if sKeyName= ';' then iKeyID := vck_Fenhao else                            //;(�ֺ�)
  if sKeyName= '=' then iKeyID := vck_DengHao else                          //=��
  if sKeyName= ',' then iKeyID := vck_DouHao else                            //,��(����)
  if sKeyName= '-' then iKeyID := vck_Jianhao else                          //-��(����)
  if sKeyName= '.' then iKeyID := vck_JuHao else                              //.��(���)
  if sKeyName= '/' then iKeyID := vck_ZuoXieGang else                    ///��
  if sKeyName= '`' then iKeyID := vck_EscDian else                          //`��(Esc����)
  if sKeyName= '[' then iKeyID := vck_ZuoZhongKuoHao else            //[��
  if sKeyName= '\' then iKeyID := vck_YouXieGang else                    //\��
  if sKeyName= ']' then iKeyID := vck_YouZhongKuoHao else            //]��
  if sKeyName= 'YinHao' then iKeyID := vck_YinHao else                            //'��(����)
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
