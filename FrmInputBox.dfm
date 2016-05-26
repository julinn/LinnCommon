object FmMsgInput: TFmMsgInput
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'FmMsgInput'
  ClientHeight = 80
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblHint: TLabel
    Left = 8
    Top = 8
    Width = 312
    Height = 13
    AutoSize = False
  end
  object edtValue: TEdit
    Left = 8
    Top = 27
    Width = 312
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    OnKeyDown = edtValueKeyDown
  end
  object btnOk: TButton
    Left = 164
    Top = 52
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 245
    Top = 52
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
