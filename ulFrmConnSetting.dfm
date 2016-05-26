object FmConnSetting: TFmConnSetting
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #36830#25509#37197#32622
  ClientHeight = 180
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 67
    Top = 24
    Width = 36
    Height = 13
    Caption = #26381#21153#22120
  end
  object lbl2: TLabel
    Left = 67
    Top = 48
    Width = 36
    Height = 13
    Caption = #29992'    '#25143
  end
  object lbl3: TLabel
    Left = 67
    Top = 71
    Width = 36
    Height = 13
    Caption = #23494'    '#30721
  end
  object lbl4: TLabel
    Left = 67
    Top = 95
    Width = 36
    Height = 13
    Caption = #25968#25454#24211
  end
  object edtIP: TEdit
    Left = 107
    Top = 20
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object btnTest: TButton
    Left = 67
    Top = 134
    Width = 75
    Height = 25
    Caption = #27979#35797#36830#25509
    TabOrder = 4
    OnClick = btnTestClick
  end
  object edtUser: TEdit
    Left = 107
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object edtPwd: TEdit
    Left = 107
    Top = 67
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtDbName: TEdit
    Left = 107
    Top = 91
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object btnSave: TButton
    Left = 153
    Top = 134
    Width = 75
    Height = 25
    Caption = #20445#23384#37197#32622
    TabOrder = 5
    OnClick = btnSaveClick
  end
end
