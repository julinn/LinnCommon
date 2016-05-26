unit ulTransferThread;
//////////////////////////////////////////////////////////////////////////////// 
// 模块说明: FTP传输核心模块类 
// 功能: 指定一个下载（上传)的日期或文件名，系统执行传输功能(支持续传） 
// 备注：该模块属于传输类的一个子线程模块. 
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
  //进度显示 
  FProgressbar:TProgressbar; 
  //上传核心组件 
  FFTP:TIdFTP; 
  //上传列表内部类 
  FCombobox:TCombobox; 
  //上传信息显示 
  FLabel:TLabel; 
  //FTP地址 
  FFTP_STR_HOST:String; 
  //FTP用户名 
  FFTP_STR_USN:String; 
  //FTP用户密码 
  FFTP_STR_PWD:String; 
  //FTP端口 
  FFTP_STR_PORT:String; 
  //FTP上传标记 
  FFTP_STR_UTAG:String; 
  //FTP下载标记 
  FFTP_STR_DTAG:String; 
  //FTP指定的文件夹 
  FFTP_STR_FLODER:STring; 
  //传输文件大小 
  FFTP_LWD_BYTES:LongWord; 
  //传输开始时间 
  FFTP_DT_BEGINTIME:TDateTime; 
  //传输速度 
  FFTP_DUB_SPEED:Double; 
  //是否删除源文件. 
  FFTP_BOL_DEL:Boolean; 
  //是否正在传输文件 
  FFTP_BOL_ISTRANSFERRING:Boolean; 

  //类内部通用对话框函数 
  function MsgBox(Msg:string;iValue:integer):integer; 
  //获取用户当前的Windows临时文件夹 
  function GetWinTempPath:String; 
  //根据日期生成的日期文件名 
  function DateToFileName(DateTime:TDateTime):String; 
  //根据上传/下载标记生成完整的文件名 
  function GetFileFullName(sTag:String;DateTime:TDateTime):String; 
  protected 
  //传输核心函数 
  function TransferKernel(iTag:Integer;sFile:string;bDelSFile:boolean=False):boolean; 
  //传输组件的WorkBegin事件 
  procedure FFTPOnWorkBegin(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer); 
  //传输组件的WorkEnd事件 
  procedure FFTPOnWorkEnd(Sender: TObject; AWorkMode: TWorkMode); 
  //传输组件的Work事件 
  procedure FFTPOnWork(Sender: TObject; AWorkMode: TWorkMode;const AWorkCount: Integer); 
  public 
  //构造函数 
  constructor Create; 
  //析构函数 
  destructor Destroy; 
  //进度条控件属性 
  property Progressbar:TProgressbar read FProgressbar write FProgressbar default nil; 
  //列表控件属性 
  property Combobox:TCombobox read FCombobox write FCombobox default nil; 
  //只读的FTP核心组件 
  property FTP:TidFTP read FFTP; 
  //标签控件 
  property oLabel:TLabel read FLabel write FLabel default nil; 
  //列表方法(该方法需要指定Combobox,否则无效） 
  procedure List; 
  //依据日期下载文件 
  procedure DownLoad(dDate:TDateTime);overload; 
  //依据文件名下载文件 
  procedure DownLoad(sFileName:String);overload; 
  //依据日期上传文件 
  procedure UpLoad(dDate:TDateTime);overload; 
  //依据文件名上传文件 
  procedure UpLoad(sFileName:String);overload; 

  // procedure Execute; override;
end; 

implementation 

constructor TTransferThread.Create;
var 
  FFini:TIniFile;
  FFilePath:String;
