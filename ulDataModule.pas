unit ulDataModule;

interface

uses
   Windows, SysUtils, Classes, DB, ADODB, kbmMemTable, cxStyles,
   //
   ulSystem, ulMsgBox;

type
  TLinkData = class(TDataModule)
    queCommand: TADOQuery;
    ADOConnection1: TADOConnection;
    cxstylrpstry1: TcxStyleRepository;
    cxstyl1: TcxStyle;
    kbmMemTable1: TkbmMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
    function GetConnString: string;
  public
    { Public declarations }
    property Connected: Boolean read FConnected write SetConnected;
  public
    {创建查询对象}
    function CreateAsQuery(const ParamCheck: Boolean = True): TADOQuery; //创建ado Query
    {}
    function Execute(AText: String): Integer;
    function GetDataSet(kbmMemTable: TkbmMemTable; ASql: String): Boolean;
  end;

var
  LinkData: TLinkData;

implementation

{$R *.dfm}

{ TDataModule1 }

procedure TLinkData.DataModuleCreate(Sender: TObject);
begin
  Connected := True;
end;

function TLinkData.Execute(AText: String): Integer;
begin
  try
    with queCommand do
    begin
      Close;
      SQL.Clear;
      SQL.Text := AText;
      Result := ExecSQL;
    end;
  except
    raise;
  end;
end;

procedure TLinkData.SetConnected(const Value: Boolean);
begin
  if Value then
    ADOConnection1.ConnectionString := GetConnString;
  if FConnected <> Value then
  begin
    try
      ADOConnection1.Connected := Value;
    except
    end;
    FConnected := ADOConnection1.Connected;
  end;
end;

function TLinkData.GetConnString: string;
begin
  Result := ulSystem.GetConnString;
end;

function TLinkData.GetDataSet(kbmMemTable: TkbmMemTable;
  ASql: String): Boolean;
begin
  Result := False;
  try
    queCommand.Close;
    queCommand.SQL.Clear;
    queCommand.SQL.Text := ASql;
    queCommand.Open;
    try
      kbmMemTable.EmptyTable;
      kbmMemTable.LoadFromDataSet(queCommand, [mtcpoStructure, mtcpoIgnoreErrors]);
    finally
      queCommand.Close;
    end;
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      MsgBox(E.Message); 
    end;
  end;
end;

function TLinkData.CreateAsQuery(const ParamCheck: Boolean): TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.ParamCheck := ParamCheck;
  Result.Connection := ADOConnection1;
  Result.CommandTimeout := ADOConnection1.CommandTimeout;
end;

end.
