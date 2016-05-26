unit uVKeyPress;

interface

uses
  Windows,Messages, Forms;

//
const    
vck_BACK = 8; //Backspace¼ü
vck_TAB = 9; //Tab¼ü
vck_CLEAR = 12; //Clear¼ü£¨NumLock¹Ø±ÕÊ±µÄÊý×Ö¼üÅÌ5£©
vck_RETURN = 13; //Enter¼ü
vck_SHIFT = 16; //Shift¼ü
vck_CONTROL = 17; //Ctrl¼ü
vck_MENU = 18; //Alt¼ü
vck_PAUSE = 19; //Pause¼ü
vck_CAPITAL = 20; //CapsLock¼ü
vck_ESCAPE = 27; //Ese¼ü
vck_SPACE = 32; //Spacebar¼ü
vck_PRIOR = 33; //PageUp¼ü
vck_NEXT = 34; //PageDomw¼ü
vck_END = 35; //End¼ü
vck_HOME = 36; //Home¼ü
vck_LEFT = 37; //LEFTARROW¼ü(¡û)
vck_UP = 38; //UPARROW¼ü(¡ü)
vck_RIGHT = 39; //RIGHTARROW¼ü(¡ú)
vck_DOWN = 40; //DOWNARROW¼ü(¡ý)
vck_Select = 41; //Select¼ü
vck_PRINT = 42; //
vck_EXECUTE = 43; //EXECUTE¼ü
vck_SNAPSHOT = 44; //; //44; //PrintScreen¼ü£¨×¥ÆÁ£©
vck_Insert = 45; //Ins¼ü(NumLock¹Ø±ÕÊ±µÄÊý×Ö¼üÅÌ0)
vck_Delete = 46; //Del¼ü(NumLock¹Ø±ÕÊ±µÄÊý×Ö¼üÅÌ.)
vck_HELP = 47; //Help¼ü
//
vck_0 = 48; //0¼ü
vck_1 = 49; //1¼ü
vck_2 = 50; //2¼ü
vck_3 = 51; //3¼ü
vck_4 = 52; //4¼ü
vck_5 = 53; //5¼ü
vck_6 = 54; //6¼ü
vck_7 = 55; //7¼ü
vck_8 = 56; //8¼ü
vck_9 = 57; //9¼ü
vck_A = 65; //A¼ü
vck_B = 66; //B¼ü
vck_C = 67; //C¼ü
vck_D = 68; //D¼ü
vck_E = 69; //E¼ü
vck_F = 70; //F¼ü
vck_G = 71; //G¼ü
vck_H = 72; //H¼ü
vck_I = 73; //I¼ü
vck_J = 74; //J¼ü
vck_K = 75; //K¼ü
vck_L = 76; //L¼ü
vck_M = 77; //M¼ü
vck_N = 78; //N¼ü
vck_O = 79; //O¼ü
vck_P = 80; //P¼ü
vck_Q = 81; //Q¼ü
vck_R = 82; //R¼ü
vck_S = 83; //S¼ü
vck_T = 84; //T¼ü
vck_U = 85; //U¼ü
vck_V = 86; //V¼ü
vck_W = 87; //W¼ü
vck_X = 88; //X¼ü
vck_Y = 89; //Y¼ü
vck_Z = 90; //Z¼ü
//
vck_LWIN = 91; //×ówin¼ü
vck_RWIN = 92; //ÓÒwin¼ü
vck_APPS = 93; //ÓÒCtrl×ó±ß¼ü£¬µã»÷Ïàµ±ÓÚµã»÷Êó±êÓÒ¼ü£¬»áµ¯³ö¿ì½Ý²Ëµ¥
//
vck_NUMPAD0 = 96; //Êý×Ö¼ü0¼ü
vck_NUMPAD1 = 97; //Êý×Ö¼ü1¼ü
vck_NUMPAD2 = 98; //Êý×Ö¼ü2¼ü
vck_NUMPAD3 = 99; //Êý×Ö¼ü3¼ü
vck_NUMPAD4 = 100; //Êý×Ö¼ü4¼ü
vck_NUMPAD5 = 101; //Êý×Ö¼ü5¼ü
vck_NUMPAD6 = 102; //Êý×Ö¼ü6¼ü
vck_NUMPAD7 = 103; //Êý×Ö¼ü7¼ü
vck_NUMPAD8 = 104; //Êý×Ö¼ü8¼ü
vck_NUMPAD9 = 105; //Êý×Ö¼ü9¼ü
vck_MULTIPLY = 106; //Êý×Ö¼üÅÌÉÏµÄ*¼ü
vck_ADD = 107; //Êý×Ö¼üÅÌÉÏµÄ+¼ü
vck_SEPARATOR = 108; //Separator¼ü
vck_SUBTRACT = 109; //Êý×Ö¼üÅÌÉÏµÄ-¼ü
vck_DECIMAL = 110; //Êý×Ö¼üÅÌÉÏµÄ.¼ü
vck_DIVIDE = 111; //Êý×Ö¼üÅÌÉÏµÄ/¼ü
//
vck_F1 = 112; //F1¼ü
vck_F2 = 113; //F2¼ü
vck_F3 = 114; //F3¼ü
vck_F4 = 115; //F4¼ü
vck_F5 = 116; //F5¼ü
vck_F6 = 117; //F6¼ü
vck_F7 = 118; //F7¼ü
vck_F8 = 119; //F8¼ü
vck_F9 = 120; //F9¼ü
vck_F10 = 121; //F10¼ü
vck_F11 = 122; //F11¼ü
vck_F12 = 123; //F12¼ü
vck_NUMLOCK = 144; //NumLock¼ü
vck_SCROLL = 145; //ScrollLock¼ü
//
vck_Fenhao = 186; //;(·ÖºÅ)
vck_DengHao = 187; //=¼ü
vck_DouHao = 188; //,¼ü(¶ººÅ)
vck_Jianhao = 189; //-¼ü(¼õºÅ)
vck_JuHao = 190; //.¼ü(¾äºÅ)
vck_ZuoXieGang = 191; ///¼ü
vck_EscDian = 192; //`¼ü(EscÏÂÃæ)
vck_ZuoZhongKuoHao = 219; //[¼ü
vck_YouXieGang = 220; //\¼ü
vck_YouZhongKuoHao = 221; //]¼ü
vck_YinHao = 222; //'¼ü(ÒýºÅ)
//

