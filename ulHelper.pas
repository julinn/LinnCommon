unit ulHelper;

interface

uses
  SysUtils, Forms, IniFiles;

type TConnIniConfig = record
  Server: string[128];
  UserID: string[128];
  Passwd: string[128];
  DBName: string[128];
end;

//获取程序运行路径  D:\Linn\DelphiApp\MicroApp\SuperReplay\source\
function GetAppPath: string;
//获取连接配置文件路径
function GetConnIniFilePath(sFileName: string = 'ConnSetting.ini'): string;
//字符串转换成16进制字符串
function StrToHexStr(const S: string): string;
//16进制字符串转换成字符串
function HexStrToStr(const S: string): string;
//反转一个字符串
function ReverseStr(SourceStr : string) : string;
function SimpleEncStr(str: string): string;
function SimpleDesStr(str: string): string;
function CalcEncStr(str: string): string;
function CalcDesStr(str: string): string;
function EncStr(str: string): string;
function DesStr(str: string): string;
//读取连接配置
function GetConnSetting(sFileName: string = 'ConnSetting.ini'): TConnIniConfig;
//保存连接配置
function SaveConnSetting(ConnSett: TConnIniConfig; sFileName: string = 'ConnSetting.ini'): Boolean;
function SaveConnSettingA(Server, UID, Pwd, DBName: string; sFileName: string = 'ConnSetting.ini'): Boolean;
//根据连接配置获取连接字符串
function GetConnString(ConnSett: TConnIniConfig): string;
function GetConnStringA(sFileName: string = 'ConnSetting.ini'): string;
function GetConnStringB(Server, UID, Pwd, DBName: string): string;

//切割字符串； 如【（001）张三】， 返回 sNum = 001  sName = 张三
procedure CutStrNumName(CutStr: string; var sNum: string; var sName: string; sDel: string = ')');
//切割SQL里 NewID 函数获取的结果组成新的编码
function CutNewIDString(sNewID: string; bRevert: Boolean = False): string;
//获取拼音码
function GetPym(sCnStr: string): string;


implementation

function GetAppPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function GetConnIniFilePath(sFileName: string): string;
begin
  Result := GetAppPath + sFileName;
end;

function StrToHexStr(const S: string): string;
var
 I: Integer;
begin
  for I := 1 to Length(S) do
  begin
     if I = 1 then
       Result := IntToHex(Ord(S[1]), 2)
     else Result := Result + IntToHex(Ord(S[I]), 2);
  end;
end;

function HexStrToStr(const S: string): string;
var
 t: Integer;
 ts: string;
 M, Code: Integer;
begin
  t := 1;
  Result := '';
  while t <= Length(S) do
  begin
     while not (S[t] in ['0'..'9', 'A'..'F', 'a'..'f']) do
       inc(t);
     if (t + 1 > Length(S)) or (not (S[t + 1] in ['0'..'9', 'A'..'F', 'a'..'f'])) then
       ts := '$' + S[t]
     else
       ts := '$' + S[t] + S[t + 1];
     Val(ts, M, Code);
     if Code = 0 then
       Result := Result + Chr(M);
     inc(t, 2);
  end;
end;

function ReverseStr(SourceStr : string) : string;
var
  Counter : integer;
begin  
   Result:='';
   for Counter:=1 to length(SourceStr) do  
     Result:=SourceStr[Counter]+Result;
end;

function SimpleEncStr(str: string): string;
begin
  Result := ReverseStr(StrToHexStr(ReverseStr(str)));
end;

function SimpleDesStr(str: string): string;
begin
  Result := ReverseStr(HexStrToStr(ReverseStr(str)));
end;

function CalcEncStr(str: string): string;
var
  s, s1, s2, sKey, ssKey: string;
  i, k: Integer;
