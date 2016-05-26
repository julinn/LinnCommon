unit uHttpsPost;

interface

uses Classes, WinINet,Sysutils,windows, IDURI;

procedure Get(url: string;res: TStream); overload;
procedure Post(url, data:string;res:TStream); overload;
function Get(url: string): string; overload;
function Post(url, data: string): string; overload;

implementation

function Get(url: string): string;
var
  s: TStringStream;
begin
  s := TStringStream.Create('');
  try
    Get(url, s);
    result := s.DataString;
  finally
    s.Free;
  end;
end;

function Post(url, data: string): string;
var
  s: TStringStream;
begin
  s := TStringStream.Create('');
  try
    Get(url, s);
    result := s.DataString;
  finally
    s.Free;
  end;
end;

procedure Post(url, data:string;res:TStream);
var
  hInt,hConn,hreq:HINTERNET;
  buffer:PChar;
  dwRead, dwFlags:cardinal;
  port: Word;
  uri: TIdURI;
  proto, host, path: string;
begin
  uri := TIdURI.Create(url);
  host := uri.Host;
  path := uri.Path + uri.Document;
  proto := uri.Protocol;
  uri.Free;
  if UpperCase(proto) = 'HTTPS' then
  begin
    port := INTERNET_DEFAULT_HTTPS_PORT;
    dwFlags := INTERNET_FLAG_SECURE;
  end
  else
  begin
    port := INTERNET_INVALID_PORT_NUMBER;
    dwFlags := INTERNET_FLAG_RELOAD;
  end;
  hInt := InternetOpen('Delphi',INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hConn := InternetConnect(hInt,PChar(host),port,nil,nil,INTERNET_SERVICE_HTTP,0,0);
  hreq := HttpOpenRequest(hConn,'POST',PChar(Path),'HTTP/1.1',nil,nil,dwFlags,0);
  GetMem(buffer, 65536);
  if HttpSendRequest(hReq,nil,0,PChar(data),Length(data)) then
  begin
    dwRead:=0;
    repeat
      InternetReadFile(hreq,buffer,65536,dwRead);
      if dwRead<>0 then
        res.Write(buffer^, dwRead);
    until dwRead=0;
  end;
 InternetCloseHandle(hreq);
 InternetCloseHandle(hConn);
 InternetCloseHandle(hInt);
 FreeMem(buffer);
end;

procedure Get(url: string;res: TStream);
var
  hInt,hUrl:HINTERNET;
  buffer:PChar;
  dwRead:cardinal;
begin
 GetMem(buffer, 65536);
 hInt := InternetOpen('Delphi',INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
 dwRead:=0;
 hurl:=InternetOpenUrl(hInt,PChar(url),nil,0,INTERNET_FLAG_RELOAD,0);
 repeat
   InternetReadFile(hUrl,buffer,1000,dwRead);
   if dwRead<>0 then
     res.Write(buffer^, dwRead);
 until dwRead=0;
 InternetCloseHandle(hUrl);
 InternetCloseHandle(hInt);
 FreeMem(buffer);
end;

end.
