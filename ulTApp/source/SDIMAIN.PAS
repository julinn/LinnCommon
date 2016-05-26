unit SDIMAIN;

interface

uses Windows, Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin;

type
  TSDIAppForm = class(TForm)
    btn1: TButton;
    edt1: TEdit;
    edt2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SDIAppForm: TSDIAppForm;

implementation

uses
  ulSystem, ulMac;

{$R *.dfm}

procedure TSDIAppForm.btn1Click(Sender: TObject);
var
  d: DWORD;
begin
  //ulSystem.SaveAnyIniFile('test', edt1.Text);
  edt1.Text := ulMac._GetCPUID+'-'+ulMac._GetVolumeID;
  edt2.Text := GetMacStr;
end;

procedure TSDIAppForm.FormCreate(Sender: TObject);
begin
  //
  edt1.Text := ulMac._GetCPUID;
  edt2.Text := ulMac._GetVolumeID;
end;

end.
