unit ulHtmlLableAds;

interface

uses
  StdCtrls, ExtCtrls, Graphics, Controls, kbmMemTable, ShellAPI, Windows,
  Dialogs, Classes, IdHTTP, SysUtils;

type TAdInfo = record
  Title: string;
  Hint: string;
  UrlMsg: string;
  Kind: Integer;     // 1：普通； 2：链接； 3：重要通知
end;

procedure AdLableMouseEnter(lblAd: TLabel; tmrAd: TTimer);
procedure AdLableMouseLeave(lblAd: TLabel; tmrAd: TTimer);
procedure AdLableContent(lblAd: TLabel; adInfo: TAdInfo); overload;
procedure AdLableContent(lblAd: TLabel; var FAdCurrIndex: Integer; kbmAd: TkbmMemTable;
  var adInfo: TAdInfo); overload;
procedure AdLableContent(lblAd: TLabel; var FAdCurrIndex: Integer; DataList: TStringList;
  var adInfo: TAdInfo); overload;
procedure AdLableClick(lblAD: TLabel; AdInfo: TAdInfo);
procedure OpenUrl(sUrl: string);
function GetWebPageTxt(sUrl: string): string;
function GetFmtDataListFromUrl(Url: string; var DataList: TStringList): Boolean;
function GetMidStr(sStr, BeginStr, EndStr: string): string;

//uses forms
//procedure vpk_Delay(dwMilliseconds:DWORD = 100);//Longint
//var
//  iStart,iStop:DWORD;
//begin
//  iStart :=   GetTickCount;
//  repeat
//    iStop  :=   GetTickCount;
//    Application.ProcessMessages;
//  until
//   (iStop  -  iStart) >= dwMilliseconds;
//end;

implementation

procedure AdLableMouseEnter(lblAd: TLabel; tmrAd: TTimer);
begin
  lblAd.Font.Style := [fsUnderline];
  lblAd.Cursor := crHandPoint;
  lblAd.ShowHint := true;
  tmrAd.Enabled := False;
end;

procedure AdLableMouseLeave(lblAd: TLabel; tmrAd: TTimer);
begin
  lblAd.Font.Style := [];
  tmrAd.Enabled := True;
end;

procedure AdLableContent(lblAd: TLabel; adInfo: TAdInfo);
begin
  case adInfo.Kind of
    1: begin
      lblAd.Font.Color := clBlack;
    end;
    2: begin
      lblAd.Font.Color := clBlue;
    end;
    3: begin
      lblAd.Font.Color := clRed;
    end;
  else
    lblAd.Font.Color := clBlack;
  end;
  lblAd.Caption := adInfo.Title;
  lblAd.Hint := adInfo.Hint;
end;

procedure AdLableContent(lblAd: TLabel; var FAdCurrIndex: Integer; kbmAd: TkbmMemTable;
  var adInfo: TAdInfo); overload;
begin
  if kbmAd.IsEmpty then
    Exit;
  if FAdCurrIndex = kbmAd.RecordCount + 1 then
    FAdCurrIndex := 1;
  try
    kbmAd.Locate('ID', FAdCurrIndex, []);
    adInfo.Kind := kbmAd.FieldByName('KIND').AsInteger;
    adInfo.Title := kbmAd.FieldByName('TITLE').AsString;
    adInfo.Hint := kbmAd.FieldByName('HINT').AsString;
    adInfo.UrlMsg := kbmAd.FieldByName('URLMSG').AsString;
    AdLableContent(lblAd, adInfo);
  except
    //
  end;
  FAdCurrIndex := FAdCurrIndex + 1;
end;

procedure AdLableContent(lblAd: TLabel; var FAdCurrIndex: Integer; DataList: TStringList;
  var adInfo: TAdInfo); overload;
var
  s: string;
  sList: TStringList;
