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
  { 获得任务栏句柄和边框}
  TrayWindow := FindWindowEx(FindWindow('Shell_TrayWnd',NIL),0,'TrayNotifyWnd',NIL);
  if not GetWindowRect(TrayWindow,WindowRect) then
   Exit;
  { 获得小图标大小}
  SmallIconWidth := GetSystemMetrics(SM_CXSMICON);
  SmallIconHeight := GetSystemMetrics(SM_CYSMICON);
  { 保存当前鼠标位置}
  GetCursorPos(CursorPos);
  { 使鼠标快速划过每个图标 }
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
  {恢复鼠标位置}
  SetCursorPos(CursorPos.X,CursorPos.Y);
  { 重画任务栏 }
  RedrawWindow(TrayWindow,NIL,0,RDW_INVALIDATE OR RDW_ERASE OR RDW_UPDATENOW);
end;

end.
