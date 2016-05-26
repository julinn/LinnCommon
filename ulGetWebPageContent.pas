unit ulGetWebPageContent;

interface

uses
  wininet, windows, IdHTTP;

function StrPas(const Str: PChar): string;
function GetWebPageContent(const Url: string; bConvertAnsi: Boolean = True):string;
function GetWebPageText(const Url: string; bConvertAnsi: Boolean = False):string;
function ConvertUtf8ToAnsi(const Str: string): string;


implementation

//È¡ÍøÒ³ÄÚÈÝ
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
end;

function ConvertUtf8ToAnsi(const Str: string): string;
begin
  Result :=  Utf8ToAnsi(Str);
end;

function GetWebPageText(const Url: string; bConvertAnsi: Boolean = False):string;
var
  tempHttp: TIdHTTP;
  xml: WideString;
begin
  tempHttp := TIdHTTP.Create(nil);
  try
    tempHttp.Request.UserAgent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)';
    try
      Result := tempHttp.Get(Url);
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