begin 
  //完成FTP相关参数的读取. 
  FFTP_BOL_ISTRANSFERRING:=False;
  Try 
    FFilePath:=ExtractFilePath(APPlication.exeName)+'setup.ini';
    FFini:=TIniFile.Create(FFilePath); 
    FFTP_STR_HOST:=FFini.ReadString('文件传输','服务器地址',''); 
    FFTP_STR_PORT:=FFini.ReadString('文件传输','服务器端口',''); 
    FFTP_STR_USN:=FFini.ReadString('文件传输','用户名',''); 
    FFTP_STR_PWD:=FFini.ReadString('文件传输','密码',''); 
    FFTP_STR_FLODER:=FFini.ReadString('文件传输','文件夹',''); 
    FFTP_STR_UTAG:=FFini.ReadString('文件传输','上传标识码',''); 
    FFTP_STR_DTAG:=FFini.ReadString('文件传输','上传标识码',''); 
    FFTP_BOL_DEL:=FFini.ReadBool('文件传输','删源文件',FALSE); 
    FFIni.Free;
  Except 
    MsgBox('读取FTP连接配置信息失败!请检查您的Setup.ini文件.',MB_OK+MB_ICONERROR);
    Exit; 
    Abort;
  End; 
  //设置FTP相关参数 
  Try 
    FFTP:=TIdFTP.Create(nil);
    FFTP.Host:=FFTP_STR_HOST; 
    FFTP.Port:=strtoint(FFTP_STR_PORT); 
    FFTP.UserName:=FFTP_STR_USN; 
    FFTP.Password:=FFTP_STR_PWD; 
    FFTP.TransferType:=ftASCII; 
    //事件驱动 
    FFTP.OnWork:=FFTPOnWork; 
    FFTP.OnWorkBegin:=FFTPOnWorkBegin; 
    FFTP.OnWorkEnd:=FFTPOnWorkEnd; 
    FFTP.Connect(True,-1);
  Except 
    MsgBox('连接远程FTP服务器失败!'#10#13'1.服务器地址错误,或服务器不可用.'#10#13'2.用户名或密码不正确.'#10#13'3.FTP服务端口设置不正确.',MB_OK+MB_ICONERROR);
    Exit; 
    Abort;
  End;

end; 

function TTransferThread.DateToFileName(DateTime: TDateTime): String; 
var 
  Year, Month, Day:Word;
  sYear,sMonth,sDay:String;
begin 
  DecodeDate(DateTime, Year, Month, Day); //日期
  sYear:=inttostr(Year);
  sMonth:=inttostr(Month); 
  sDay:=inttostr(Day); 
  //年 
  case Length(sYear) of 
    4: sYear:=sYear;
    3: sYear:='0'+sYear; 
    2: sYear:='00'+sYear; 
    1: sYear:='000'+sYear;
  else 
    sYear:='';
  end; 
  //月 
  case Length(sMonth) of 
    2: sMonth:=sMonth;
    1: sMonth:='0'+sMonth;
  else 
    sMonth:='';
  end; 
  //日 
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
  TotalTime := Now - FFTP_DT_BEGINTIME; //总用时
  DecodeTime(TotalTime, H, M, Sec, MS); //取出时\分\秒\毫秒 
  Sec := Sec + M * 60 + H * 3600; //转换成秒 
  DLTime := Sec + MS / 1000; //最终的下载时间 
  E:= Format(' 使用时间:%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]); 
  if DLTime > 0 then
  //每秒的平均速度:XX K/s 
  FFTP_DUB_SPEED := {(AverageSpeed + }(AWorkCount / 1024) / DLTime{) / 2}; 

  if FFTP_DUB_SPEED > 0 then 
  begin 
    Sec := Trunc(((FFTP_LWD_BYTES - AWorkCount) / 1024) / FFTP_DUB_SPEED);
    S := Format(' 剩余时间:%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]); 
    S:='速度: ' + FormatFloat('0.00 KB/秒',FFTP_DUB_SPEED) + S + E ;
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
    FProgressBar.Position:=AWorkCount; //进度显示
    FProgressBar.Update;
  end;
end; 

procedure TTransferThread.FFTPOnWorkBegin(Sender: TObject; 
AWorkMode: TWorkMode; const AWorkCountMax: Integer); 
begin 
  FFTP_BOL_ISTRANSFERRING:=True; 
  FFTP_DT_BEGINTIME:=Now; //开始时间 
  FFTP_DUB_SPEED:=0.0; //初始化速率 
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
  Dir_List:=TStringList.Create; //创建字符串列表类 
  Try 
    if Not FFTP.Connected then FFTP.Connect;
    FFTP.ChangeDir('/');//根目录 //到服务器的根目录 
    FFTP.List(Dir_List,'',True); //获取目录列表 
    FoundFolder:=False; 
    FFTP.TransferType:=ftASCII; //更改传输类型(ASCII类型) 
    for iCount:=0 to Dir_List.Count-1 do 
    begin 
      if FFTP.DirectoryListing.Items[iCount].ItemType=ditDirectory then
      begin
        if Dir_List.IndexOf(FFTP_STR_FLODER)= -1 then //判断该文件夹不存在
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
      FFTP.MakeDir(FFTP_STR_FLODER); //不存在，则创建一个新的文件夹
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
  Result:=MessageBox(application.Handle,pChar(Msg),'系统信息',iValue+MB_APPLMODAL); 
end; 

function TTransferThread.TransferKernel(iTag: Integer; sFile: string; 
bDelSFile: boolean): boolean; 
var 
  sTmpPath:String; 
  Dir_List:TStringList; 
  FoundFolder:Boolean; 
  iCount:Integer;
begin 
  sTmpPath:=GetWinTempPath; //获取本地系统临时目录
  Dir_List:=TStringList.Create; //创建字符串列表类 
  Try 
    if Not FFTP.Connected then FFTP.Connect;
    FFTP.ChangeDir('/');//根目录 //到服务器的根目录 
    FFTP.TransferType:=ftASCII; //更改传输类型(ASCII类型) 
    FFTP.List(Dir_List,'',True); //获取目录列表 
    FoundFolder:=False; 
    for iCount:=0 to Dir_List.Count-1 do 
    begin 
    if FFTP.DirectoryListing.Items[iCount].ItemType=ditDirectory then //是目录 
    begin 
    if Dir_List.IndexOf(FFTP_STR_FLODER)= -1 then //判断该文件夹不存在 
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
    FFTP.MakeDir(FFTP_STR_FLODER); //不存在，则创建一个新的文件夹 
    end; 

    //更改传输类型 
    FFTP.TransferType:=ftBinary; 

    Try 
    //找到相应的目录,则更换路径. 
      FFTP.ChangeDir(FFTP_STR_FLODER);
      //0为上传 
      if iTag=0 then 
      begin 
        Try 
          FFTP.Put(sTmpPath+sFile,sFile);
        Except
          MsgBox('上传文件失败！原因如下:'#13#10'1.服务器没有开启写文件的权限!'#10#13'2.程序发生异常，请重新上传！',MB_OK+MB_ICONERROR);
          Abort;
        End;
        FFTP_LWD_BYTES:=FFTP.Size(sFile);
        if bDelSFile then //删除本地源文件
        begin
          DeleteFile(sTmpPath+sFile);
        end;
        Result:=True;
        FFTP.Disconnect;
      end; 
      //1为下载 
      if iTag=1 then 
      begin 
      //文件已经存在 
        Try 
          FFTP_LWD_BYTES:=FFTP.Size(sFile); 
          if FileExists(sTmpPath+sFile) then 
          begin 
            case MsgBox('文件已经存在，要续传吗？'#13#10'是--续传'#10#13'否--覆盖'#13#10'取消--取消操作',MB_YESNOCANCEL+MB_ICONINFORMATION) of
              IDYES: begin
                FFTP_LWD_BYTES:=FFTP_LWD_BYTES-FileSizeByName(sTmpPath+sFile);
              //参数说明: 源文件，目标文件,是否覆盖,是否触发异常（True为不触发)。
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
          else //文件不存在 
          begin 
            FFTP.Get(sFile,sTmpPath+sFile,True);
          end;
        Except 
          MsgBox('上传文件失败！原因如下:'#13#10'1.服务器没有开启写文件的权限!'#10#13'2.程序发生异常，请重新上传！',MB_OK+MB_ICONERROR);
          Abort;
        End; 
        if bDelSFile then //删除远程源文件 
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
