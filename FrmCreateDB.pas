unit FrmCreateDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFmCreateDB = class(TForm)
    edt1: TEdit;
    btn1: TButton;
    edt2: TEdit;
    edt3: TEdit;
    edt4: TEdit;
    edt5: TEdit;
    btn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(): Integer;
  end;

var
  FmCreateDB: TFmCreateDB;

implementation

{$R *.dfm}

uses
  ulHelper;

procedure TFmCreateDB.btn1Click(Sender: TObject);
begin
  edt2.Text := SimpleEncStr(edt1.Text);
  edt3.Text := EncStr(edt1.Text);
end;

procedure TFmCreateDB.btn2Click(Sender: TObject);
begin
  edt4.Text := SimpleDesStr(edt2.Text);
  edt5.Text := DesStr(edt3.Text);
end;

class function TFmCreateDB.Execute: Integer;
begin
  with TFmCreateDB.Create(nil) do
  begin
    try
      Result := ShowModal;
      if ModalResult = mrOk then 
      begin
        //
      end;
    finally

    end;
  end;
end;

procedure TFmCreateDB.FormCreate(Sender: TObject);
begin
  //
end;

end.
