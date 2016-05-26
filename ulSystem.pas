unit ulSystem;

interface

uses
  SysUtils, Forms, IniFiles, ADODB, Windows;

type TConnIniConfig = record
  Server: string[128];
  UserID: string[128];
  Passwd: string[128];
  DBName: string[128];
end;

//��ȡ��������·��   D:\Linn\DelphiApp\MicroApp\SuperReplay\source\
function GetAppRunPath: string;
function _FormatFilePatDir(sPath: string): string;
procedure vpk_Delay(dwMilliseconds:DWORD = 100);//Longint

{ =========  SQL�������� ==========}
//��ȡ���������ļ�·��
function GetConnIniFilePath(sFileName: string = 'ConnSetting.ini'): string;
//��ȡ��������
function GetConnSetting(sFileName: string = 'ConnSetting.ini'): TConnIniConfig;
//������������
function SaveConnSetting(ConnSett: TConnIniConfig; sFileName: string = 'ConnSetting.ini'): Boolean; overload;
function SaveConnSetting(Server, UID, Pwd, DBName: string; sFileName: string = 'ConnSetting.ini'): Boolean; overload;
//�����������û�ȡ�����ַ���
function GetConnString(ConnSett: TConnIniConfig): string; overload;
function GetConnString(sFileName: string = 'ConnSetting.ini'): string;overload;
function GetConnString(Server, UID, Pwd, DBName: string): string;overload;
//��������
function TestConnString(Server, UID, Pwd, DBName: string; iTimeOut: Integer = 3000): Boolean; overload;
function TestConnString(): Boolean; overload;
function ExecuteSql(var Errmsg: string; Sql: string; connStr: string = ''; iTimeOut: Integer = 3000): Boolean;
function GetFirstData(Sql: string; FieldName: string = ''; connStr: string = ''; iTimeOut: Integer = 3000): string;

{ ============= �ļ��������� ========}
//�����ļ���·��
procedure CheckFilePath(sFilePath: string);
function DeleteDirectory(NowPath: string; bDelDir: Boolean = False): Boolean;
//�����ַ�����TXT�ļ�
function SaveStrToTxt(sStr: string; sFileName: string): Boolean;
//���TXT�ļ�֪����� ������·�� D:\Linn\DelphiApp\MicroApp\SuperReplay\source\xxx.txt��
function CheckTxtIsExists(sFileName: string): Boolean;
//��ȡtxt�ļ����ݵ� �ַ����� Ĭ���л��з�����ֱ�Ӹ��Ƶ� memo �ؼ�)
function ReadTxtToStr(sFileName: string; var sStr: string; sRowChar: string = #13#10): Boolean;
//���ӵ�TXT�ļ�β��
function AppendStrToTxt(sFileName, sStr: string): Boolean;
//��ȡ�����ַ���
function GetNowDateString(fmt: string = 'yyyy-mm-dd'): string;
//�����Զ��������ļ�
function SaveAnyIniFile(sNodeName, sNodeValue: string; sCfgName: string = 'DEFCFG';
  sFileName: string = 'DEFAULTCONFIG.ini'; sPath: string = ''; bHexStr: Boolean = True): Boolean;
//��ȡ�Զ��������ļ�
function ReadAnyIniFile(sNodeName: string;sCfgName: string = 'DEFCFG';
  sFileName: string = 'DEFAULTCONFIG.ini'; sPath: string = ''; bHexStr: Boolean = True): string;

{    =========        ��������  =========== }
//�ַ���ת����16�����ַ���
function StrToHexStr(const S: string): string;
//16�����ַ���ת�����ַ���
function HexStrToStr(const S: string): string;
//��תһ���ַ���
function ReverseStr(SourceStr : string) : string;
//�и��ַ����� �硾��001���������� ���� sNum = 001  sName = ����
procedure CutStrNumName(CutStr: string; var sNum: string; var sName: string; sDel: string = ')');
//�и�SQL�� NewID ������ȡ�Ľ������µı���
function CutNewIDString(sNewID: string; bRevert: Boolean = False): string;
//��ȡƴ����
function GetPym(sCnStr: string): string;
//
function GetMiddleStr(sStr, BeginStr, EndStr: string): string;
//�򵥼���
function EncString(sStr: string): string;
//�򵥽���
function DecString(sStr: string): string;
//
function GetCPUID(): string;
function GetVolumeID(): string;

implementation

function GetAppRunPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function _FormatFilePatDir(sPath: string): string;
var
  s: string;
begin
  s := Copy(sPath, Length(sPath), 1);     
  if s = '\' then
    Result := sPath
  else
    Result := sPath + '\';
end;

procedure vpk_Delay(dwMilliseconds:DWORD = 100);//Longint
var
  iStart,iStop:DWORD;
begin
  iStart :=   GetTickCount;
  repeat
    iStop  :=   GetTickCount;
    Application.ProcessMessages;
  until
   (iStop  -  iStart) >= dwMilliseconds;
end;

function GetConnIniFilePath(sFileName: string): string;
begin
  Result := GetAppRunPath + sFileName;
end;

function GetConnSetting(sFileName: string): TConnIniConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetConnIniFilePath(sFileName));
  try
    Result.Server := HexStrToStr( IniFile.ReadString('CONFIG', 'SERVER', ''));
    Result.UserID := HexStrToStr( IniFile.ReadString('CONFIG', 'USERID', ''));
    Result.Passwd := HexStrToStr( IniFile.ReadString('CONFIG', 'PASSWD', ''));
    Result.DBName := HexStrToStr( IniFile.ReadString('CONFIG', 'DBNAME', ''));
  finally
    IniFile.Free;
  end;
