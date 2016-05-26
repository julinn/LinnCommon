unit ulSendEmail;

interface

uses
  SysUtils, IdSMTP, IdMessage;

type
  TSendEmail = class(TObject)
  private
    SendMstp: TIdSMTP;
    AMessage: TIdMessage;
    function CheckInputInfo(sHost, sPort, sUID, sPwd, SendName, SendMail, Subject, Content,
      GetName, GetMail: string): Boolean;
  public
    constructor Create;
    //Îö¹¹º¯Êý
    destructor Destroy;
    //
    function ConnectMailServer(sHost, sPort, sUID, sPwd: string): Boolean;
    function SendMailToMailBox(sHost, sPort, sUID, sPwd, SendName, SendMail, Subject, Content,
      GetName, GetMail: string; sSubFile: string = ''; iMailKind: Integer = 1): Boolean;

end;

var
  ulSendMail: TSendEmail;  

implementation

{ TSendEmail }

constructor TSendEmail.Create;
begin
  SendMstp := TIdSMTP.Create(nil);
  AMessage := TIdMessage.Create(nil);
end;

destructor TSendEmail.Destroy;
begin
  if SendMstp.Connected then
    SendMstp.Disconnect;
end;

function TSendEmail.CheckInputInfo(sHost, sPort, sUID, sPwd, SendName, SendMail,
  Subject, Content, GetName, GetMail: string): Boolean;
begin
  Result := True;
  if Trim(sHost) = '' then
  begin
    Result := False;
    Exit;
  end;
  if Trim(sPort) = '' then
  begin
    Result := False;
    Exit;
  end;
  if Trim(sUID) = '' then
  begin
    Result := False;
    Exit;
  end;
end;

function TSendEmail.ConnectMailServer(sHost, sPort, sUID, sPwd: string): Boolean;
begin
  with SendMstp do
  begin
    Host := sHost;
    Port := StrToIntDef(sPort, 25);
    AuthType := atDefault;
    Username := sUID;
    Password := sPwd;
    try
      if not Connected then
      Connect;
      Result := True;
    except
      Result := False;
    end;
  end;
end;

function TSendEmail.SendMailToMailBox(sHost, sPort, sUID, sPwd, SendName,
  SendMail, Subject, Content, GetName, GetMail, sSubFile: string;
  iMailKind: Integer): Boolean;
begin
  Result := False;
  if not ConnectMailServer(sHost, sPort, sUID, sPwd) then
    Exit;  
end;

end.