begin
  if DataList.Count < 1 then
    Exit;
  if FAdCurrIndex > DataList.Count then
    FAdCurrIndex := 1;
  try
    sList := TStringList.Create;
    try
      sList.Delimiter := '|';
      s := DataList.Strings[FAdCurrIndex - 1];
      if s = '' then
        Exit;
      sList.DelimitedText := s;
      if sList.Count < 1 then
        Exit;
      adInfo.Title := sList.Strings[0];
      adInfo.UrlMsg := sList.Strings[1];
      adInfo.Hint := sList.Strings[2];
      adInfo.Kind := 2;
      AdLableContent(lblAd, adInfo);
      FAdCurrIndex := FAdCurrIndex + 1;
    except
      Exit;  
    end;    
  finally
    sList.Free;
  end;
end;

procedure AdLableClick(lblAD: TLabel; AdInfo: TAdInfo);
var
  s: string;
begin
  s := AdInfo.UrlMsg;
  ShellExecute(0, 'open', PChar(s), nil, nil, SW_SHOWNORMAL );
end;

procedure OpenUrl(sUrl: string);
begin
  ShellExecute(0, 'open', PChar(sUrl), nil, nil, SW_SHOWNORMAL );
end;

function GetWebPageTxt(sUrl: string): string;
var
  tempHttp: TIdHTTP;
begin
  tempHttp := TIdHTTP.Create(nil);
  try
    tempHttp.Request.UserAgent := 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)';
    try
      Result := tempHttp.Get(sUrl);
    except
      Result := '';
    end;
  finally
    tempHttp.Free;
  end;
end;

function GetFmtDataListFromUrl(Url: string; var DataList: TStringList): Boolean;
var
  s, sTxt, sTitle, sUrl, sHint: string;
  sList: TStringList;
  i, iCount: Integer;
begin
  Result := False;
  sTxt := GetWebPageTxt(Url);
  if sTxt = '' then
    Exit;
  if (Pos('<li>', sTxt)> 0) and (Pos('</li>', sTxt)> 0) then
  begin
    sTxt := StringReplace(sTxt, '#13', '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, '#10', '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, #$D, '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, #$A, '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, ' ', '', [rfReplaceAll]);
    //保留分隔符
    sTxt := StringReplace(sTxt, '#', '＃', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, '|', '丨', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, '</li>', '</li>#', [rfReplaceAll]);
    if sTxt[Length(sTxt)] = '#' then
      sTxt := Copy(sTxt, 1, Length(sTxt) - 1);
    sList := TStringList.Create;
    try
      try
        sList.Delimiter := '#';
        sList.DelimitedText := sTxt;
        iCount := sList.Count;
        if iCount > 0 then
        begin
          DataList.Clear;
          for i := 0 to iCount - 1 do
          begin
            s := sList.Strings[i];
            s := StringReplace(s, ' ', '', [rfReplaceAll]);
            //<li><a href="http://www.liuju.net" target="_blank" title="非常牛的左侧栏JS折叠菜单">非常牛的左侧栏JS折叠菜单</a></li>
            sUrl := GetMidStr(s, 'href="', '"target="');
            sHint := GetMidStr(s, '"title="', '">');
            sTitle := GetMidStr(s, '">', '</a>');
            DataList.Add(sTitle + '|' + sUrl + '|' + sHint);
          end;          
        end;
        Result := DataList.Count > 0;
      except
        Result := False;
      end;
    finally
      sList.Free;
    end;
  end;
  //
  if (Pos('|', sTxt) > 0) and (Pos('#', sTxt) > 0) then
  begin
    sTxt := StringReplace(sTxt, '#13', '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, '#10', '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, #$D, '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, #$A, '', [rfReplaceAll]);
    sTxt := StringReplace(sTxt, ' ', '', [rfReplaceAll]);
    //
    DataList.Clear;
    try
      DataList.Delimiter := '#';
      DataList.DelimitedText := sTxt;
      Result := DataList.Count > 0;
    except
      Result := False;
    end;
  end;    
end;

function GetMidStr(sStr, BeginStr, EndStr: string): string;
var
  iBegin, iEnd: Integer;
begin
  iBegin:=AnsiPos(BeginStr,sStr)+length(BeginStr);
  iEnd:=AnsiPos(EndStr,sStr);
  result:=copy(sStr,iBegin,iEnd-iBegin);
end;

end.
