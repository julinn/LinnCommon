unit ulFrmMsgBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ExtCtrls, StdCtrls;

type
  TfmMsgbox = class(TForm)
    lblMsg: TLabel;
    img1: TImage;
    imgok: TImage;
    imgerror: TImage;
    tmr1: TTimer;
    procedure lblMsgClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute(sMsg: string; FIsError: Boolean = False;
      iTime: Integer = 1; bAutoClose: Boolean = True):Boolean;
  end;

var
  fmMsgbox: TfmMsgbox;

implementation

{$R *.dfm}

{ TfmMsgbox }  


class function TfmMsgbox.Execute(sMsg: string; FIsError: Boolean;
  iTime: Integer; bAutoClose: Boolean): Boolean;
begin
  Result := False;
  with TfmMsgbox.Create(nil ) do
  try
    lblMsg.Caption := '  ' + sMsg;
    lblMsg.Font.Color := clGreen;
    imgerror.Visible := False;
    if FIsError then
    begin
      lblMsg.Font.Color := clRed;
      imgok.Visible := False;
      imgerror.Visible := True;
    end;
    tmr1.Enabled := False;
    tmr1.Interval := iTime * 1000;
    tmr1.Enabled := bAutoClose;
    ShowModal;
    if ModalResult = mrOk then
      Result := True;
  finally
    Free;
  end; 
end;

procedure TfmMsgbox.FormCreate(Sender: TObject);
begin
  //
end;

procedure TfmMsgbox.lblMsgClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfmMsgbox.tmr1Timer(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
