unit uHotKey;

interface

uses
  Windows, Messages;

//�Զ����ݼ�ע��ID
function GetHotKeyRegID(sRegName: string = 'vsDefRegHotKey'): Integer;
//ע��ע��Ŀ�ݼ�
procedure UnRegHotKey(handle: THandle; sRegName: string = 'vsDefRegHotKey');
//ע����Ͽ�ݼ�
procedure RegCrtlHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
procedure RegAltHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
procedure RegShiftHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
procedure RegCtrl_AltHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
procedure RegCtrl_ShiftHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
procedure RegAlt_ShiftHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey'); 

//--
{
 //ִ�п�ݼ�����ʾ��
 procedure DoHotKeyDown(var msg:TMessage); message WM_HOTKEY;
 begin
   if uHotKey.IsPressHotKey_Ctrl(VK_F12, msg) then
    actStopExecute(nil);
 end;
 }
//--
// �ж��Ƿ�����Ӧ��ݼ�
function IsPressHotKey_Ctrl(vk_Name: Integer; var msg: TMessage): Boolean;
function IsPressHotKey_Alt(vk_Name: Integer; var msg: TMessage): Boolean;
function IsPressHotKey_Shift(vk_Name: Integer; var msg: TMessage): Boolean;
function IsPressHotKey_Ctrl_Alt(vk_Name: Integer; var msg: TMessage): Boolean;
function IsPressHotKey_Ctrl_Shift(vk_Name: Integer; var msg: TMessage): Boolean;
function IsPressHotKey_Alt_Shift(vk_Name: Integer; var msg: TMessage): Boolean;

implementation

function GetHotKeyRegID(sRegName: string): Integer;
begin
  Result := GlobalAddAtom(PAnsiChar(sRegName));
end;

procedure RegCrtlHotKey(handle: THandle; vk_Name: Integer; sRegName: string);
begin
  RegisterHotKey(handle, GetHotKeyRegID(sRegName), MOD_CONTROL, vk_Name);
end;

procedure RegAltHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
begin
  RegisterHotKey(handle, GetHotKeyRegID(sRegName), MOD_ALT, vk_Name);
end;

procedure RegShiftHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
begin
  RegisterHotKey(handle, GetHotKeyRegID(sRegName), MOD_SHIFT, vk_Name);
end;

procedure RegCtrl_AltHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
begin
  RegisterHotKey(handle, GetHotKeyRegID(sRegName), MOD_CONTROL + MOD_ALT, vk_Name);
end;

procedure RegCtrl_ShiftHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
begin
  RegisterHotKey(handle, GetHotKeyRegID(sRegName), MOD_CONTROL + MOD_SHIFT, vk_Name);
end;

procedure RegAlt_ShiftHotKey(handle: THandle; vk_Name: Integer; sRegName: string = 'vsDefRegHotKey');
begin
  RegisterHotKey(handle, GetHotKeyRegID(sRegName), MOD_ALT + MOD_SHIFT, vk_Name);
end;

procedure UnRegHotKey(handle: THandle; sRegName: string);
begin
  UnRegisterHotKey(handle, GetHotKeyRegID(sRegName));
end;

//
function IsPressHotKey_Ctrl(vk_Name: Integer; var msg: TMessage): Boolean;
begin
  Result := False;
  if (msg.LParamLo = MOD_CONTROL) and (msg.LParamHi =  vk_Name) then
    Result := True;
end;

function IsPressHotKey_Alt(vk_Name: Integer; var msg: TMessage): Boolean;
begin
  Result := False;
  if (msg.LParamLo = MOD_ALT) and (msg.LParamHi =  vk_Name) then
    Result := True;
end;

function IsPressHotKey_Shift(vk_Name: Integer; var msg: TMessage): Boolean;
begin
  Result := False;
  if (msg.LParamLo = MOD_SHIFT) and (msg.LParamHi =  vk_Name) then
    Result := True;
end;

function IsPressHotKey_Ctrl_Alt(vk_Name: Integer; var msg: TMessage): Boolean;
begin
  Result := False;
  if (msg.LParamLo = MOD_CONTROL or MOD_ALT) and (msg.LParamHi =  vk_Name) then
    Result := True;
end;

function IsPressHotKey_Ctrl_Shift(vk_Name: Integer; var msg: TMessage): Boolean;
begin
  Result := False;
  if (msg.LParamLo = MOD_CONTROL or MOD_SHIFT) and (msg.LParamHi =  vk_Name) then
    Result := True;
end;

function IsPressHotKey_Alt_Shift(vk_Name: Integer; var msg: TMessage): Boolean;
begin
  Result := False;
  if (msg.LParamLo = MOD_ALT or MOD_SHIFT) and (msg.LParamHi =  vk_Name) then
    Result := True;
end;

end.
