object fmMsgbox: TfmMsgbox
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 32
  ClientWidth = 351
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
  object lblMsg: TLabel
    Left = 96
    Top = 0
    Width = 255
    Height = 32
    Align = alClient
    Caption = 'lblMsg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    OnClick = lblMsgClick
    ExplicitLeft = 112
    ExplicitWidth = 45
    ExplicitHeight = 19
  end
  object img1: TImage
    Left = 0
    Top = 0
    Width = 32
    Height = 32
    Align = alLeft
    Transparent = True
    OnClick = lblMsgClick
  end
  object imgok: TImage
    Left = 32
    Top = 0
    Width = 32
    Height = 32
    Align = alLeft
    Picture.Data = {
      055449636F6E0000010001002020000001002000A81000001600000028000000
      2000000040000000010020000000000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000ACACAC04ACACAC3AACACAC62
      ACACAC7EACACAC7EACACAC62ACACAC3AACACAC04000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000ACACAC38BDBDBDA1D2D2D2EDE8E8E8FFF5F5F5FF
      FFFFFFFFFFFFFFFFF5F5F5FFE8E8E8FFD2D2D2EDBDBDBDA1ACACAC3800000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000ACACAC16BBBBBBABE6E6E6FFFAFAFAFFDDDDDDFFA7CEC2FF7CC6AFFF
      5DC1A2FF5DC1A2FF7CC6AFFFA7CEC2FFDDDDDDFFFAFAFAFFE6E6E6FFBBBBBBAB
      ACACAC1600000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      ACACAC32D5D5D5E5F7F7F7FFD1DAD7FF66C7A9FF21D29CFF0FD89AFF0FD89AFF
      0FD89AFF0FD89AFF0FD89AFF0FD89AFF21D29CFF66C7A9FFD1DAD7FFF7F7F7FF
      D5D5D5E5ACACAC34000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000ACACAC34
      D6D6D6F1F5F5F5FF97C3B6FF21D39DFF0FD99BFF0FD99BFF0FD99BFF0FD99BFF
      0FD99BFF0FD99BFF0FD99BFF0FD99BFF0FD99BFF0FD99BFF21D39DFF97C3B6FF
      F5F5F5FFD6D6D6F1ACACAC340000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000ACACAC16D4D4D4E5
      F4F4F4FF80C4B0FF14D89EFF10DA9DFF10DA9DFF10DA9DFF10DA9DFF10DA9DFF
      10DA9DFF10DA9DFF10DA9DFF10DA9DFF10DA9DFF10DA9DFF10DA9DFF14D89EFF
      80C4B0FFF4F4F4FFD4D4D4E5ACACAC1600000000000000000000000000000000
      000000000000000000000000000000000000000000000000BBBBBBA9F6F6F6FF
      92C4B5FF13DA9EFF10DB9EFF10DB9EFF10DB9EFF10DB9EFF1CD79FFF37CFA1FF
      10DB9EFF10DB9EFF10DB9EFF10DB9EFF10DB9EFF10DB9EFF10DB9EFF10DB9EFF
      13DA9EFF92C4B5FFF6F6F6FFBBBBBBA900000000000000000000000000000000
      0000000000000000000000000000000000000000ACACAC36E5E5E5FFD0DAD7FF
      22D7A1FF11DCA0FF11DCA0FF11DCA0FF11DCA0FF1DD8A1FFA0C4B9FFDBDDDCFF
      4ACAA4FF11DCA0FF11DCA0FF11DCA0FF11DCA0FF11DCA0FF11DCA0FF11DCA0FF
      11DCA0FF22D7A1FFD1DAD7FFE6E6E6FFACACAC36000000000000000000000000
      0000000000000000000000000000000000000000BBBBBBA7FAFAFAFF68C9ADFF
      11DDA2FF11DDA2FF11DDA2FF11DDA2FF1ED9A3FFA0C4B9FFF6F6F6FFF5F5F5FF
      DBDDDCFF4ACBA6FF11DDA2FF11DDA2FF11DDA2FF11DDA2FF11DDA2FF11DDA2FF
      11DDA2FF11DDA2FF69C9ADFFFAFAFAFFBBBBBBA7000000000000000000000000
      00000000000000000000000000000000ACACAC08D6D6D6F5DBDDDDFF24D9A5FF
      12DFA4FF12DFA4FF12DFA4FF1EDAA5FFA0C4BAFFF6F6F6FFF1F1F1FFF1F1F1FF
      F4F4F4FFDBDDDCFF4BCCA7FF12DFA4FF12DFA4FF12DFA4FF12DFA4FF12DFA4FF
      12DFA4FF12DFA4FF24D9A5FFDBDDDDFFD6D6D6F5ACACAC080000000000000000
      00000000000000000000000000000000ACACAC3CE9E9E9FFA9CFC5FF13E0A6FF
      13E0A6FF13E0A6FF1FDCA7FFA0C4BAFFF5F5F5FFEFEFEFFFEFEFEFFFEFEFEFFF
      EFEFEFFFF3F3F3FFDBDDDCFF4CCDA8FF13E0A6FF13E0A6FF13E0A6FF13E0A6FF
      13E0A6FF13E0A6FF13E0A6FFA9CFC5FFE9E9E9FFACACAC3E0000000000000000
      00000000000000000000000000000000ACACAC68F7F7F7FF7BCAB4FF13E1A8FF
      13E1A8FF20DDA8FFA0C5BAFFF5F5F5FFEEEEEEFFEFEFEFFFF5F5F5FFEAEAEAFF
      F2F2F2FFEEEEEEFFF2F2F2FFDBDDDCFF4CCDA9FF13E1A8FF13E1A8FF13E1A8FF
      13E1A8FF13E1A8FF13E1A8FF7BCAB4FFF7F7F7FFACACAC680000000000000000
      00000000000000000000000000000000ACACAC7CFDFDFDFF65C8ADFF14E3ABFF
      14E3ABFF95C7B9FFF5F5F5FFEDEDEDFFEEEEEEFFF1F1F1FF8CC6B7FF48D0ABFF
      D6DAD9FFF2F2F2FFEDEDEDFFF1F1F1FFDBDDDCFF4CCEABFF14E3ABFF14E3ABFF
      14E3ABFF14E3ABFF14E3ABFF65C8ADFFFDFDFDFFACACAC780000000000000000
      00000000000000000000000000000000ACACAC7CFEFEFEFF89D5C1FF4BEAC0FF
      4BEAC0FF6BD5B9FFDBDDDDFFF1F1F1FFF1F1F1FF99C9BCFF4DE9C0FF4BEAC0FF
      67D8BAFFD6DBD9FFF0F0F0FFECECECFFF0F0F0FFDBDDDDFF6BD4B8FF4BEAC0FF
      4BEAC0FF4BEAC0FF4BEAC0FF89D5C1FFFEFEFEFFACACAC7C0000000000000000
      00000000000000000000000000000000ACACAC64F7F7F7FF9AD7C8FF4BECC2FF
      4BECC2FF4BECC2FF6BD6BAFFD8DAD9FF99CABDFF4DEAC1FF4BECC2FF4BECC2FF
      4BECC2FF67D9BBFFD6DBD9FFF0F0F0FFEBEBEBFFF0F0F0FFDBDDDDFF6BD5BAFF
      4BECC2FF4BECC2FF4BECC2FF9AD7C8FFF7F7F7FFACACAC640000000000000000
      00000000000000000000000000000000ACACAC3CEBEBEBFFBEDBD4FF4CEDC3FF
      4CEDC3FF4CEDC3FF4CEDC3FF5CE1BFFF4EEBC2FF4CEDC3FF4CEDC3FF4CEDC3FF
      4CEDC3FF4CEDC3FF67DABCFFD6DBD9FFEFEFEFFFE9E9E9FFEEEEEEFFDBDDDDFF
      6BD6BBFF4CEDC3FF4CEDC3FFBEDBD4FFEBEBEBFFACACAC3C0000000000000000
      00000000000000000000000000000000ACACAC08D7D7D7F3E4E5E5FF5AE8C4FF
      4CEDC5FF4CEDC5FF4CEDC5FF4CEDC5FF4CEDC5FF4CEDC5FF4CEDC5FF4CEDC5FF
      4CEDC5FF4CEDC5FF4CEDC5FF68DABDFFD6DBDAFFEEEEEEFFE8E8E8FFF4F4F4FF
      9ECBBFFF4CEDC5FF5AE8C4FFE4E5E5FFD7D7D7F3ACACAC080000000000000000
      0000000000000000000000000000000000000000BDBDBDA5FBFBFBFF8DDAC7FF
      4DEFC6FF4DEFC6FF4DEFC6FF4DEFC6FF4DEFC6FF4DEFC6FF4DEFC6FF4DEFC6FF
      4DEFC6FF4DEFC6FF4DEFC6FF4DEFC6FF68DBBEFFD6DAD9FFF4F4F4FFA7C8C0FF
      53EAC4FF4DEFC6FF8DDAC7FFFBFBFBFFBDBDBDA7000000000000000000000000
      0000000000000000000000000000000000000000ACACAC36E7E7E7FFDCE3E1FF
      5AEAC7FF4DF0C8FF4DF0C8FF4DF0C8FF4DF0C8FF4DF0C8FF4DF0C8FF4DF0C8FF
      4DF0C8FF4DF0C8FF4DF0C8FF4DF0C8FF4DF0C8FF67DCBFFF9BCBBFFF53EBC5FF
      4DF0C8FF5AEAC7FFDCE3E1FFE7E7E7FFACACAC36000000000000000000000000
      000000000000000000000000000000000000000000000000BDBDBDA9F8F8F8FF
      ADD5CBFF4FEFC9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF
      4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF4DF0C9FF
      4FEFC9FFADD5CBFFF8F8F8FFBDBDBDA900000000000000000000000000000000
      000000000000000000000000000000000000000000000000ACACAC16D6D6D6E5
      F7F7F7FFA0D7CAFF51F0CAFF4EF1CAFF4EF1CAFF4EF1CAFF4EF1CAFF4EF1CAFF
      4EF1CAFF4EF1CAFF4EF1CAFF4EF1CAFF4EF1CAFF4EF1CAFF4EF1CAFF51F0CAFF
      A0D7CAFFF7F7F7FFD6D6D6E5ACACAC1600000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000ACACAC34
      D8D8D8F1F7F7F7FFB1D4CCFF5BECCAFF4EF2CCFF4EF2CCFF4EF2CCFF4EF2CCFF
      4EF2CCFF4EF2CCFF4EF2CCFF4EF2CCFF4EF2CCFF4EF2CCFF5BECCAFFB2D4CCFF
      F7F7F7FFD8D8D8F1ACACAC340000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      ACACAC32D5D5D5E3F8F8F8FFDCE3E1FF8EDCC9FF5CEDCBFF4FF3CCFF4FF3CCFF
      4FF3CCFF4FF3CCFF4FF3CCFF4FF3CCFF5CEDCBFF8EDCC9FFDCE3E1FFF8F8F8FF
      D5D5D5E3ACACAC32000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000ACACAC14BDBDBDA9E6E6E6FFFCFCFCFFE5E5E5FFBEDDD5FF9EDBCDFF
      89D9C7FF89D9C7FF9EDBCDFFBDDDD6FFE5E5E5FFFCFCFCFFE6E6E6FFBCBCBCA9
      ACACAC1400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000ACACAC34BFBFBFA1D3D3D3EDEAEAEAFFF7F7F7FF
      FEFEFEFFFEFEFEFFF7F7F7FFEAEAEAFFD3D3D3EDBFBFBFA1ACACAC3400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000ACACAC04ACACAC3AACACAC62
      ACACAC7EACACAC7EACACAC62ACACAC3AACACAC04000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE007FFFF8001FFFF0000FF
      FE00007FFC00003FF800001FF800001FF000000FF000000FF000000FF000000F
      F000000FF000000FF000000FF000000FF000000FF000000FF800001FF800001F
      FC00003FFE00007FFF0000FFFF8001FFFFE007FFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF}
    Transparent = True
    OnClick = lblMsgClick
    ExplicitLeft = 48
  end
  object imgerror: TImage
    Left = 64
    Top = 0
    Width = 32
    Height = 32
    Align = alLeft
    Picture.Data = {
      055449636F6E0000010001002020000001002000A81000001600000028000000
      2000000040000000010020000000000000100000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000001C16C4021C16C43E1C16C48B1C16C4C51C16C4E9
      1C16C4F91C16C4F91C16C4E91C16C4C51C16C48B1C16C43E1C16C40200000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000001C16C4021C16C4721C16C4FF1C1DC0FF1B25BCFF1A2BB8FF1A2FB6FF
      1A30B5FF1A30B5FF1A2FB6FF1A2BB8FF1B25BCFF1C1DC0FF1C16C4FF1C16C472
      1C16C40200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      1C16C4621C16C4FF1C21C0FF1B2EBBFF1B32B9FF1B33BAFF1B33BAFF1B33BAFF
      1B33BAFF1B33BAFF1B33BAFF1B33BAFF1B33BAFF1B32B9FF1B2EBBFF1C21C0FF
      1C16C4FF1C16C462000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000001C16C48B
      1C1BC3FF1B2DBEFF1B33BDFF1B34BEFF1B34BEFF1B34BEFF1B34BEFF1B34BFFF
      1B34BFFF1B34BFFF1B34BFFF1B34BEFF1B34BEFF1B34BEFF1B34BEFF1B33BDFF
      1B2DBEFF1C1BC3FF1C16C48B0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001C16C4911D1FC3FF
      1C33C0FF1C35C1FF1C35C1FF1C35C1FF1C35C2FF1C35C2FF1D35C3FF1D35C3FF
      1D35C3FF1D35C3FF1D35C3FF1D35C3FF1C35C2FF1C35C2FF1C35C1FF1C35C1FF
      1C35C1FF1C33C0FF1D1FC3FF1C16C49100000000000000000000000000000000
      00000000000000000000000000000000000000001C16C48B1D20C4FF1D34C4FF
      1D35C4FF1D36C5FF1D36C6FF1D36C6FF1E36C7FF1E36C7FF1E36C8FF1E36C8FF
      1E36C8FF1E36C8FF1E36C8FF1E36C8FF1E36C7FF1E36C7FF1D36C6FF1D36C6FF
      1D36C5FF1D35C4FF1D34C4FF1D20C4FF1C16C48B000000000000000000000000
      000000000000000000000000000000001C16C4621F1EC5FF1D34C8FF1D36C8FF
      1D37C9FF1D37CAFF1E38CDFF1E38CEFF1E38CEFF1E38CDFF1E38CCFF1E38CCFF
      1E38CCFF1E38CCFF1E38CCFF1E38CCFF1E37CCFF1E38CDFF1E38CEFF1E38CEFF
      1E38CCFF1D37C9FF1D36C8FF1D34C8FF1F1EC5FF1C16C4620000000000000000
      0000000000000000000000001C16C4021D17C4FF1E30CAFF1E37CCFF1E38CDFF
      1E38CEFF1E38CEFF1E38CEFFFFFFFFFFFFFFFFFF1E38CEFF1E38CFFF1F39D1FF
      1F39D1FF1F39D1FF1F39D1FF1F39D0FF1E38CFFF1E38CEFFFFFFFFFFFFFFFFFF
      1E38CEFF1E38CEFF1E38CDFF1E37CCFF1E30CAFF1D17C4FF1C16C40200000000
      0000000000000000000000001C16C4722127C9FF1E38CFFF1E38D0FF1E39D2FF
      1F39D3FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1E38CEFF1E39D1FF
      1F3AD5FF1F3AD5FF1F3AD5FF1E39D1FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF1E38CEFF1E39D2FF1E38D0FF1E38CFFF2127C9FF1C16C47200000000
      0000000000000000000000001C16C4FF1F34D1FF1F39D4FF1F3AD5FF1F3AD6FF
      1F3AD7FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1E38CEFF
      1F39D3FF203BDAFF1F39D3FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF1E38CEFF1F3AD6FF1F3AD5FF1F39D4FF1F34D1FF1D17C4FF1C16C402
      00000000000000001C16C43E2728CAFF203AD7FF203AD8FF203BDAFF203BDBFF
      213BDBFF1F3AD4FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      1E38CEFF1F3AD5FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      1E38CEFF1F39D3FF203BDBFF203BDAFF203AD8FF203AD7FF2728CAFF1C16C43E
      00000000000000001C16C48B2A34D2FF203CDCFF203DDDFF203DDEFF203DDEFF
      213DDFFF213EE0FF1F3AD6FF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFF1E38CEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1E38CEFF
      1F3AD5FF213DDFFF203DDEFF203DDEFF203DDDFF203CDCFF2934D2FF1C16C489
      00000000000000001C16C4C32639D9FF213DE0FF213EE1FF213EE2FF223EE3FF
      223FE4FF223FE4FF223FE5FF203BD7FF1E38CEFFFCFCFCFFFCFCFCFFFCFCFCFF
      FCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFFFCFCFCFF1E38CEFF203BD7FF
      223FE4FF223FE4FF223EE3FF213EE2FF213EE1FF213DE0FF2639D9FF1C16C4C3
      00000000000000001C16C4E9223CE1FF213EE5FF213FE6FF213FE7FF223FE8FF
      223FE9FF2240EAFF2240EAFF2240EBFF203BDAFF1E38CEFFF7F7F7FFF7F7F7FF
      F7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FFF7F7F7FF1E38CEFF203BDAFF2240EAFF
      2240EAFF223FE9FF223FE8FF213FE7FF213FE6FF213EE5FF223CE1FF1C16C4E9
      00000000000000001C16C4F92440E7FF223FE8FF2240EAFF2240EBFF2340ECFF
      2340EDFF2341EEFF2341EEFF2341EFFF2341EFFF203CDCFF1E38CEFFF2F2F2FF
      F2F2F2FFF2F2F2FFF2F2F2FFF2F2F2FF1E38CEFF203CDCFF2341EFFF2341EEFF
      2341EEFF2340EDFF2340ECFF2240EBFF2240EAFF223FE8FF2440E7FF1C16C4F9
      00000000000000001C16C4F92E48E8FF2642E8FF2643EAFF2643EBFF2743ECFF
      2743EDFF2744EEFF2744EEFF2744EFFF223DDCFF1E38CEFFEDEDEDFFEDEDEDFF
      EDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFFEDEDEDFF1E38CEFF223DDCFF2744EEFF
      2744EEFF2743EDFF2743ECFF2643EBFF2643EAFF2642E8FF2E48E8FF1C16C4F9
      00000000000000001C16C4E93B51E7FF2A46E9FF2A47EBFF2A47ECFF2A47EDFF
      2B47EEFF2B48EFFF2B48EFFF233FDCFF1E38CEFFE8E8E8FFE8E8E8FFE8E8E8FF
      E8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FFE8E8E8FF1E38CEFF233FDCFF
      2B48EFFF2B47EEFF2A47EDFF2A47ECFF2A47EBFF2A46E9FF3B51E7FF1C16C4E9
      00000000000000001C16C4C34757E3FF2D49E9FF2D49EAFF2D4AECFF2D4AEDFF
      2E4AEEFF2E4AEEFF2540DCFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF
      E5E5E5FF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF1E38CEFF
      253FDBFF2E4AEEFF2D4AEDFF2D4AECFF2D49EAFF2D49E9FF4757E2FF1C16C4C3
      00000000000000001C16C4894951DBFF324DE9FF324DEAFF324DEBFF324EECFF
      324EEDFF2741DBFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF
      1E38CEFF2741DCFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF
      1E38CEFF2641DBFF324EECFF324DEBFF324DEAFF324DE9FF4951DBFF1C16C489
      00000000000000001C16C43E3635CFFF3F59EAFF3550EAFF3550ECFF3551EDFF
      3551EEFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF1E38CEFF
      2843DCFF3652F1FF2843DCFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF
      E5E5E5FF1E38CEFF3551EDFF3550ECFF3550EAFF3F59EAFF3635CFFF1C16C43E
      0000000000000000000000001C17C4FF5E6EE8FF3853EAFF3953EBFF3953ECFF
      3954EDFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FFE5E5E5FF1E38CEFF2A44DCFF
      3A55F1FF3A55F1FF3A55F1FF2A44DCFF1E38CEFFE5E5E5FFE5E5E5FFE5E5E5FF
      E5E5E5FF1E38CEFF3953ECFF3953EBFF3853EAFF5D6EE8FF1C17C4FF00000000
      0000000000000000000000001C16C4724648D6FF4C63EBFF3C56EAFF3D56ECFF
      3D57EDFF2B45DBFF1E38CEFFE5E5E5FFE5E5E5FF1E38CEFF2B45DCFF3E58F0FF
      3E58F0FF3E58F0FF3E58F0FF3E58F0FF2B45DCFF1E38CEFFE5E5E5FFE5E5E5FF
      1E38CEFF2B45DBFF3D56ECFF3C56EAFF4C63EBFF4648D6FF1C16C47200000000
      0000000000000000000000001C16C4021D18C5FF6B77E7FF435CEAFF3F59EBFF
      4059ECFF405AEDFF2C46DBFF1E38CEFF1E38CEFF2C46DCFF405AEFFF405AEFFF
      415BF0FF415BF0FF405AEFFF405AEFFF405AEFFF2C46DCFF1E38CEFF1E38CEFF
      2C46DBFF4059ECFF3F59EBFF435CEAFF6B77E7FF1D18C5FF1C16C40200000000
      000000000000000000000000000000001C16C4602D2BCBFF7585EDFF445CEAFF
      435CEBFF445CECFF445DEDFF445DEDFF445DEEFF445DEEFF445DEFFF445DEFFF
      445DEFFF445DEFFF445DEFFF445DEFFF445DEEFF445DEEFF445DEDFF445DEDFF
      445CECFF435CEBFF445CEAFF7685EDFF2D2BCBFF1C16C4600000000000000000
      00000000000000000000000000000000000000001C16C4893C3BD1FF7B8BEFFF
      4C63ECFF465FECFF475FEDFF475FEDFF475FEEFF475FEEFF4760EFFF4760EFFF
      4760EFFF4760EFFF4760EFFF4760EFFF475FEEFF475FEEFF475FEDFF475FEDFF
      465FECFF4C63ECFF7C8CEFFF3C3CD1FF1C16C48B000000000000000000000000
      0000000000000000000000000000000000000000000000001C16C4913A39D0FF
      808EEDFF596EEDFF4A61EBFF4A62ECFF4B62EDFF4B62EDFF4B62EEFF4B62EEFF
      4B62EEFF4B62EEFF4B62EEFF4B62EEFF4B62EDFF4B62EDFF4A62ECFF4A61EBFF
      596EEDFF808EEDFF3938CFFF1C16C49100000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000001C16C483
      2C28CAFF7B84E8FF798AEFFF576DECFF4D64EBFF4D65ECFF4D65ECFF4D65EDFF
      4D65EDFF4D65EDFF4D65EDFF4D65ECFF4D65ECFF4D64EBFF576DECFF798AEFFF
      7B84E8FF2C28CAFF1C16C4830000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      1C16C4601D17C4FF4B4DD6FF8490ECFF8495F0FF7083EFFF6075EDFF566CECFF
      5168EBFF5168EBFF566CECFF6075EDFF7083EFFF8495F0FF8490ECFF4B4DD6FF
      1D17C4FF1C16C460000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000001C16C4021C16C4721C17C4FF3A39CFFF5E63DDFF7B84E8FF8C98EFFF
      94A2F2FF94A2F2FF8C98EFFF7B84E8FF5F63DDFF3A39CFFF1C17C4FF1C16C472
      1C16C40200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000001C16C43E1C16C4891C16C4C51C16C4E9
      1C16C4F91C16C4F91C16C4E91C16C4C51C16C48B1C16C43E0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FFFFFFFFFFF00FFFFFC003FFFF0000FFFC00003FF800001FF000000F
      F000000FE0000007E0000007C0000003C0000003800000018000000180000001
      8000000180000001800000018000000180000001C0000003C0000003E0000007
      E0000007F000000FF000000FF800001FFC00003FFF0000FFFFC003FFFFF00FFF
      FFFFFFFF}
    Transparent = True
    OnClick = lblMsgClick
    ExplicitLeft = 56
  end
  object tmr1: TTimer
    OnTimer = tmr1Timer
    Left = 328
  end
end
