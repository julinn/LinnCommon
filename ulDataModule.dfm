object LinkData: TLinkData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 129
  Width = 215
  object queCommand: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 30
    Top = 55
  end
  object ADOConnection1: TADOConnection
    KeepConnection = False
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 30
    Top = 8
  end
  object cxstylrpstry1: TcxStyleRepository
    Left = 128
    Top = 56
    PixelsPerInch = 96
    object cxstyl1: TcxStyle
      AssignedValues = [svFont, svTextColor]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = clRed
    end
  end
  object kbmMemTable1: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 128
    Top = 8
  end
end
