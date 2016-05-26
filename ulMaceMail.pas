unit ulMaceMail;

interface

uses
  SysUtils, IdHTTP, Classes;

function SendMail(ReceiveMail, Title, Content, SendAccount, SendAccountPwd: string;
  Smtp: string = ''; PortNo: string = ''; ShowSenderName: string = ''): string;

implementation

function SendMail(ReceiveMail, Title, Content, SendAccount, SendAccountPwd: string;
  Smtp: string = ''; PortNo: string = ''; ShowSenderName: string = ''): string;
const
  cUrl = 'http://mace.sinaapp.com/api/mail.php?m=%s&t=%s&a=%s&p=%s';
var
  sUrl, sRet, sContent: string;
  Sender: TIdHTTP;
  tContent: TStrings;
begin
  Result := '';
  try
    Sender := TIdHTTP.Create(nil);
    tContent := TStringList.Create;
    try
      sUrl := Format(cUrl, [ReceiveMail, Title, SendAccount, SendAccountPwd]);
      if Smtp <> '' then
        sUrl := sUrl + '&s=' + Smtp;
      if PortNo <> '' then
        sUrl := sUrl + '&o=' + PortNo;
      if ShowSenderName <> '' then
        sUrl := sUrl + '&n=' + ShowSenderName;
      sUrl := AnsiToUtf8(sUrl);
      sContent := StringReplace(Content, #$D#$A, '<br/>', [rfReplaceAll]);
      sContent := '_c='+ sContent;
      sContent := AnsiToUtf8(sContent);
      tContent.Add(sContent);
      Sender.ReadTimeout := 10*1000;
      sRet := Sender.Post(sUrl, tContent);
      sUrl := Utf8ToAnsi(sUrl);
      if sRet = 'OK' then
        Result := ''
      else
        Result := '·¢ËÍÊ§°Ü£¡'+#13#10+'URL£º'+ sUrl +#13#10+ '´íÎóÏûÏ¢£º'+sRet;
    except
      on E: Exception do
        Result := '·¢ËÍÊ§°Ü£¡'+#13#10+'URL£º'+ sUrl +#13#10+ '´íÎóÏûÏ¢£º'+E.Message;
    end;
  finally
    FreeAndNil(Sender);
    tContent.Free;
  end;
end;

end.
