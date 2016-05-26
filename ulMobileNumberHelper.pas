{
  从新浪网获取手机归属地信息
}
unit ulMobileNumberHelper;

interface

uses
  SysUtils, wininet, windows, IdHTTP;

Type
  TMobileNumberlInfo = record
    OwnAddress: string;
    CardKind: string;
    Service: string;
    AreaNo: string;
    PostCode: string;
  end;

//Export Function
function GetMobileNumberInfo(sMobiNumber: string; var TMobiNoInfo: TMobileNumberlInfo): Boolean;
//
function CheckMobiNo(sMobiNumber: string): Boolean;
function FormatData(sHtml: string; var TMobiNoInfo: TMobileNumberlInfo): Boolean;
function StrPas(const Str: PChar): string;
function GetWebPageContent(const Url: string; bConvertAnsi: Boolean = True):string;
function ConvertUtf8ToAnsi(const Str: string): string;
function GetMiddleStr(sStr, BeginStr, EndStr: string): string;
procedure MsgBox(sMsg: string; sTitle: string = '提示');
function GetWebDocByUrl(sUrl: string; bConvertAnsi: Boolean = True): string;

const
  cServiceURL = 'http://life.tenpay.com/cgi-bin/mobile/MobileQueryAttribution.cgi?chgmobile=';
  //'http://dp.sina.cn/dpool/tools/moblie/index.php?moblie=';

implementation

function GetMobileNumberInfo(sMobiNumber: string; var TMobiNoInfo: TMobileNumberlInfo): Boolean;
var
  sURL, sHtml: widestring;
  sp: PChar;
begin
  Result := False;
  if not CheckMobiNo(sMobiNumber) then
    Exit;
  sURL := cServiceURL + sMobiNumber;
  sHtml := GetWebDocByUrl(sURL, False);
  Result := FormatData(sHtml, TMobiNoInfo);
end;

function CheckMobiNo(sMobiNumber: string): Boolean;
var
  s1, s2: string;
begin
  Result := False;
  if (Length(sMobiNumber) < 7) or (Length(sMobiNumber) > 11) then
    Exit;
  s1 := Copy(sMobiNumber, 1, 6);
  s2 := Copy(sMobiNumber, 7, 5);
  if (StrToIntDef(s1, 0) = 0) or (StrToIntDef(s2, 0) = 0) then
    Exit;
  Result := True;
end;

function FormatData(sHtml: string; var TMobiNoInfo: TMobileNumberlInfo): Boolean;
var
  sData, sRetMsg: string;
begin
  Result := False;
  TMobiNoInfo.OwnAddress := '';
  TMobiNoInfo.CardKind := '';
  TMobiNoInfo.Service := '';
  TMobiNoInfo.AreaNo := '';
  TMobiNoInfo.PostCode := '';
  sData := StringReplace(sHtml, ' ', '', [rfReplaceAll]);
  sData := StringReplace(sData, #10, '', [rfReplaceAll]);
  sData := StringReplace(sData, #13, '', [rfReplaceAll]);
  //新浪
  {
  sData := GetMiddleStr(sData, '<section>', '</section>') + '</section>';
  sData := StringReplace(sData, '<br/>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '<spanclass="cell">', '', [rfReplaceAll]);
  sData := StringReplace(sData, '</span>', '', [rfReplaceAll]);
  sData := StringReplace(sData, '<divclass="row">', '', [rfReplaceAll]);
  sData := StringReplace(sData, '</div>', '', [rfReplaceAll]);
  }
  //
  sRetMsg := GetMiddleStr(sData, '<retmsg>', '</retmsg>');
  if UpperCase(sRetMsg) <> 'OK' then
    Exit;  
  try
    TMobiNoInfo.OwnAddress := GetMiddleStr(sData, '<province>', '</province>')
                            + GetMiddleStr(sData, '<city>', '</city>');
    //TMobiNoInfo.CardKind := GetMiddleStr(sData, '<supplier>', '</supplier>');
    TMobiNoInfo.Service := GetMiddleStr(sData, '<supplier>', '</supplier>');
    //TMobiNoInfo.AreaNo := GetMiddleStr(sData, '区号', '邮编');
    //TMobiNoInfo.PostCode := GetMiddleStr(sData, '邮编', '</section>');
    Result := True;
  except
    Result := False;
  end;
end;

//取网页内容
function StrPas(const Str: PChar): string;
begin
  Result := Str;
end;

function GetWebPageContent(const Url: string; bConvertAnsi: Boolean = True):string;
var
  Session,
  HttpFile:HINTERNET;
  szSizeBuffer:Pointer;
  dwLengthSizeBuffer:DWord;
  dwReserved:DWord;
  dwFileSize:DWord;
  dwBytesRead:DWord;
  Contents:PChar;
begin
  try
    Session:=InternetOpen('',0,niL,niL,0);
    HttpFile:=InternetOpenUrl(Session,PChar(Url),niL,0,0,0);
    dwLengthSizeBuffer:=1024;
    HttpQueryInfo(HttpFile,5,szSizeBuffer,dwLengthSizeBuffer,dwReserved);
    GetMem(Contents,dwFileSize);
    InternetReadFile(HttpFile,Contents,dwFileSize,dwBytesRead);
    InternetCloseHandle(HttpFile);
    InternetCloseHandle(Session);
    Result:=StrPas(Contents);
    FreeMem(Contents);
    if bConvertAnsi then
      Result :=  ConvertUtf8ToAnsi(Result);
  except
    Result := '';
  end;
end;

function ConvertUtf8ToAnsi(const Str: string): string;
begin
  Result :=  Utf8ToAnsi(Str);
end;

function GetMiddleStr(sStr, BeginStr, EndStr: string): string;
var
  iBegin, iEnd: Integer;
begin
  iBegin:=AnsiPos(BeginStr,sStr)+length(BeginStr);
  iEnd:=AnsiPos(EndStr,sStr);
  result:=copy(sStr,iBegin,iEnd-iBegin);
end;

procedure MsgBox(sMsg: string; sTitle: string = '提示');
begin
  MessageBox(0, PChar(sMsg), PChar(sTitle), 0);
end;

function GetWebDocByUrl(sUrl: string; bConvertAnsi: Boolean = True): string;
var
  tempHttp: TIdHTTP;
  xml: WideString;
begin
  tempHttp := TIdHTTP.Create(nil);
  try
    tempHttp.Request.UserAgent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)'; //'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Maxthon)';//             　　
    try
      Result := tempHttp.Get(sUrl);
      if bConvertAnsi then
        Result :=  ConvertUtf8ToAnsi(Result);
    except
      Result := '';
    end;
  finally
    tempHttp.Free;
  end;
end;

end.