begin
  //ReverseStr(StrToHexStr(ReverseStr(str)));      abcd, ba + dcba
  s := ReverseStr(StrToHexStr(ReverseStr(str)));
  k := Length(str);
  if k>=2 then
    s2 := Copy(str, 1, 2)
  else
    s2 := str;
  sKey := ReverseStr(StrToHexStr(s2));
  s1 := sKey + s;
  k := Length(s1);
  if k >=2 then
  begin
    i := k div 2;
    sKey := Copy(s1, i + 1, k-i);
    ssKey := Copy(s1, 1, i);
    s := sKey + ssKey;
  end else
    s := s1;
  Result := HexStrToStr(s);
end;

function CalcDesStr(str: string): string;
var
  s, s1, s2, s3, sKey, ssKey: string;
  i, k: Integer;
begin
  //ReverseStr(HexStrToStr(ReverseStr(str)));
  s3 := StrToHexStr(str);
  k := Length(s3);
  if k >=2 then
  begin
    i := k div 2;
    sKey := Copy(s3, i + 1, k-i);
    ssKey := Copy(s3, 1, i);
    s2 := sKey + ssKey;
  end else
  begin
    s2 := str;
  end;
  s1 :=  HexStrToStr(ReverseStr(s2)); //abcd + ab
  k := Length(s1);
  if k >= 4 then
  begin
    i := k -2;
    s := Copy(s1, 1, i);
  end else
  begin
    s := Copy(s1, 1, 1);
  end;
  Result := ReverseStr(s);
end;

function EncStr(str: string): string;
var
  s, s1, s2: string;
  i, k: Integer;
begin
  s1 := '';
  s2 := '';
  s := ReverseStr(StrToHexStr(ReverseStr(str)));
  k := Length(s);
  for i := 1 to k do
  begin
    if i mod 2 = 0 then
      s2 := s2 + s[i]
    else
      s1 := s1 + s[i];
  end;
  Result := ReverseStr(s1 + s2);
end;

function DesStr(str: string): string;
var
  s, s1, s2, s3, s4: string;
  i, j, k: Integer;
begin
  s := ReverseStr(str);       // 162636   123 666 >  666321
  k := Length(s);
  s4 := '';
  if k mod 2 = 0 then
  begin
    i := k div 2;
    s1 := Copy(s, 1, i);
    s2 := Copy(s, i+1, i);
    //
    s3 := '';
    for j := 1 to i do
    begin
      s3 := s3 + s1[j] + s2[j];
    end;
    s4 :=  ReverseStr(HexStrToStr(ReverseStr(s3)));
  end;
  Result := s4;
end;

function GetConnSetting(sFileName: string): TConnIniConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetConnIniFilePath(sFileName));
  try
    Result.Server := HexStrToStr( IniFile.ReadString('Config', 'Server', ''));
    Result.UserID := HexStrToStr( IniFile.ReadString('Config', 'UserID', ''));
    Result.Passwd := HexStrToStr( IniFile.ReadString('Config', 'Passwd', ''));
    Result.DBName := HexStrToStr( IniFile.ReadString('Config', 'DBName', ''));
  finally
    IniFile.Free;
  end;
end;

function SaveConnSetting(ConnSett: TConnIniConfig; sFileName: string): Boolean;
var
  IniFile: TIniFile;
begin
  Result := False;
  IniFile := TIniFile.Create(GetConnIniFilePath(sFileName));
  try
    IniFile.WriteString('Config', 'Server', StrToHexStr( ConnSett.Server));
    IniFile.WriteString('Config', 'UserID', StrToHexStr( ConnSett.UserID));
    IniFile.WriteString('Config', 'Passwd', StrToHexStr( ConnSett.Passwd));
    IniFile.WriteString('Config', 'DBName', StrToHexStr( ConnSett.DBName));
    Result := True;
  finally
    IniFile.Free;
  end;
end;

function SaveConnSettingA(Server, UID, Pwd, DBName: string; sFileName: string): Boolean;
var
  IniFile: TIniFile;
