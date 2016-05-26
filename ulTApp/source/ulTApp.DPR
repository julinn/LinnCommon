program ulTApp;

uses
  Forms,
  SDIMAIN in 'SDIMAIN.PAS' {SDIAppForm},
  uVKeyPress in '..\..\uVKeyPress.pas',
  ulSystem in '..\..\ulSystem.pas',
  ulPressKey in '..\..\ulPressKey.pas',
  ulMsgBox in '..\..\ulMsgBox.pas',
  ulFrmConnSetting in '..\..\ulFrmConnSetting.pas' {FmConnSetting},
  ulBinHexTools in '..\..\ulBinHexTools.pas',
  uHotKey in '..\..\uHotKey.pas',
  FrmInputBox in '..\..\FrmInputBox.pas' {FmMsgInput},
  FrmCreateDB in '..\..\FrmCreateDB.pas' {FmCreateDB},
  ulMac in '..\..\ulMac.pas',
  ulHelper in '..\..\ulHelper.pas',
  uMD5 in '..\..\uMD5.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSDIAppForm, SDIAppForm);
  Application.CreateForm(TFmConnSetting, FmConnSetting);
  Application.CreateForm(TFmMsgInput, FmMsgInput);
  Application.CreateForm(TFmCreateDB, FmCreateDB);
  Application.Run;
end.
 
