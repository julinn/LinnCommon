unit ulDoFtp;

interface

uses 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs,ComCtrls,StdCtrls,IniFiles,IdIntercept, IdLogBase, IdLogEvent, IdAntiFreezeBase, 
  IdAntiFreeze, IdFTPList,IdBaseComponent,IdGlobal,IdComponent, IdTCPConnection, IdTCPClient,IdFTPCommon, 
  IdFTP,
  //
  ulSystem, ulMsgBox;

type
  TDoFtp = class(TObject)

  private
    //�ϴ�������� 
    FFTP:TIdFTP; 
    //FTP��ַ 
    FHost:String;
    //FTP�û��� 
    FUser:String;
    //FTP�û����� 
    FPwd:String;
    //FTP�˿� 
    FPort:String;
    //�����ϴ�
    FUploading: Boolean;
    //��������
    FDownloading: Boolean;
  public
    constructor Create; 
    //��������
    destructor Destroy;
    //�����ļ��������ļ� 
    function DownLoad(sFileName:String; tempFileDir: string = ''): Boolean;
    function ReadFile(sFileName:String; var FileStream: TFileStream): Boolean;

    //�ϴ��ļ�
    function UpLoad(sFileName: string; SaveName:string; sSaveDir: string = ''; bDelLocalFile: Boolean = False): Boolean;

    function DelFile(sDelName: string): Boolean;
  end;

var
  DoFtp: TDoFtp;

implementation

{ TDoFtp }

constructor TDoFtp.Create;
begin
  FUploading := False;
  FDownloading := False;
  //��ȡ����
  FHost := ulSystem.ReadAnyIniFile('HOST', 'FTP');
  FUser := ulSystem.ReadAnyIniFile('USER', 'FTP');
  FPwd := ulSystem.ReadAnyIniFile('PWD', 'FTP');
  FPort := ulSystem.ReadAnyIniFile('PORT', 'FTP');
  //����FTP��ز��� 
  Try
    FFTP:=TIdFTP.Create(nil);
    FFTP.Host:=FHost;
    FFTP.Port:=strtoint(FPort);
    FFTP.UserName:=FUser;
    FFTP.Password:=FPwd;
    FFTP.TransferType:=ftASCII;
    FFTP.Connect;
  Except
    MsgBox('����Զ��FTP������ʧ��!'#10#13'1.��������ַ����,�������������.'#10#13'2.�û��������벻��ȷ.'#10#13'3.FTP����˿����ò���ȷ.');
    Exit;
    Abort;
  End;
end;

function TDoFtp.DelFile(sDelName: string): Boolean;
begin
  Result := False;
  try
    if Not FFTP.Connected then FFTP.Connect;
    FFTP.Delete(sDelName);
    Result := True;
  except
    on e: Exception do
    begin
      MsgBox(e.Message);
      Result := False;
    end;
  end;
end;

destructor TDoFtp.Destroy;
begin
  FFTP.Quit; 
  FFTP.Free; 
end;

function TDoFtp.DownLoad(sFileName, tempFileDir: string): Boolean;
begin
  Result := False;
  try
    FDownloading := True;
    if Not FFTP.Connected then FFTP.Connect;
    if tempFileDir = '' then
      tempFileDir := GetAppRunPath + 'TempFile\';
    ulSystem.CheckFilePath(tempFileDir);
    FFTP.Get(sFileName, tempFileDir + sFileName, True);
    FDownloading := False;
    Result := True;
  except
    Result := False;
  end;
end;

function TDoFtp.ReadFile(sFileName: String;
  var FileStream: TFileStream): Boolean;
begin
  Result := False;
  try
    FFTP.Get(sFileName, FileStream);
  except
    //
  end;
end;

function TDoFtp.UpLoad(sFileName, SaveName, sSaveDir: string; bDelLocalFile: Boolean): Boolean;
var
  Dir_List:TStringList;
  FoundFolder:Boolean;
  iCount:Integer;
begin
  Result := False;
  FUploading := True;
  Dir_List:=TStringList.Create; //�����ַ����б���
  try
    try
      if Not FFTP.Connected then FFTP.Connect;
      FFTP.ChangeDir('/');//��Ŀ¼ //���������ĸ�Ŀ¼
      FFTP.TransferType:=ftASCII; //���Ĵ�������(ASCII����) 
      FFTP.List(Dir_List,'',True); //��ȡĿ¼�б� 
      FoundFolder:=False;
      if sSaveDir <> '' then
      begin
        for iCount:=0 to Dir_List.Count-1 do
        begin 
          if FFTP.DirectoryListing.Items[iCount].ItemType=ditDirectory then //��Ŀ¼
          begin
            if Dir_List.IndexOf(sSaveDir)= -1 then //�жϸ��ļ��в�����
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
          FFTP.MakeDir(sSaveDir); //�����ڣ��򴴽�һ���µ��ļ���
        end;
        //�ҵ���Ӧ��Ŀ¼,�����·��.
        FFTP.ChangeDir(sSaveDir);
      end;
      //���Ĵ�������
      FFTP.TransferType:=ftBinary;
      Try
        FFTP.Put(sFileName,SaveName);
      Except
        MsgBox('�ϴ��ļ�ʧ�ܣ�ԭ������:'#13#10'1.������û�п���д�ļ���Ȩ��!'#10#13'2.�������쳣���������ϴ���');
        Abort;
      End;
      //FFTP_LWD_BYTES:=FFTP.Size(SaveName);
      if bDelLocalFile then //ɾ������Դ�ļ�
      begin
        DeleteFile(sFileName);
      end;
      Result:=True;
      //FFTP.Disconnect;  
    except
      FFTP.Quit;
      Result:=False;
    end;
  finally
    FUploading := False;
    Dir_List.Free;
  end;
end;


end.
