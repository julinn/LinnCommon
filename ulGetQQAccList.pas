unit ulGetQQAccList;

interface

uses
  Windows, SysUtils, Classes, Forms, SHDocVw, MSHTML;

//Export Function
function GetQQAccList(hand: HWND; form: TForm; QQLogUrl: string = ''): string;
//截取中间字符串
function _GetMidStr(sStr, BeginStr, EndStr: string): string;
//格式化登录的QQ列表，账号之间用逗号分隔
function _GetSubAccList(sStr: string): string;


implementation

function _GetMidStr(sStr, BeginStr, EndStr: string): string;
var
  iBegin, iEnd: Integer;
begin
  iBegin:=AnsiPos(BeginStr,sStr)+length(BeginStr);
  iEnd:=AnsiPos(EndStr,sStr);
  result:=copy(sStr,iBegin,iEnd-iBegin);
end;

function _GetSubAccList(sStr: string): string;
var
  i, iCount: Integer;
  s: string;
  lst: TStringList;
begin
  s := '';
  Result := '';
  try
    if sStr = '' then
      Result := ''
    else
    begin
      i := Length(sStr);
      if sStr[i] = ',' then
        s := Copy(sStr, 1, i - 1);
      lst := TStringList.Create;
      try
        lst.Delimiter := ',';
        lst.DelimitedText := s; 
        iCount := lst.Count;
        for i := 0 to iCount - 1 do
        begin
          s := lst.Strings[i];
          s := _GetMidStr(s, '(', ')');
          if Length(s) > 0 then
          begin
            if Result = '' then
              Result := s
            else
              Result := Result + ',' + s;
          end;
        end;
      finally
        FreeAndNil(lst);
      end;
    end;
  except
    Result := '';
  end;
end;

function GetQQAccList(hand: HWND; form: TForm; QQLogUrl: string = ''): string;
var
  Doc:IHTMLDocument2;
  Fdiv:IHTMLElement;
  s: string;
  wbLog: TWebBrowser;
begin
  if QQLogUrl = '' then
    QQLogUrl := 'http://xui.ptlogin2.qq.com/cgi-bin/qlogin';
  wbLog := TWebBrowser.Create(form);
  try
    try
      wbLog.Visible := False;
      wbLog.Height := 0;
      wbLog.Width := 0;
      wbLog.ParentWindow := hand;
      wbLog.Navigate(QQLogUrl);
      while wbLog.ReadyState<>4 do
        Application.ProcessMessages;
      //
      Doc:=wbLog.Document as IHTMLDocument2;
      Fdiv:=Doc.all.item('list_uin',varEmpty) as IHTMLElement;
      s := Fdiv.innerText;
      s := StringReplace(s, ')', '),', [rfReplaceAll]);
      s := _GetSubAccList(s);
      Result := s;
    except
      Result := ''
    end;
  finally
    FreeAndNil(wbLog);
  end;
end;

end.