end;

function SaveConnSetting(ConnSett: TConnIniConfig; sFileName: string): Boolean; overload;
var
  IniFile: TIniFile;
begin
  Result := False;
  IniFile := TIniFile.Create(GetConnIniFilePath(sFileName));
  try
    IniFile.WriteString('CONFIG', 'SERVER', StrToHexStr( ConnSett.Server));
    IniFile.WriteString('CONFIG', 'USERID', StrToHexStr( ConnSett.UserID));
    IniFile.WriteString('CONFIG', 'PASSWD', StrToHexStr( ConnSett.Passwd));
    IniFile.WriteString('CONFIG', 'DBNAME', StrToHexStr( ConnSett.DBName));
    Result := True;
  finally
    IniFile.Free;
  end;
end;

function SaveConnSetting(Server, UID, Pwd, DBName: string; sFileName: string): Boolean; overload;
var
  IniFile: TIniFile;
begin
  Result := False;
  IniFile := TIniFile.Create(GetConnIniFilePath(sFileName));
  try
    IniFile.WriteString('CONFIG', 'SERVER', StrToHexStr( Server));
    IniFile.WriteString('CONFIG', 'USERID', StrToHexStr( UID));
    IniFile.WriteString('CONFIG', 'PASSWD', StrToHexStr( Pwd));
    IniFile.WriteString('CONFIG', 'DBNAME', StrToHexStr( DBName));
    Result := True;
  finally
    IniFile.Free;
  end;
end;

function GetConnString(ConnSett: TConnIniConfig): string; overload;
const
  c = 'Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;'
    + 'Initial Catalog=%s;Data Source=%s';
begin
  Result := Format(c, [ConnSett.Passwd, ConnSett.UserID, ConnSett.DBName, ConnSett.Server]);
end;

function GetConnString(sFileName: string = 'ConnSetting.ini'): string;overload;
begin
  Result := GetConnString(GetConnSetting(sFileName));
end;
   
procedure CheckFilePath(sFilePath: string);
begin
  if not DirectoryExists(sFilePath) then
    ForceDirectories(sFilePath);//ǿ�ƴ���
end;

function DeleteDirectory(NowPath: string; bDelDir: Boolean = False): Boolean;
var
  search: TSearchRec;
  ret: integer;
  key: string;
begin
  if NowPath[Length(NowPath)] <> '\' then
    NowPath := NowPath + '\';
  key := NowPath + '*.*';
  ret := findFirst(key, faanyfile, search);
  while ret = 0 do
  begin
    if ((search.Attr and fadirectory) = fadirectory) then
    begin
      if (search.Name <> '.') and (search.name <> '..') then
        DeleteDirectory(NowPath + search.name);
    end
    else
    begin
      if ((search.Attr and fadirectory) <> fadirectory) then
      begin
        deletefile(PChar(NowPath + search.name));
      end;
    end;
    ret := FindNext(search);
  end;
  findClose(ret);
  if bDelDir then
    removedir(NowPath); //�����Ҫɾ���ļ��������
  result := True;
end;

function SaveStrToTxt(sStr: string; sFileName: string): Boolean;
var
  i: Integer;
  TxtFile: TextFile;
begin
  //FileName := '\\192.168.2.13\ZPLX\ZMZ.txt';
  Result := False;
  try
    // �ı��ļ���ֵ
    AssignFile(TxtFile, sFileName);
    // ����ļ�������,���½��ļ�;����ļ�����,��ɾ�����ؽ��ļ�
    Rewrite(TxtFile);
    // д���ַ���
    Writeln(TxtFile, sStr);      //ʵ������˵�ġ��㷨1���㷨2��
    // ����Ѵ��ļ��Ļ���
    Flush(TxtFile);
    // �ر��ļ�
    CloseFile(TxtFile);
  except
    on e: Exception do
      Application.HandleException(nil);
  end; // try/except
  if FileExists( sFileName ) then   //�����ļ��Ƿ���ڣ�������� �㷨3
    Result := True
  //�򿪸ղű�����ļ�
  //WinExec(PAnsiChar('notepad.exe  ' + sFileName), SW_SHOWNORMAL);
