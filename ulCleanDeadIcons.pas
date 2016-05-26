unit ulCleanDeadIcons;

interface

uses
  Windows;

procedure CleanDeadIcons;

implementation

procedure CleanDeadIcons;
var
  TrayWindow : HWnd;
  WindowRect : TRect;
  SmallIconWidth : Integer;
  SmallIconHeight : Integer;
  CursorPos : TPoint;
  Row : Integer;
  Col : Integer;
begin
  { �������������ͱ߿�}
  TrayWindow := FindWindowEx(FindWindow('Shell_TrayWnd',NIL),0,'TrayNotifyWnd',NIL);
  if not GetWindowRect(TrayWindow,WindowRect) then
   Exit;
  { ���Сͼ���С}
  SmallIconWidth := GetSystemMetrics(SM_CXSMICON);
  SmallIconHeight := GetSystemMetrics(SM_CYSMICON);
  { ���浱ǰ���λ��}
  GetCursorPos(CursorPos);
  { ʹ�����ٻ���ÿ��ͼ�� }
  with WindowRect do
  begin
   for Row := 0 to (Bottom - Top) DIV SmallIconHeight do
   begin
     for Col := 0 to (Right - Left) DIV SmallIconWidth do
     begin
       SetCursorPos(Left + Col * SmallIconWidth, Top + Row * SmallIconHeight);
       Sleep(0);
     end;
   end;
  end;
  {�ָ����λ��}
  SetCursorPos(CursorPos.X,CursorPos.Y);
  { �ػ������� }
  RedrawWindow(TrayWindow,NIL,0,RDW_INVALIDATE OR RDW_ERASE OR RDW_UPDATENOW);
end;

end.
