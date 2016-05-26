unit ulGetQQList;

interface

uses
  SysUtils, Classes, SHDocVw, MSHTML, Forms;

function GetQQAccountList(bFull: Boolean = True): string;
function GetQQAccountInfo(sQQItem: string; bGetQQNum: Boolean = False): string;
//截取中间字符串
function _GetMidStr(sStr, BeginStr, EndStr: string): string;
//格式化登录的QQ列表，账号之间用逗号分隔
function _GetSubAccList(sStr: string): string;

implementation

function GetQQAccountList(bFull: Boolean): string;
const
  cUrl = 'http://xui.ptlogin2.qq.com/cgi-bin/qlogin';
var
  Doc:IHTMLDocument2;
  Fdiv:IHTMLElement;
  s: string;
  wbLog: TWebBrowser;
begin
  wbLog := TWebBrowser.Create(Application);
  try
    try
      wbLog.Visible := False;
      wbLog.Height := 0;
      wbLog.Width := 0;
      wbLog.ParentWindow := Application.Handle;
      wbLog.Navigate(cUrl);
      while wbLog.ReadyState<>4 do
        Application.ProcessMessages;
      //
      Doc:=wbLog.Document as IHTMLDocument2;
      Fdiv:=Doc.all.item('list_uin',varEmpty) as IHTMLElement;
      s := Fdiv.innerText;
      s := StringReplace(s, ')', '),', [rfReplaceAll]);
      if bFull then
        s := Copy(s, 1, Length(s) - 1)
      else
        s := _GetSubAccList(s);
      Result := s;
    except
      Result := ''
    end;
  finally
    FreeAndNil(wbLog);
  end;
end;

function GetQQAccountInfo(sQQItem: string; bGetQQNum: Boolean = False): string;
var
  s: string;
begin
  if bGetQQNum then
    Result := _GetMidStr(sQQItem, '(', ')')
  else
    Result := Copy(sQQItem, 1, Length(sQQItem) - Pos('(', sQQItem));
end;

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

end.