end;

function CheckTxtIsExists(sFileName: string): Boolean;
begin
  //FileName := '\\192.168.2.13\ZPLX\ZMZ.txt';
  Result := FileExists( sFileName );
end;

function ReadTxtToStr(sFileName: string; var sStr: string; sRowChar: string): Boolean;
var
  F: TextFile;
  S: string;
begin
  Result := False;
  try
    sStr := '';
    AssignFile(F, sFileName); {���ļ�������� F ����}
    Reset(F); {�򿪲���ȡ�ļ� F }
    while not eof(F) do
    begin
      Readln(F, S);
      if sStr = '' then
        sStr := S
      else
        sStr := sStr + sRowChar + S;
    end;
    Closefile(F); {�ر��ļ� F}
    if sStr <> '' then
      Result := True;
  except
    Result := False;
  end;
end;

function AppendStrToTxt(sFileName, sStr: string): Boolean;
var
  F: TextFile;
begin
  Result := False;
  try
    AssignFile(F, sFileName);
    if CheckTxtIsExists(sFileName) = False then
    begin
      Result := SaveStrToTxt(sStr, sFileName);
      Exit;
    end;
    Append(F);
    Writeln(F, sStr);
    CloseFile(F);
  except
    Result := False;
  end;
end;

function GetNowDateString(fmt: string = 'yyyy-mm-dd'): string;
begin
  try
    Result := FormatDateTime(fmt, Now);
  except
    Result := FormatDateTime('yyyy-mm-dd', Now);
  end;
end;

function SaveAnyIniFile(sNodeName, sNodeValue: string; sCfgName: string = 'DEFCFG';
  sFileName: string = 'DEFAULTCONFIG.ini'; sPath: string = ''; bHexStr: Boolean = True): Boolean;
var
  IniFile: TIniFile;
  sFilePath: string;
begin
  Result := False;
  try
    try
      if sPath = '' then
        sPath := GetAppRunPath;
      sFilePath := sPath + sFileName;
      IniFile := TIniFile.Create(sFilePath);
      if bHexStr then
        sNodeValue := StrToHexStr( sNodeValue);
      IniFile.WriteString(sCfgName, sNodeName,  sNodeValue);
      Result := True;
    finally
      IniFile.Free;
    end;
  except
    //
  end;
end;

function ReadAnyIniFile(sNodeName: string;sCfgName: string = 'DEFCFG';
  sFileName: string = 'DEFAULTCONFIG.ini'; sPath: string = ''; bHexStr: Boolean = True): string;
var
  IniFile: TIniFile;
  sFilePath: string;
begin
  Result := '';
  try
    try
      if sPath = '' then
        sPath := GetAppRunPath;
      sFilePath := sPath + sFileName;
      IniFile := TIniFile.Create(sFilePath);
      Result := IniFile.ReadString(sCfgName, sNodeName, '');
      if bHexStr then
        Result := HexStrToStr(Result);
    finally
      IniFile.Free;
    end;
  except
    //
  end;
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

function GetConnString(Server, UID, Pwd, DBName: string): string;overload;
const
  c = 'Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;'
    + 'Initial Catalog=%s;Data Source=%s';
begin
  Result := Format(c, [Pwd, UID, DBName, Server]);
end;

function TestConnString(Server, UID, Pwd, DBName: string; iTimeOut: Integer): Boolean;
var
  sConnStr: string;
  Fconn: TADOQuery;
