object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 603
  ClientWidth = 836
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 651
    Height = 603
    Align = alClient
    DragCursor = crHandPoint
    OnDragOver = PaintBox1DragOver
    OnMouseDown = PaintBox1MouseDown
    OnPaint = PaintBox1Paint
    ExplicitLeft = 376
    ExplicitTop = 272
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Panel1: TPanel
    Left = 651
    Top = 0
    Width = 185
    Height = 603
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 0
  end
  object MainMenu1: TMainMenu
    Left = 464
    Top = 232
    object N1: TMenuItem
      Caption = #23455#34892
      object N2: TMenuItem
        Action = checkRoot
      end
    end
  end
  object ActionList1: TActionList
    Left = 600
    Top = 232
    object start: TAction
      Caption = 'start'
      OnExecute = startExecute
    end
    object checkRoot: TAction
      Caption = 'checkRoot'
      OnExecute = checkRootExecute
    end
  end
end
