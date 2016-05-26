unit uVKeyPress;

interface

uses
  Windows,Messages, Forms;

//
const    
vck_BACK = 8; //Backspace��
vck_TAB = 9; //Tab��
vck_CLEAR = 12; //Clear����NumLock�ر�ʱ�����ּ���5��
vck_RETURN = 13; //Enter��
vck_SHIFT = 16; //Shift��
vck_CONTROL = 17; //Ctrl��
vck_MENU = 18; //Alt��
vck_PAUSE = 19; //Pause��
vck_CAPITAL = 20; //CapsLock��
vck_ESCAPE = 27; //Ese��
vck_SPACE = 32; //Spacebar��
vck_PRIOR = 33; //PageUp��
vck_NEXT = 34; //PageDomw��
vck_END = 35; //End��
vck_HOME = 36; //Home��
vck_LEFT = 37; //LEFTARROW��(��)
vck_UP = 38; //UPARROW��(��)
vck_RIGHT = 39; //RIGHTARROW��(��)
vck_DOWN = 40; //DOWNARROW��(��)
vck_Select = 41; //Select��
vck_PRINT = 42; //
vck_EXECUTE = 43; //EXECUTE��
vck_SNAPSHOT = 44; //; //44; //PrintScreen����ץ����
vck_Insert = 45; //Ins��(NumLock�ر�ʱ�����ּ���0)
vck_Delete = 46; //Del��(NumLock�ر�ʱ�����ּ���.)
vck_HELP = 47; //Help��
//
vck_0 = 48; //0��
vck_1 = 49; //1��
vck_2 = 50; //2��
vck_3 = 51; //3��
vck_4 = 52; //4��
vck_5 = 53; //5��
vck_6 = 54; //6��
vck_7 = 55; //7��
vck_8 = 56; //8��
vck_9 = 57; //9��
vck_A = 65; //A��
vck_B = 66; //B��
vck_C = 67; //C��
vck_D = 68; //D��
vck_E = 69; //E��
vck_F = 70; //F��
vck_G = 71; //G��
vck_H = 72; //H��
vck_I = 73; //I��
vck_J = 74; //J��
vck_K = 75; //K��
vck_L = 76; //L��
vck_M = 77; //M��
vck_N = 78; //N��
vck_O = 79; //O��
vck_P = 80; //P��
vck_Q = 81; //Q��
vck_R = 82; //R��
vck_S = 83; //S��
vck_T = 84; //T��
vck_U = 85; //U��
vck_V = 86; //V��
vck_W = 87; //W��
vck_X = 88; //X��
vck_Y = 89; //Y��
vck_Z = 90; //Z��
//
vck_LWIN = 91; //��win��
vck_RWIN = 92; //��win��
vck_APPS = 93; //��Ctrl��߼�������൱�ڵ������Ҽ����ᵯ����ݲ˵�
//
vck_NUMPAD0 = 96; //���ּ�0��
vck_NUMPAD1 = 97; //���ּ�1��
vck_NUMPAD2 = 98; //���ּ�2��
vck_NUMPAD3 = 99; //���ּ�3��
vck_NUMPAD4 = 100; //���ּ�4��
vck_NUMPAD5 = 101; //���ּ�5��
vck_NUMPAD6 = 102; //���ּ�6��
vck_NUMPAD7 = 103; //���ּ�7��
vck_NUMPAD8 = 104; //���ּ�8��
vck_NUMPAD9 = 105; //���ּ�9��
vck_MULTIPLY = 106; //���ּ����ϵ�*��
vck_ADD = 107; //���ּ����ϵ�+��
vck_SEPARATOR = 108; //Separator��
vck_SUBTRACT = 109; //���ּ����ϵ�-��
vck_DECIMAL = 110; //���ּ����ϵ�.��
vck_DIVIDE = 111; //���ּ����ϵ�/��
//
vck_F1 = 112; //F1��
vck_F2 = 113; //F2��
vck_F3 = 114; //F3��
vck_F4 = 115; //F4��
vck_F5 = 116; //F5��
vck_F6 = 117; //F6��
vck_F7 = 118; //F7��
vck_F8 = 119; //F8��
vck_F9 = 120; //F9��
vck_F10 = 121; //F10��
vck_F11 = 122; //F11��
vck_F12 = 123; //F12��
vck_NUMLOCK = 144; //NumLock��
vck_SCROLL = 145; //ScrollLock��
//
vck_Fenhao = 186; //;(�ֺ�)
vck_DengHao = 187; //=��
vck_DouHao = 188; //,��(����)
vck_Jianhao = 189; //-��(����)
vck_JuHao = 190; //.��(���)
vck_ZuoXieGang = 191; ///��
vck_EscDian = 192; //`��(Esc����)
vck_ZuoZhongKuoHao = 219; //[��
vck_YouXieGang = 220; //\��
vck_YouZhongKuoHao = 221; //]��
vck_YinHao = 222; //'��(����)
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
//  keybd_event(65,MapVirtualKey(65,0),0,0);//���¼�
//  keybd_event(65,MapVirtualKey(65,0),KEYEVENTF_KEYUP,0);//�ͷż�
//end;

procedure vpk_PressKey(vck_Name: Integer);
begin
  keybd_event(vck_Name,MapVirtualKey(vck_Name,0),0,0);//���¼�
  keybd_event(vck_Name,MapVirtualKey(vck_Name,0),KEYEVENTF_KEYUP,0);//�ͷż�
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
