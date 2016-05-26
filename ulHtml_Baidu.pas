unit ulHtml_Baidu;

interface

uses
  ulSystem, SysUtils, IdHTTP, PerlRegEx, pcre, Classes, XMLDoc,
  SHDocVw, MSHTML;

function GetEnCodeStr(src: string): string;
function GetMidStr(sStr, BeginStr, EndStr: string): string;
function GetSearchUrl_BaiduNews(sStr: string; iPage: integer = 1; iKind: Integer = 0; iCount: Integer = 20): string;
//
function GetWebDocByUrl(sUrl: string; sKeyWord: string = ''; sTag: string = ''; iCustID: Integer = 0): string;
function GetUrlData_Baidu(sData: string): string;
function FormatDataList_Baidu(sData: string): string;
function GeturlDataList_Baidu(sData: string): string;
function GetDataSQL_Baidu(sData: string; var xml: WideString; sKeyWord: string = '';
  sTag: string = ''; iCustID: Integer = 0): Boolean;
function FormatNewsDatetime(sDate: string): string;
//
function Gb2312ToUnicode(sStr: string): string;
function UnicodeToGb2312(sStr: string): string;

//
function URLEncode(const S: string; const InQueryString: Boolean = True): string;
function URLDecode(const S: string): string;

function GetUrlHtml(tWeb: TWebBrowser): string;

//
function GetUrlData_Baidu_New(sData: string): string;

implementation

function GetWebDocByUrl(sUrl: string; sKeyWord: string = ''; sTag: string = ''; iCustID: Integer = 0): string;
var
  tempHttp: TIdHTTP;
  xml: WideString;
begin
  tempHttp := TIdHTTP.Create(nil);
  try
    tempHttp.Request.UserAgent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)'; //'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Maxthon)';//             　　
    try
      Result := tempHttp.Get(sUrl);
      Result := GetUrlData_Baidu_New(Result);
      GetDataSQL_Baidu(Result, xml, sKeyWord, sTag, iCustID);
      Result := xml;
    except
      //Result := '';
      on e: Exception do
        Result := e.Message;
    end;
  finally
    tempHttp.Free;
  end;
end;

function GetEnCodeStr(src: string): string;
  var i: integer; 
begin
  result := URLEncode(AnsiToUtf8(src));
//  for i := 1 to length(src) do
//  begin 
//     //Dec2Hex用于返回十进制数的十六进制编码字符串
//    //result := result + '%' + StrToHexStr(ord(src[i]));
//    if src[i] = ' ' then
//      Result := Result + '+'
//    else
//      Result := result + '%' + StrToHexStr(src[i]);
//  end;
end;

function GetMidStr(sStr, BeginStr, EndStr: string): string;
var
  iBegin, iEnd: Integer;
begin
  iBegin:=AnsiPos(BeginStr,sStr)+length(BeginStr); //AnsiPos
  iEnd:=AnsiPos(EndStr,sStr);
  result:=copy(sStr,iBegin,iEnd-iBegin);
end;

function GetSearchUrl_BaiduNews(sStr: string; iPage: integer = 1; iKind: Integer = 0; iCount: Integer = 20): string;
const
  cDef = 'http://news.baidu.com/ns?word=%s&tn=news&from=news&ie=gb2312&sr=0&cl=2&rn=%d&ct=0&prevct=no';
  cTit = 'http://news.baidu.com/ns?word=%s&tn=newstitle&from=news&ie=gb2312&sr=0&cl=2&rn=%d&ct=0&prevct=1';
  cUl1 = 'http://news.baidu.com/ns?word=%s&pn=%d&cl=2&ct=1&tn=news&rn=%d&ie=gb2312&bt=0&et=0';
  //2013-10-29 14:21:11
  //http://news.baidu.com/ns?word=%E6%B7%B1%E5%9C%B3&pn=0&cl=2&ct=1&tn=news&rn=20&ie=utf-8&bt=0&et=0
 cNews = 'http://news.baidu.com/ns?word=%s&pn=%d&cl=2&ct=1&tn=news&rn=%d&ie=utf-8&bt=0&et=0';
var
  sTemp: string;
  iNum: Integer;
begin
  Result := '';
  iNum := (iPage - 1) * iCount;       
  sTemp := GetEnCodeStr(sStr);
//  if iKind = 0 then
//    Result := Format(cDef, [sTemp, iCount])
//  else
//    Result := Format(cTit, [sTemp, iCount]);
  Result := Format(cNews, [sTemp, iNum, iCount]);
