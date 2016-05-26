unit ulFrmConnSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls
  // ----------
  , ADODB, ulSystem, ulMsgBox;

type
  TFmConnSetting = class(TForm)
    lbl1: TLabel;
    edtIP: TEdit;
    btnTest: TButton;
    edtUser: TEdit;
    edtPwd: TEdit;
    edtDbName: TEdit;
    btnSave: TButton;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FConnSett: TConnIniConfig;
    Fconn: TADOQuery;
    procedure ReadConnSetting;
    procedure SaveConnSetting;
    function TestConnection: Boolean;
  public
    { Public declarations }
    class function Execute(): Boolean;
  end;

var
  FmConnSetting: TFmConnSetting;

implementation

{$R *.dfm}

class function TFmConnSetting.Execute: Boolean;
begin
  Result := False;
  with TFmConnSetting.Create(nil) do
  try
    ReadConnSetting;
    ShowModal;
    if ModalResult = mrOk then
      Result := True;
  finally
    Free;
  end;
end;

procedure TFmConnSetting.FormCreate(Sender: TObject);
begin
  //
  ReadConnSetting;
end;

procedure TFmConnSetting.btnSaveClick(Sender: TObject);
begin
  SaveConnSetting;
end;

procedure TFmConnSetting.btnTestClick(Sender: TObject);
begin
  if ulSystem.TestConnString(edtIP.Text, edtUser.Text, edtPwd.Text, edtDbName.Text) then
  begin
    MsgBox('连接成功！');
  end else
  begin
    MsgBox('连接失败！');
  end;
end;

procedure TFmConnSetting.ReadConnSetting;
begin
  try
    FConnSett := ulSystem.GetConnSetting;
    edtIP.Text := FConnSett.Server;
    edtUser.Text := FConnSett.UserID;
    edtPwd.Text := FConnSett.Passwd;
    edtDbName.Text := FConnSett.DBName;
  except
    edtIP.Text := '';
    edtUser.Text := '';
    edtPwd.Text := '';
    edtDbName.Text := '';
  end;
end;

procedure TFmConnSetting.SaveConnSetting;
begin
  if ulSystem.TestConnString(edtIP.Text, edtUser.Text, edtPwd.Text, edtDbName.Text) then
  begin
    if ulSystem.SaveConnSetting(edtIP.Text, edtUser.Text, edtPwd.Text, edtDbName.Text) then
    begin
      MsgBox('保存成功！');
      ModalResult := mrOk;
    end;
  end
  else
    MsgBox('连接失败！');
end;

function TFmConnSetting.TestConnection: Boolean;
var
  sConnStr, sdbName: string;
begin
  Result := False;
  try
    sdbName := StringReplace(edtDbName.Text, '''', '', [rfReplaceAll]);
    sConnStr := GetConnString(edtIP.Text, edtUser.Text, edtPwd.Text, 'master');
    Fconn.ConnectionString := sConnStr;
    Fconn.CommandTimeout := 3000;
    Fconn.Close;
    Fconn.SQL.Text := 'select 1 from sysdatabases WHERE name = '''+sdbName+'''';
    Fconn.Open;
    if Fconn.RecordCount > 0 then
      Result := True
    else
      result := False;
  except
    Result := False;
  end;
end;

end.