begin
  Result := False;
  try
    Fconn := TADOQuery.Create(nil);
    try
      //sdbName := StringReplace(DBName, '''', '', [rfReplaceAll]);
      sConnStr := GetConnString(Server, UID, Pwd, 'master');
      Fconn.ConnectionString := sConnStr;
      Fconn.CommandTimeout := iTimeOut;
      Fconn.Close;
      Fconn.SQL.Text := 'select 1 from sysdatabases WHERE name = '''+DBName+'''';
      Fconn.Open;
      if Fconn.RecordCount > 0 then
        Result := True
      else
        result := False;
    except
      Result := False;
    end;
  finally
    Fconn.Free;
  end;
end;

function TestConnString(): Boolean; overload;
var
  connSet: TConnIniConfig;
begin
  Result := False;
  connSet := GetConnSetting();
  Result := TestConnString(connSet.Server, connSet.UserID, connSet.Passwd, connSet.DBName);
end;

function ExecuteSql(var Errmsg: string; Sql: string; connStr: string = '';iTimeOut: Integer = 3000): Boolean;
var
  Fconn: TADOQuery;
begin
  Errmsg := '';
  Result := False;
  if connStr = '' then
    connStr := GetConnString;
  if connStr = '' then
  begin
    Errmsg := 'û�������ַ���';
    Exit;
  end;
  try
    Fconn := TADOQuery.Create(nil);
    try
      Fconn.Close;
      Fconn.ConnectionString := connStr;
      Fconn.CommandTimeout := iTimeOut;   
      Fconn.SQL.Text := Sql;
      Fconn.ExecSQL;
      Result := True;
      Fconn.Close;
    except
      on ex: Exception do
      begin
        Fconn.Close;
        Errmsg := ex.Message;
      end;
    end;
  finally
    Fconn.Free;
  end;
end;

function GetFirstData(Sql: string; FieldName: string = ''; connStr: string = ''; iTimeOut: Integer = 3000): string;
var
  Fconn: TADOQuery;
begin
  Result := '';
  if connStr = '' then
    connStr := GetConnString;
  if connStr = '' then
  begin
    Exit;
  end;
  try
    Fconn := TADOQuery.Create(nil);
    try
      Fconn.Close;
      Fconn.ConnectionString := connStr;
      Fconn.CommandTimeout := iTimeOut;   
      Fconn.SQL.Text := Sql;
      Fconn.Open;
      if Fconn.RecordCount = 0 then
        Exit;
      Fconn.First;
      if FieldName = '' then
        Result := Fconn.Fields[0].AsString
      else
        Result := Fconn.FieldByName(FieldName).AsString;
      Fconn.Close;
    except
      on ex: Exception do
      begin
        //Result := ex.Message;
        Fconn.Close;
      end;
    end;
  finally
    Fconn.Free;
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
            //���ֽ�,���Ǻ����ֽ�
        SPBM:=SPBM+copy(sCnStr,i,1)
    else   //�Ǻ��֣���ȡ2���ֽ�ȡ��ƴ����
    begin
       hz:=copy(sCnStr,i,2);
       SPBM:=SPBM+getpy(hz);
       i:=i+1;
    end;
     i:=i+1;
  end;
  Result := SPBM;
end;

function GetMiddleStr(sStr, BeginStr, EndStr: string): string;
var
  iBegin, iEnd: Integer;
begin
  iBegin:=AnsiPos(BeginStr,sStr)+length(BeginStr);
  iEnd:=AnsiPos(EndStr,sStr);
  result:=copy(sStr,iBegin,iEnd-iBegin);
end;

//�򵥼���
function EncString(sStr: string): string;
var
  s: string;
begin
  //��ת��16����
  s := ReverseStr(sStr);
  s := StrToHexStr(s);
  Result := ReverseStr(s);
end;

//�򵥽���
function DecString(sStr: string): string;
var
  s: string;
begin
  s := ReverseStr(sStr);
  s := HexStrToStr(s);
  Result := ReverseStr(s);
end;

function GetCPUID(): string;
//const
//  CPUINFO = 'CPU������: %S   ���к�: %x';
var
  s: array[0..19] of Char;  
  MyCpuID: Integer;
begin  
  FillChar(s, 20, 0);
  asm  
     push ebx  
     push ecx  
     push edx  
     mov   eax, 0  
     cpuid  
     mov   dword   ptr   s[0],     ebx  
     mov   dword   ptr   s[4],     edx  
     mov   dword   ptr   s[8],     ecx  
     mov   eax,   1  
     cpuid  
     mov   MyCpuID,   edx  
     pop edx  
     pop ecx  
     pop ebx  
  end;  
  //Result := Format(CPUINFO, [s, MyCpuID]);
  Result := s + IntToStr(MyCpuID);
end;

function GetVolumeID(): string;
var   
  vVolumeNameBuffer:   array[0..255]of   Char;
  vVolumeSerialNumber: DWORD;   
  vMaximumComponentLength:   DWORD;   
  vFileSystemFlags:   DWORD;   
  vFileSystemNameBuffer:   array[0..255]of   Char;
begin   
  if GetVolumeInformation('C:\',   vVolumeNameBuffer,   SizeOf(vVolumeNameBuffer),
    @vVolumeSerialNumber,   vMaximumComponentLength,   vFileSystemFlags,
    vFileSystemNameBuffer,   SizeOf(vFileSystemNameBuffer)) then
  begin   
    Result := IntToHex(vVolumeSerialNumber, 8);
  end;
end;

end.