end;

function GetUrlData_Baidu_New(sData: string): string;
var
  sTemp: string;
  reg: TPerlRegEx;
begin
  sData := Utf8ToAnsi(sData);
  //sData :=  GetMidStr(sData, '<ul>', '</ul>');
  sData := GetMidStr(sData, '<div id="content_left">', '<div id="rs">');
  //替换#，|；    |，# 作为保留分隔符
  sData := StringReplace(sData, '#', '＃', [rfReplaceAll]);
  sData := StringReplace(sData, '|', '丨', [rfReplaceAll]);
  //
  sTemp := '';
  reg := TPerlRegEx.Create;
  try
    reg.Subject := sData;
    reg.RegEx := '<h3 class="c-title">.*?[\s\S]*?<a href="http://cache.baidu.com'; //<table.*?</table>
    while reg.MatchAgain do
    begin
      if sTemp = '' then
        sTemp := reg.MatchedText
      else
        sTemp := sTemp + '#' + reg.MatchedText;
    end;
    sTemp := FormatDataList_Baidu(sTemp);
    Result := GeturlDataList_Baidu(sTemp);
  except
    Result := '';
  end;
end;

function GetUrlData_Baidu(sData: string): string;
var
  sTemp: string;
  reg: TPerlRegEx;
begin
  reg := TPerlRegEx.Create;
  sTemp := '';
  try
    reg.Subject := sData;
    //<table cellspacing=0 cellpadding=2>  // <table.*?[\s\S]*</table>
    reg.RegEx := '<table cellspacing=0 cellpadding=2>.*?[\s\S]*?</nobr></font>'; //<table.*?</table>

    //reg.RegEx := '<table[^>]*>(((<table[^>]*>(?<o>)|</table>(?<-o>)|(?!</?table)[\s\S])*)(?(o)(?!)))\b' + '\b(?:(?!<table[^>]*>)[\s\S])*?(((<table[^>]*>(?<o>)|</table>(?<-o>)|(?!</?table)[\s\S])*)(?(o)(?!)))</table>';

    while reg.MatchAgain do
    begin
      if sTemp = '' then
        sTemp := reg.MatchedText
      else
        sTemp := sTemp + ';' + reg.MatchedText;
    end;
    //Result := sTemp;
//    reg.Subject := sTemp;
//    //reg.RegEx := '(<script language="javascript">)*?[\\s\\S]*((</script>)|(/>))';
//    reg.RegEx := '\<[^>]+()\>';
//    while reg.MatchAgain do
//    begin
//      Result := StringReplace(sTemp,reg.MatchedText,'',[rfReplaceAll]); //删除HTTP标签
//    end;
    sTemp := FormatDataList_Baidu(sTemp);
    Result := GeturlDataList_Baidu(sTemp);
  except
    Result := '';
  end;
  FreeAndNil(reg);
end;

