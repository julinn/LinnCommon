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
    //上传核心组件 
    FFTP:TIdFTP; 
    //FTP地址 
    FHost:String;
    //FTP用户名 
    FUser:String;
    //FTP用户密码 
    FPwd:String;
    //FTP端口 
    FPort:String;
    //正在上传
    FUploading: Boolean;
    //正在下载
    FDownloading: Boolean;
  public
    constructor Create; 
    //析构函数
    destructor Destroy;
    //依据文件名下载文件 
    function DownLoad(sFileName:String; tempFileDir: string = ''): Boolean;
    function ReadFile(sFileName:String; var FileStream: TFileStream): Boolean;

    //上传文件
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
  //读取配置
  FHost := ulSystem.ReadAnyIniFile('HOST', 'FTP');
  FUser := ulSystem.ReadAnyIniFile('USER', 'FTP');
  FPwd := ulSystem.ReadAnyIniFile('PWD', 'FTP');
  FPort := ulSystem.ReadAnyIniFile('PORT', 'FTP');
  //设置FTP相关参数 
  Try
    FFTP:=TIdFTP.Create(nil);
    FFTP.Host:=FHost;
    FFTP.Port:=strtoint(FPort);
    FFTP.UserName:=FUser;
    FFTP.Password:=FPwd;
    FFTP.TransferType:=ftASCII;
    FFTP.Connect;
  Except
    MsgBox('连接远程FTP服务器失败!'#10#13'1.服务器地址错误,或服务器不可用.'#10#13'2.用户名或密码不正确.'#10#13'3.FTP服务端口设置不正确.');
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
  Dir_List:=TStringList.Create; //创建字符串列表类
  try
    try
      if Not FFTP.Connected then FFTP.Connect;
      FFTP.ChangeDir('/');//根目录 //到服务器的根目录
      FFTP.TransferType:=ftASCII; //更改传输类型(ASCII类型) 
      FFTP.List(Dir_List,'',True); //获取目录列表 
      FoundFolder:=False;
      if sSaveDir <> '' then
      begin
        for iCount:=0 to Dir_List.Count-1 do
        begin 
          if FFTP.DirectoryListing.Items[iCount].ItemType=ditDirectory then //是目录
          begin
            if Dir_List.IndexOf(sSaveDir)= -1 then //判断该文件夹不存在
            begin
              //如果不存继续循环查找. 
              Continue;
            end 
            else 
            begin 
              //如果存在,则直接退出循环
              FoundFolder:=True;
              Break;
            end;
          end;
        end;
        if FoundFolder then //判断该文件夹不存在 
        begin
          FFTP.MakeDir(sSaveDir); //不存在，则创建一个新的文件夹
        end;
        //找到相应的目录,则更换路径.
        FFTP.ChangeDir(sSaveDir);
      end;
      //更改传输类型
      FFTP.TransferType:=ftBinary;
      Try
        FFTP.Put(sFileName,SaveName);
      Except
        MsgBox('上传文件失败！原因如下:'#13#10'1.服务器没有开启写文件的权限!'#10#13'2.程序发生异常，请重新上传！');
        Abort;
      End;
      //FFTP_LWD_BYTES:=FFTP.Size(SaveName);
      if bDelLocalFile then //删除本地源文件
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
