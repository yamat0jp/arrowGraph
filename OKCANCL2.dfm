object OKRightDlg: TOKRightDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #12480#12452#12450#12525#12464
  ClientHeight = 344
  ClientWidth = 449
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 321
    Height = 321
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 365
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 365
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 1
  end
  object ValueListEditor1: TValueListEditor
    Left = 16
    Top = 16
    Width = 306
    Height = 300
    TabOrder = 2
  end
end