function FormatDataList_Baidu(sData: string): string;
begin
  sData := StringReplace(sData, #$A, '', [rfReplaceAll]);
  sData := StringReplace(sData, ' ', '', [rfReplaceAll]);
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
  sData := StringReplace(sData, '&nbsp;', '', [rfReplaceAll]);
  sData := StringReplace(sData, '<tablecellspacing=0cellpadding=2><tr><tdclass="text"colspan=2>', '', [rfReplaceAll]);
  Result := sData;
end;

function GeturlDataList_Baidu(sData: string): string;
var
  s, sTemp, sUrl, sTitle, sDate: string;
  lstMain: TStringList;
  i, iMain: Integer;
begin
  Result := '';
  sTemp := '';
  if sData = '' then
    Exit;
  lstMain := TStringList.Create;
  try
    lstMain.Delimiter := '#';
    lstMain.DelimitedText := sData;  
    iMain := lstMain.Count;
    if iMain = 0 then
      Exit;
    for i := 0 to iMain - 1 do
    begin
      s := lstMain.Strings[i];
      sUrl := GetMidStr(s, '<ahref="', '"data-click=');
      sTitle := GetMidStr(s, 'target="_blank">', '</a></h3>');
      sDate := GetMidStr(s, 'class="c-author">', '</p>');
      sDate := FormatNewsDatetime(sDate);
      sTemp := sTitle + '|' + sUrl + '|' + sDate;
      if Result = '' then
        Result := sTemp
      else
        Result := Result + '#' + sTemp;
    end;
  finally
    lstMain.Free;
  end;
end;

function GetDataSQL_Baidu(sData: string; var xml: WideString; sKeyWord: string = '';
  sTag: string = ''; iCustID: Integer = 0): Boolean;
const
  cSQL = ' exec CRM_SearchWebNews_Edit  ''%s'', ''%s'', '''', %d, 0, ''%s'', ''%s'', ''%s''';
var
  iMain, iMainCount: Integer;
  sMain, s, sUrl, sTitle, sDate: string;
  lstMain, lstDetail: TStringList;
begin
  Result := False;
  xml := '';
  if sData = '' then
    Exit;
  lstMain := TStringList.Create;
  lstDetail := TStringList.Create;
  try
    //
    lstMain.Delimiter := '#';
    lstMain.DelimitedText := sData;
    iMainCount := lstMain.Count;
    if iMainCount = 0 then
      Exit;
    for iMain := 0 to iMainCount - 1 do
    begin
      sMain := lstMain.Strings[iMain];
      lstDetail.Delimiter := '|';
      lstDetail.DelimitedText := sMain;
      sTitle := lstDetail.Strings[0];
      sUrl := lstDetail.Strings[1];
      sDate := lstDetail.Strings[2];
      //
//      s := 'IF NOT EXISTS (SELECT 1 FROM [TABLE] WHERE [Url] = ''%s'') '
//        +'INSERT INTO [TABLE]([Title], [Url], [FDate]) VALUES(''%s'', ''%s'', ''%s'') ';
      //s := Format(s, [sUrl, sTitle, sUrl, sDate]);
      s := Format(cSQL, [sTitle, sUrl, iCustID, sKeyWord, sTag, sDate]);
      if xml = '' then
        xml := s
      else
        xml := xml + #10#13#10#13 + s;
    end;
    Result := True;
  finally
    lstMain.Free;
    lstDetail.Free;
  end;
end;

function FormatNewsDatetime(sDate: string): string;
var
  iDateLen: Integer;
  dt: TDateTime;
begin
  try
    iDateLen := Length(sDate);
    if Pos(':', sDate) > 0 then
    begin
      Result := Copy(sDate, iDateLen - 14, 10);
      dt := StrToDateDef(Result, StrToDate('1900-01-01'));
      if FormatDateTime('yyyy-mm-dd', dt) = '1900-01-01' then
        Result := Copy(sDate, iDateLen - 17, 10);
    end
    else
      Result := Copy(sDate, iDateLen - 9, 10);
    if FormatDateTime('yyyy-mm-dd', dt) = '1900-01-01' then
        Result := '';
  except
    Result := '';
  end;
end;

function Gb2312ToUnicode(sStr: string): string;
var
  s: string;
  i, j, k: integer;
  a: array [1..160] of char;
begin
  s:='';
  StringToWideChar(sStr, @(a[1]), 500);
  i:=1;
  while ((a[i]<>#0) or (a[i+1]<>#0)) do
  begin
    j:=Integer(a[i]);
    k:=Integer(a[i+1]);
    s:=s+Copy(Format('%X ',[k*$100+j+$10000]) ,2,4);
    //S := S + Char(k)+Char(j);
    i:=i+2;
  end;
  Result:=s;
end;

function UnicodeToGb2312(sStr: string): string;
Var
  I: Integer;
begin
  I := Length(sStr);
  while I >=4 do
  begin
    try
      Result :=WideChar(StrToInt('$'+sStr[I-3]+sStr[I-2]+sStr[I-1]+sStr[I]))+ Result;
    except
      //
    end;
    I := I - 4;
  end;
end;

function URLEncode(const S: string; const InQueryString: Boolean = True): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
    else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer; // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;

function GetUrlHtml(tWeb: TWebBrowser): string;
var
  iall : IHTMLElement;
begin
  Result := '';
  tWeb.Height := 0;
  tWeb.Width := 0;
  try
    try
      //tWeb.Navigate(sUrl);
      //if Assigned(tWeb.Document) then
      //begin
        iall := (tWeb.Document AS IHTMLDocument2).body;
        while iall.parentElement <> nil do
        begin
          iall := iall.parentElement;
        end;
        Result := iall.outerHTML;
      //end;
    except
      on e: Exception do
        Result := e.Message;
    end;
  finally
    //
  end;
end;

end.
