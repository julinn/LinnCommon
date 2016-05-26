unit FrmInputBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFmMsgInput = class(TForm)
    edtValue: TEdit;
    lblHint: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure edtValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(var sValue: string; sHint: string = ''; sCaption: string = ''): Boolean;
  end;

var
  FmMsgInput: TFmMsgInput;

implementation

{$R *.dfm}

procedure TFmMsgInput.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFmMsgInput.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFmMsgInput.edtValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    ModalResult := mrOk;
end;

class function TFmMsgInput.Execute(var sValue: string; sHint,
  sCaption: string): Boolean;
begin
  with TFmMsgInput.Create(nil) do
  begin
    try
      lblHint.Caption := sHint;
      if sCaption = '' then
        sCaption := Application.Title;
      Caption := sCaption;
      Result := False;
      ShowModal;
      //edtValue.SetFocus;
      if ModalResult = mrOk then
      begin
        sValue := edtValue.Text;
        Result := True;
      end;
    finally
      Free;
    end;
  end;
end;

end.
