object SDIAppForm: TSDIAppForm
  Left = 197
  Top = 111
  Caption = 'SDI Application'
  ClientHeight = 337
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object btn1: TButton
    Left = 376
    Top = 100
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 0
    OnClick = btn1Click
  end
  object edt1: TEdit
    Left = 4
    Top = 40
    Width = 468
    Height = 24
    TabOrder = 1
    Text = 'edt1'
  end
  object edt2: TEdit
    Left = 4
    Top = 70
    Width = 468
    Height = 24
    TabOrder = 2
    Text = 'edt2'
  end
end
