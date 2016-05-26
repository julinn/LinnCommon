unit ulMsgBox;

interface

uses
  Windows, Messages, ExtCtrls, Forms, SysUtils;

function MsgBox(sMsg: string; sTitle: string = ''): Boolean;
function AbortMsg(sMsg:string; sTitle: string = ''): Boolean;
function ConfirmMsg(sMsg:string; sTitle: string = 'Ñ¯ÎÊ'): Boolean;

implementation

function MsgBox(sMsg, sTitle: string): Boolean;
begin
  if sTitle = '' then
    sTitle := Application.Title;
  MessageBox(0, PChar(sMsg), PChar(sTitle), MB_ICONINFORMATION);
end;

function AbortMsg(sMsg, sTitle: string): Boolean;
begin
  if sTitle = '' then
    sTitle := Application.Title;
  MessageBox(0, PChar(sMsg), PChar(sTitle), MB_ICONERROR);
  Abort;
end;

function ConfirmMsg(sMsg, sTitle: string): Boolean;
begin
  if MessageBox(0, PChar(sMsg), PChar(sTitle), MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
    Result := True
  else
    Result := False;
end;

end.
