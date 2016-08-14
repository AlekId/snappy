object Test: TTest
  Left = 0
  Top = 0
  Caption = 'Snappy test'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Compress: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Compress'
    TabOrder = 0
    OnClick = CompressClick
  end
  object Uncompress: TButton
    Left = 16
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Uncompress'
    TabOrder = 1
    OnClick = UncompressClick
  end
  object chkSynLZ: TCheckBox
    Left = 120
    Top = 24
    Width = 97
    Height = 17
    Caption = 'chkSynLZ'
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 16
    Top = 88
    Width = 409
    Height = 89
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