procedure vpk_MouseLeft;
procedure vpk_MouseDoubleClik;
procedure vpk_MouseRight;
//procedure vck_A;
procedure vpk_PressKey(vck_Name: Integer);
procedure vpk_Alt_PressKey(vck_Name: Integer);
procedure vpk_Ctrl_PressKey(vck_Name: Integer);
procedure vpk_Shift_PressKey(vck_Name: Integer);
//
function vpk_GetCurrMousePosit(var iX: Integer; var iY: Integer): Boolean;
function vpk_MoveMouseToPosit(iX, iY: Integer): Boolean;
function vpk_MoveMouseToPosit_Click(iX, iY: Integer; bDoubleClick: Boolean = False): Boolean;
//
procedure vpk_Delay(dwMilliseconds:DWORD);//Longint
procedure vpk_Delay2(iMsSec: Integer);

implementation

procedure vpk_MouseLeft;
begin
  mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
  mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
end;

procedure vpk_MouseDoubleClik;
begin
  vpk_MouseLeft;
  vpk_MouseLeft;
end;

procedure vpk_MouseRight;
begin
  mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,0);
  mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0);
end;

//procedure vck_A;
//begin
//  keybd_event(65,MapVirtualKey(65,0),0,0);//°´ÏÂ¼ü
//  keybd_event(65,MapVirtualKey(65,0),KEYEVENTF_KEYUP,0);//ÊÍ·Å¼ü
//end;

procedure vpk_PressKey(vck_Name: Integer);
begin
  keybd_event(vck_Name,MapVirtualKey(vck_Name,0),0,0);//°´ÏÂ¼ü
  keybd_event(vck_Name,MapVirtualKey(vck_Name,0),KEYEVENTF_KEYUP,0);//ÊÍ·Å¼ü
end;

procedure vpk_Alt_PressKey(vck_Name: Integer);
begin
  keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), 0, 0);
  keybd_event(vck_Name, MapVirtualKey(vck_Name, 0), 0, 0);
  keybd_event(vck_Name, MapVirtualKey(vck_Name, 0), KEYEVENTF_KEYUP, 0);
  keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), KEYEVENTF_KEYUP, 0);
end;

procedure vpk_Ctrl_PressKey(vck_Name: Integer);
begin
  keybd_event(VK_Control, MapVirtualKey(VK_Control, 0), 0, 0);
  keybd_event(vck_Name, MapVirtualKey(vck_Name, 0), 0, 0);
  keybd_event(vck_Name, MapVirtualKey(vck_Name, 0), KEYEVENTF_KEYUP, 0);
  keybd_event(VK_Control, MapVirtualKey(VK_Control, 0), KEYEVENTF_KEYUP, 0);
end;

procedure vpk_Shift_PressKey(vck_Name: Integer);
begin
  keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), 0, 0);
  keybd_event(vck_Name, MapVirtualKey(vck_Name, 0), 0, 0);
  keybd_event(vck_Name, MapVirtualKey(vck_Name, 0), KEYEVENTF_KEYUP, 0);
  keybd_event(VK_SHIFT, MapVirtualKey(VK_SHIFT, 0), KEYEVENTF_KEYUP, 0);
end;

function vpk_GetCurrMousePosit(var iX: Integer; var iY: Integer): Boolean;
var
  p: TPoint;
begin
  Result := False;
  try
    GetCursorPos(p);
    iX := p.X;
    iY := p.Y;
    Result := True;
  except
    iX := 0;
    iY := 0;
    Result := False;
  end;
end;

function vpk_MoveMouseToPosit(iX, iY: Integer): Boolean;
begin
  Result := SetCursorPos(iX, iY);
end;

function vpk_MoveMouseToPosit_Click(iX, iY: Integer; bDoubleClick: Boolean = False): Boolean;
begin
  Result := False;
  try
    if SetCursorPos(iX, iY) then
    begin
      if bDoubleClick then
        vpk_MouseDoubleClik
      else
        vpk_MouseLeft;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure vpk_Delay2(iMsSec: Integer);
var
  Tick: DWord; 
  Event: THandle; 
begin
  Event := CreateEvent(nil, False, False, nil);
  try
    Tick := GetTickCount + DWord(iMsSec);
    while (iMsSec > 0) and (MsgWaitForMultipleObjects(1, Event, False, iMsSec, QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages; 
      iMsSec := Tick - GetTickcount; 
    end; 
  finally
    CloseHandle(Event);
  end;
end;

procedure vpk_Delay(dwMilliseconds:DWORD);//Longint
var
  iStart,iStop:DWORD;
begin
  iStart :=   GetTickCount;
  repeat
    iStop  :=   GetTickCount;
    Application.ProcessMessages;
  until
   (iStop  -  iStart) >= dwMilliseconds;
end; 

end.
