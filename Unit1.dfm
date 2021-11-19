object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 613
  ClientWidth = 846
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
    Width = 846
    Height = 613
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
  object MainMenu1: TMainMenu
    Left = 464
    Top = 232
    object N1: TMenuItem
      Caption = #23455#34892
      object N2: TMenuItem
        Action = checkRoot
      end
      object inputData1: TMenuItem
        Action = inputData
      end
    end
    object N3: TMenuItem
      Caption = #35373#23450
      object dummyArrow1: TMenuItem
        AutoCheck = True
        Caption = 'dummyArrow'
        GroupIndex = 1
        OnClick = dummyArrow1Click
      end
    end
    object N4: TMenuItem
      Caption = #26360#24335
      object back1: TMenuItem
        Action = back
      end
    end
  end
  object ActionList1: TActionList
    Left = 600
    Top = 232
    object start: TAction
      Category = #23455#34892
      Caption = 'start'
      OnExecute = startExecute
    end
    object checkRoot: TAction
      Category = #23455#34892
      Caption = 'checkRoot'
      OnExecute = checkRootExecute
    end
    object inputData: TAction
      Category = #23455#34892
      Caption = 'inputData'
      OnExecute = inputDataExecute
    end
    object back: TAction
      Category = #26360#24335
      Caption = 'back'
      OnExecute = backExecute
    end
  end
end
