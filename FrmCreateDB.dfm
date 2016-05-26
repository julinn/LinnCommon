object FmCreateDB: TFmCreateDB
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Create DataBase'
  ClientHeight = 273
  ClientWidth = 463
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
  object edt1: TEdit
    Left = 136
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edt1'
  end
  object btn1: TButton
    Left = 136
    Top = 176
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
  object edt2: TEdit
    Left = 136
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edt2'
  end
  object edt3: TEdit
    Left = 136
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'edt3'
  end
  object edt4: TEdit
    Left = 280
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'edt4'
  end
  object edt5: TEdit
    Left = 280
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'edt5'
  end
  object btn2: TButton
    Left = 280
    Top = 176
    Width = 75
    Height = 25
    Caption = 'btn2'
    TabOrder = 6
    OnClick = btn2Click
  end
end
