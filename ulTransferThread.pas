unit ulTransferThread;
//////////////////////////////////////////////////////////////////////////////// 
// ģ��˵��: FTP�������ģ���� 
// ����: ָ��һ�����أ��ϴ�)�����ڻ��ļ�����ϵͳִ�д��书��(֧�������� 
// ��ע����ģ�����ڴ������һ�����߳�ģ��. 
//////////////////////////////////////////////////////////////////////////////// 
interface 

uses 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs,ComCtrls,StdCtrls,IniFiles,IdIntercept, IdLogBase, IdLogEvent, IdAntiFreezeBase, 
  IdAntiFreeze, IdFTPList,IdBaseComponent,IdGlobal,IdComponent, IdTCPConnection, IdTCPClient,IdFTPCommon, 
  IdFTP;

type

  TTransferThread = class(TObject)

  private
  { Private declarations }
  //������ʾ 
  FProgressbar:TProgressbar; 
  //�ϴ�������� 
  FFTP:TIdFTP; 
  //�ϴ��б��ڲ��� 
  FCombobox:TCombobox; 
  //�ϴ���Ϣ��ʾ 
  FLabel:TLabel; 
  //FTP��ַ 
  FFTP_STR_HOST:String; 
  //FTP�û��� 
  FFTP_STR_USN:String; 
  //FTP�û����� 
  FFTP_STR_PWD:String; 
  //FTP�˿� 
  FFTP_STR_PORT:String; 
  //FTP�ϴ���� 
  FFTP_STR_UTAG:String; 
  //FTP���ر�� 
  FFTP_STR_DTAG:String; 
  //FTPָ�����ļ��� 
  FFTP_STR_FLODER:STring; 
  //�����ļ���С 
  FFTP_LWD_BYTES:LongWord; 
  //���俪ʼʱ�� 
  FFTP_DT_BEGINTIME:TDateTime; 
  //�����ٶ� 
  FFTP_DUB_SPEED:Double; 
  //�Ƿ�ɾ��Դ�ļ�. 
  FFTP_BOL_DEL:Boolean; 
  //�Ƿ����ڴ����ļ� 
  FFTP_BOL_ISTRANSFERRING:Boolean; 

  //���ڲ�ͨ�öԻ����� 
  function MsgBox(Msg:string;iValue:integer):integer; 
  //��ȡ�û���ǰ��Windows��ʱ�ļ��� 
  function GetWinTempPath:String; 
  //�����������ɵ������ļ��� 
  function DateToFileName(DateTime:TDateTime):String; 
  //�����ϴ�/���ر�������������ļ��� 
  function GetFileFullName(sTag:String;DateTime:TDateTime):String; 
  protected 
  //������ĺ��� 
  function TransferKernel(iTag:Integer;sFile:string;bDelSFile:boolean=False):boolean; 
  //���������WorkBegin�¼� 
  procedure FFTPOnWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer); 
  //���������WorkEnd�¼� 
  procedure FFTPOnWorkEnd(Sender: TObject; AWorkMode: TWorkMode); 
  //���������Work�¼� 
  procedure FFTPOnWork(Sender: TObject; AWorkMode: TWorkMode;const AWorkCount: Integer); 
  public 
  //���캯�� 
  constructor Create; 
  //�������� 
  destructor Destroy; 
  //�������ؼ����� 
  property Progressbar:TProgressbar read FProgressbar write FProgressbar default nil; 
  //�б�ؼ����� 
  property Combobox:TCombobox read FCombobox write FCombobox default nil; 
  //ֻ����FTP������� 
  property FTP:TidFTP read FFTP; 
  //��ǩ�ؼ� 
  property oLabel:TLabel read FLabel write FLabel default nil; 
  //�б���(�÷�����Ҫָ��Combobox,������Ч�� 
  procedure List; 
  //�������������ļ� 
  procedure DownLoad(dDate:TDateTime);overload; 
  //�����ļ��������ļ� 
  procedure DownLoad(sFileName:String);overload; 
  //���������ϴ��ļ� 
  procedure UpLoad(dDate:TDateTime);overload; 
  //�����ļ����ϴ��ļ� 
  procedure UpLoad(sFileName:String);overload; 

  // procedure Execute; override;
end; 

implementation 

constructor TTransferThread.Create;
var 
  FFini:TIniFile;
  FFilePath:String;
