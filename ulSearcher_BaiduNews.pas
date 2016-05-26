unit ulSearcher_BaiduNews;

interface

uses
  SHDocVw, ulCodeConvert, SysUtils, MSHTML;

function GetSearchURL(sStr: string; iPage: integer = 1; iKind: Integer = 0; iCount: Integer = 20): string;
function GetMiddleStr(sStr, BeginStr, EndStr: string): string;
function FormatDataStr(sData: string): string;
function GetDataFromWebBrowser(tWeb: TWebBrowser): string;

implementation

function GetSearchURL(sStr: string; iPage: integer = 1; iKind: Integer = 0; iCount: Integer = 20): string;
const
  cNews = 'http://news.baidu.com/ns?word=%s&pn=%d&cl=2&ct=1&tn=%s&rn=%d&ie=utf-8&bt=0&et=0';
var
  sTemp, sKind: string;
  iNum: Integer;
begin
   Result := '';
  try   
    if iKind = 0 then
      sKind := 'news'
    else
      sKind := 'newstitle';
    iNum := (iPage - 1) * iCount;       
    sTemp := URLEncode(AnsiToUtf8(sStr));
    Result := Format(cNews, [sTemp, iNum, sKind, iCount]);
  except
    //
  end;
end;

function GetMiddleStr(sStr, BeginStr, EndStr: string): string;
var
  iBegin, iEnd: Integer;
begin
  iBegin:=AnsiPos(BeginStr,sStr)+length(BeginStr);
  iEnd:=AnsiPos(EndStr,sStr);
  result:=copy(sStr,iBegin,iEnd-iBegin);
end;

function FormatDataStr(sData: string): string;
begin
  sData := StringReplace(sData, #$A, '', [rfReplaceAll]);
  sData := StringReplace(sData, #$D, '', [rfReplaceAll]);
  sData := StringReplace(sData, #13#10, '', [rfReplaceAll]);
  sData := StringReplace(sData, #13, '', [rfReplaceAll]);
  sData := StringReplace(sData, #10, '', [rfReplaceAll]);
  sData := StringReplace(sData, '<span>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '</span>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '<fontcolor=#666666>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '<fontcolor=#C60A00>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '</font>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '&quot', '', [rfReplaceAll]);
  sData := StringReplace(sData, '<em>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '</em>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '&nbsp;', ' ', [rfReplaceAll]);
  Result := sData;
end;

function GetDataFromWebBrowser(tWeb: TWebBrowser): string;
var
  iall : IHTMLElement;
  sData: string;
  iCount, iIndex: Integer;
begin
  Result := '';
  try
    if Assigned(tWeb.Document) then
    begin
      iall := (tWeb.Document AS IHTMLDocument2).body;
      while iall.parentElement <> nil do
      begin
        iall := iall.parentElement;
      end;
      sData := iall.outerHTML;
      // check valid
      if Pos('class=result', sData) < 1 then
        Exit;
      //½ØÈ¡Êý¾Ý
      sData := GetMiddleStr(sData, '<ul>', '</ul>');
    end;
  except
    Result := '';
  end;
end;

end.