begin
  Result := False;
  IniFile := TIniFile.Create(GetConnIniFilePath(sFileName));
  try
    IniFile.WriteString('Config', 'Server', StrToHexStr( Server));
    IniFile.WriteString('Config', 'UserID', StrToHexStr( UID));
    IniFile.WriteString('Config', 'Passwd', StrToHexStr( Pwd));
    IniFile.WriteString('Config', 'DBName', StrToHexStr( DBName));
    Result := True;
  finally
    IniFile.Free;
  end;
end;

function GetConnString(ConnSett: TConnIniConfig): string;
const
  c = 'Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;'
    + 'Initial Catalog=%s;Data Source=%s';
begin
  Result := Format(c, [ConnSett.Passwd, ConnSett.UserID, ConnSett.DBName, ConnSett.Server]);
end;

function GetConnStringA(sFileName: string = 'ConnSetting.ini'): string;
begin
  Result := GetConnString(GetConnSetting(sFileName));
end;

function GetConnStringB(Server, UID, Pwd, DBName: string): string;
const
  c = 'Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;'
    + 'Initial Catalog=%s;Data Source=%s';
begin
  Result := Format(c, [Pwd, UID, DBName, Server]);
end;

procedure CutStrNumName(CutStr: string; var sNum: string; var sName: string; sDel: string = ')');
var
 i, k: Integer;
begin
  k := Length(CutStr);
  i := Pos(sDel, CutStr);
  sNum := Copy(CutStr, 2, i -2);
  sName := Copy(CutStr, i+1, k - i);
end;

function CutNewIDString(sNewID: string; bRevert: Boolean): string;
var
  s: string;
begin
  //SELECT replace(NEWID(), '-','')
  Result := '';
  sNewID := StringReplace(sNewID, '-', '', []);
  try
    s := sNewID[1] + sNewID[9] + sNewID[8] + sNewID[6]
      + sNewID[18] + sNewID[15] + sNewID[27] + sNewID[19];
    if bRevert then
      s := ReverseStr(s);
  except
    s := '';
  end;
  Result := s;
end;

function GetPym(sCnStr: string): string;
  function getPY(hzchar:string):char;
  begin
    case word(hzchar[1])shl 8+word(hzchar[2]) of
      $B0a1..$B0c4:result:='A';
      $B0C5..$B2C0:result:='B';
      $B2C1..$B4ED:result:='C';
      $B4EE..$B6E9:result:='D';
      $B6EA..$B7A1:result:='E';
      $B7A2..$B8C0:result:='F';
      $B8C1..$B9FD:result:='G';
      $B9FE..$BBF6:result:='H';
      $BBF7..$BFA5:result:='J';
      $BFA6..$C0AB:result:='K';
      $C0AC..$C2E7:result:='L';
      $C2E8..$C4C2:result:='M';
      $C4C3..$C5B5:result:='N';
      $C5B6..$C5BD:result:='O';
      $C5BE..$C6D9:result:='P';
      $C6DA..$C8BA:result:='Q';
      $C8BB..$C8F5:result:='R';
      $C8F6..$CBF9:result:='S';
      $CBFA..$CDD9:result:='T';
      $CDDA..$CEF3:result:='W';
      $CEF4..$D188:result:='X';
      $D189..$D4D0:result:='Y';
      $D4D1..$D7F9:result:='Z';
    ELSE
      RESULT:=char(32);
    end;
  end;
var
  SPBM, hz: string;
  i: Integer;
begin
  SPBM:='';
  i:=1;
  while i<=length(sCnStr) do
  begin
    if ByteType(sCnStr,i) = mbSingleByte then
            //单字节,不是汉字字节
        SPBM:=SPBM+copy(sCnStr,i,1)
    else   //是汉字，截取2个字节取其拼音码
    begin
       hz:=copy(sCnStr,i,2);
       SPBM:=SPBM+getpy(hz);
       i:=i+1;
    end;
     i:=i+1;
  end;
end;

end.