begin 
  //���FTP��ز����Ķ�ȡ. 
  FFTP_BOL_ISTRANSFERRING:=False;
  Try 
    FFilePath:=ExtractFilePath(APPlication.exeName)+'setup.ini';
    FFini:=TIniFile.Create(FFilePath); 
    FFTP_STR_HOST:=FFini.ReadString('�ļ�����','��������ַ',''); 
    FFTP_STR_PORT:=FFini.ReadString('�ļ�����','�������˿�',''); 
    FFTP_STR_USN:=FFini.ReadString('�ļ�����','�û���',''); 
    FFTP_STR_PWD:=FFini.ReadString('�ļ�����','����',''); 
    FFTP_STR_FLODER:=FFini.ReadString('�ļ�����','�ļ���',''); 
    FFTP_STR_UTAG:=FFini.ReadString('�ļ�����','�ϴ���ʶ��',''); 
    FFTP_STR_DTAG:=FFini.ReadString('�ļ�����','�ϴ���ʶ��',''); 
    FFTP_BOL_DEL:=FFini.ReadBool('�ļ�����','ɾԴ�ļ�',FALSE); 
    FFIni.Free;
  Except 
    MsgBox('��ȡFTP����������Ϣʧ��!��������Setup.ini�ļ�.',MB_OK+MB_ICONERROR);
    Exit; 
    Abort;
  End; 
  //����FTP��ز��� 
  Try 
    FFTP:=TIdFTP.Create(nil);
    FFTP.Host:=FFTP_STR_HOST; 
    FFTP.Port:=strtoint(FFTP_STR_PORT); 
    FFTP.UserName:=FFTP_STR_USN; 
    FFTP.Password:=FFTP_STR_PWD; 
    FFTP.TransferType:=ftASCII; 
    //�¼����� 
    FFTP.OnWork:=FFTPOnWork; 
    FFTP.OnWorkBegin:=FFTPOnWorkBegin; 
    FFTP.OnWorkEnd:=FFTPOnWorkEnd; 
    FFTP.Connect(True,-1);
  Except 
    MsgBox('����Զ��FTP������ʧ��!'#10#13'1.��������ַ����,�������������.'#10#13'2.�û��������벻��ȷ.'#10#13'3.FTP����˿����ò���ȷ.',MB_OK+MB_ICONERROR);
    Exit; 
    Abort;
  End;

end; 

function TTransferThread.DateToFileName(DateTime: TDateTime): String; 
var 
  Year, Month, Day:Word;
  sYear,sMonth,sDay:String;
begin 
  DecodeDate(DateTime, Year, Month, Day); //����
  sYear:=inttostr(Year);
  sMonth:=inttostr(Month); 
  sDay:=inttostr(Day); 
  //�� 
  case Length(sYear) of 
    4: sYear:=sYear;
    3: sYear:='0'+sYear; 
    2: sYear:='00'+sYear; 
    1: sYear:='000'+sYear;
  else 
    sYear:='';
  end; 
  //�� 
  case Length(sMonth) of 
    2: sMonth:=sMonth;
    1: sMonth:='0'+sMonth;
  else 
    sMonth:='';
  end; 
  //�� 
  case Length(sDay) of 
    2: sDay:=sDay;
    1: sDay:='0'+sDay;
  else 
    sDay:='';
  end; 
  if (sYear='') or (sMonth='') or (sDay='') then 
  begin 
    Result:='';
    Exit;
  end; 
  if (sYear<>'') and (sMonth<>'') and (sDay<>'') then 
  begin 
    Result:=sYear+sMOnth+sDay;
  end; 
end; 

destructor TTransferThread.Destroy; 
begin 
  FProgressbar:=nil; 
  FCombobox:=nil; 
  FLabel:=nil; 
  FFTP.Quit; 
  FFTP.Free; 
end; 

procedure TTransferThread.DownLoad(dDate: TDateTime); 
begin 
  if Not FFTP_BOL_ISTRANSFERRING then 
  begin 
    TransferKernel(1,GetFileFullName(FFTP_STR_DTAG,dDate),FFTP_BOL_DEL); 
  end;
end; 

procedure TTransferThread.DownLoad(sFileName: String); 
begin 
if Not FFTP_BOL_ISTRANSFERRING then 
TransferKernel(1,sFileName,FFTP_BOL_DEL); 
end; 

procedure TTransferThread.FFTPOnWork(Sender: TObject; AWorkMode: TWorkMode; 
const AWorkCount: Integer); 
var 
  S,E: String; 
  H, M, Sec, MS: Word; 
  TotalTime: TDateTime; 
  DLTime: Double;
begin 
  TotalTime := Now - FFTP_DT_BEGINTIME; //����ʱ
  DecodeTime(TotalTime, H, M, Sec, MS); //ȡ��ʱ\��\��\���� 
  Sec := Sec + M * 60 + H * 3600; //ת������ 
  DLTime := Sec + MS / 1000; //���յ�����ʱ�� 
  E:= Format(' ʹ��ʱ��:%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]); 
  if DLTime > 0 then
  //ÿ���ƽ���ٶ�:XX K/s 
  FFTP_DUB_SPEED := {(AverageSpeed + }(AWorkCount / 1024) / DLTime{) / 2}; 

  if FFTP_DUB_SPEED > 0 then 
  begin 
    Sec := Trunc(((FFTP_LWD_BYTES - AWorkCount) / 1024) / FFTP_DUB_SPEED);
    S := Format(' ʣ��ʱ��:%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]); 
    S:='�ٶ�: ' + FormatFloat('0.00 KB/��',FFTP_DUB_SPEED) + S + E ;
  end 
  else 
  S:=''; 
  if (FLabel<>nil) and (assigned(FLabel)) then 
  begin 
    FLabel.AutoSize:=True;
    FLabel.Caption:=S; 
    FLabel.Update;
  end; 
  if (FProgressBar<>nil) and (assigned(FProgressBar)) then 
  begin 
    FProgressBar.Position:=AWorkCount; //������ʾ
    FProgressBar.Update;
  end;
end; 

procedure TTransferThread.FFTPOnWorkBegin(Sender: TObject; 
AWorkMode: TWorkMode; const AWorkCountMax: Integer); 
begin 
  FFTP_BOL_ISTRANSFERRING:=True; 
  FFTP_DT_BEGINTIME:=Now; //��ʼʱ�� 
  FFTP_DUB_SPEED:=0.0; //��ʼ������ 
  if (FProgressBar<>nil) and (assigned(FProgressBar)) then 
  begin
    if AWorkCountMax>0 then
    begin 
      FProgressBar.Max:=AWorkCountMax;
      FFTP_LWD_BYTES:=FProgressBar.Max;
    end
    else
      FProgressBar.Max:=FFTP_LWD_BYTES;
  end;
end; 

procedure TTransferThread.FFTPOnWorkEnd(Sender: TObject; 
AWorkMode: TWorkMode); 
begin 
  FFTP_BOL_ISTRANSFERRING:=False; 
  FFTP_DUB_SPEED:=0.00; 
  if (FLabel<>nil) and (assigned(FLabel)) then 
  begin 
    FLabel.AutoSize:=True;
    FLabel.Caption:=''; 
    FLabel.Update;
  end; 

  if (FProgressBar<>nil) and (assigned(FProgressBar)) then 
  begin 
    FProgressBar.Position:=0; 
  end;
end; 

function TTransferThread.GetFileFullName(sTag:String;DateTime:TDateTime):String; 
begin 
  Result:=sTag+DateToFileName(DateTime)+'FD.HXD'; 
end; 

function TTransferThread.GetWinTempPath: String; 
var 
  TempDir:array [0..255] of char;
begin 
  GetTempPath(255,@TempDir);
  Result:=strPas(TempDir); 
end; 

procedure TTransferThread.List; 
var 
  Dir_List:TStringList; 
  FoundFolder:Boolean; 
  iCount:Integer; 
begin 
  if (FCombobox=nil) or (Not Assigned(FCombobox)) then 
  begin 
    Exit;
    Abort;
  end; 
  Dir_List:=TStringList.Create; //�����ַ����б��� 
  Try 
    if Not FFTP.Connected then FFTP.Connect;
    FFTP.ChangeDir('/');//��Ŀ¼ //���������ĸ�Ŀ¼ 
    FFTP.List(Dir_List,'',True); //��ȡĿ¼�б� 
    FoundFolder:=False; 
    FFTP.TransferType:=ftASCII; //���Ĵ�������(ASCII����) 
    for iCount:=0 to Dir_List.Count-1 do 
    begin 
      if FFTP.DirectoryListing.Items[iCount].ItemType=ditDirectory then
      begin
        if Dir_List.IndexOf(FFTP_STR_FLODER)= -1 then //�жϸ��ļ��в�����
        begin
        //����������ѭ������.
          Continue;
        end
        else
        begin
        //�������,��ֱ���˳�ѭ��
          FoundFolder:=True;
          Break;
        end;
      end;
    end; 

    if FoundFolder then //�жϸ��ļ��в����� 
    begin 
      FFTP.MakeDir(FFTP_STR_FLODER); //�����ڣ��򴴽�һ���µ��ļ���
    end; 

    FFTP.ChangeDir(FFTP_STR_FLODER); 
    FFTP.List(Dir_List,'*.HXD',False); 
    if Dir_List.Count>0 then 
    begin 
      FCombobox.Items:=Dir_List; 
    end;
  Finally 
  Dir_List.Free; 
  End;
end; 

function TTransferThread.MsgBox(Msg: string; iValue: integer): integer; 
begin 
  Result:=MessageBox(application.Handle,pChar(Msg),'ϵͳ��Ϣ',iValue+MB_APPLMODAL); 
end; 

function TTransferThread.TransferKernel(iTag: Integer; sFile: string; 
bDelSFile: boolean): boolean; 
var 
  sTmpPath:String; 
  Dir_List:TStringList; 
  FoundFolder:Boolean; 
  iCount:Integer;
begin 
  sTmpPath:=GetWinTempPath; //��ȡ����ϵͳ��ʱĿ¼
  Dir_List:=TStringList.Create; //�����ַ����б��� 
  Try 
    if Not FFTP.Connected then FFTP.Connect;
    FFTP.ChangeDir('/');//��Ŀ¼ //���������ĸ�Ŀ¼ 
    FFTP.TransferType:=ftASCII; //���Ĵ�������(ASCII����) 
    FFTP.List(Dir_List,'',True); //��ȡĿ¼�б� 
    FoundFolder:=False; 
    for iCount:=0 to Dir_List.Count-1 do 
    begin 
    if FFTP.DirectoryListing.Items[iCount].ItemType=ditDirectory then //��Ŀ¼ 
    begin 
    if Dir_List.IndexOf(FFTP_STR_FLODER)= -1 then //�жϸ��ļ��в����� 
    begin 
    //����������ѭ������. 
    Continue; 
    end 
    else 
    begin 
    //�������,��ֱ���˳�ѭ�� 
    FoundFolder:=True; 
    Break; 
    end;
    end;
    end;

    if FoundFolder then //�жϸ��ļ��в�����
    begin 
    FFTP.MakeDir(FFTP_STR_FLODER); //�����ڣ��򴴽�һ���µ��ļ��� 
    end; 

    //���Ĵ������� 
    FFTP.TransferType:=ftBinary; 

    Try 
    //�ҵ���Ӧ��Ŀ¼,�����·��. 
      FFTP.ChangeDir(FFTP_STR_FLODER);
      //0Ϊ�ϴ� 
      if iTag=0 then 
      begin 
        Try 
          FFTP.Put(sTmpPath+sFile,sFile);
        Except
          MsgBox('�ϴ��ļ�ʧ�ܣ�ԭ������:'#13#10'1.������û�п���д�ļ���Ȩ��!'#10#13'2.�������쳣���������ϴ���',MB_OK+MB_ICONERROR);
          Abort;
        End;
        FFTP_LWD_BYTES:=FFTP.Size(sFile);
        if bDelSFile then //ɾ������Դ�ļ�
        begin
          DeleteFile(sTmpPath+sFile);
        end;
        Result:=True;
        FFTP.Disconnect;
      end; 
      //1Ϊ���� 
      if iTag=1 then 
      begin 
      //�ļ��Ѿ����� 
        Try 
          FFTP_LWD_BYTES:=FFTP.Size(sFile); 
          if FileExists(sTmpPath+sFile) then 
          begin 
            case MsgBox('�ļ��Ѿ����ڣ�Ҫ������'#13#10'��--����'#10#13'��--����'#13#10'ȡ��--ȡ������',MB_YESNOCANCEL+MB_ICONINFORMATION) of
              IDYES: begin
                FFTP_LWD_BYTES:=FFTP_LWD_BYTES-FileSizeByName(sTmpPath+sFile);
              //����˵��: Դ�ļ���Ŀ���ļ�,�Ƿ񸲸�,�Ƿ񴥷��쳣��TrueΪ������)��
                FFTP.Get(sFile,sTmpPath+sFile,False,True);
              end;
              IDNO: begin
                FFTP.Get(sFile,sTmpPath+sFile,True);
              end;
              IDCANCEL:
              begin
                FFTP_BOL_ISTRANSFERRING:=False;
              end;
            end;
          end 
          else //�ļ������� 
          begin 
            FFTP.Get(sFile,sTmpPath+sFile,True);
          end;
        Except 
          MsgBox('�ϴ��ļ�ʧ�ܣ�ԭ������:'#13#10'1.������û�п���д�ļ���Ȩ��!'#10#13'2.�������쳣���������ϴ���',MB_OK+MB_ICONERROR);
          Abort;
        End; 
        if bDelSFile then //ɾ��Զ��Դ�ļ� 
        begin 
          FFTP.Delete(sFile);
        end; 
        FFTP.Disconnect;
      end;
    Except 
      FFTP.Quit;
      Result:=False;
    End;
  Finally 
    Dir_List.Free;
  End;
end;

procedure TTransferThread.UpLoad(dDate: TDateTime); 
begin 
  if Not FFTP_BOL_ISTRANSFERRING then
    TransferKernel(0,GetFileFullName(FFTP_STR_DTAG,dDate),FFTP_BOL_DEL);
end; 

procedure TTransferThread.UpLoad(sFileName: String); 
begin 
  if Not FFTP_BOL_ISTRANSFERRING then
    TransferKernel(0,sFileName,FFTP_BOL_DEL);
end;

end.
