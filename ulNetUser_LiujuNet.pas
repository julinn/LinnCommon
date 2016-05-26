unit ulNetUser_LiujuNet;

interface

uses
  ulSystem, ulMsgBox, ulGetWebPageContent, ulGetQQAccList, SysUtils;

function CheckUser_LiujuNet: Boolean;

implementation

function CheckUser_LiujuNet: Boolean;
const
  cURL = 'http://www.liuju.net/NetUser/NewsApp/Baidu/%s.txt';
var
  sQQ, sweb: string;
begin
  Result := False;
  try
    ulSystem.ReadTxtToStr(ulSystem.GetAppRunPath + 'userid.ul', sQQ);
    sQQ := ulSystem.HexStrToStr(sQQ);
    sweb := ulGetWebPageContent.GetWebPageContent(Format(cURL, [sQQ]));
    if Length(sQQ) > 4 then
    begin
      if sweb = '1' then
        Result := True;
    end;
  except
    Result := False;
  end;
end;

end.
