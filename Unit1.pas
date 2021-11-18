unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.Menus,
  Vcl.ExtCtrls, System.Generics.Collections, System.Types;

type
  TMyLine = class
  public
    start: TPoint;
    endPoint: TPoint;
    data1, data2, data3: integer;
  end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PaintBox1DragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBox1Paint(Sender: TObject);
    procedure shapeDragDrop(Sender, Source: TObject; X, Y: integer);
    procedure shapeDragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: Boolean);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    list: TList<TShape>;
    list2: TList<TMyLine>;
    active: TObject;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.shapeDragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: Boolean);
begin
  case State of
    TDragState.dsDragEnter:
      if active = Sender then
        TShape(Sender).DragCursor := crDrag;
    TDragState.dsDragLeave:
      if active <> Sender then
        TShape(Sender).DragCursor := crHandPoint;
    TDragState.dsDragMove:
      Accept := true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  list := TList<TShape>.Create;
  list2 := TList<TMyLine>.Create;
  PaintBox1.Canvas.Pen.Width := 3;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
  obj: TObject;
begin
  for i := 0 to list.Count - 1 do
  begin
    TList<TShape>(list[i].Tag).Free;
    list[i].Free;
  end;
  list.Free;
  for obj in list2 do
    obj.Free;
  list2.Free;
end;

procedure TForm1.PaintBox1DragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: Boolean);
begin
  case State of
    TDragState.dsDragEnter:
      begin
        active := Source;
        TShape(Source).Pen.Color := clYellow;
      end;
    TDragState.dsDragLeave:
      TShape(Source).Pen.Color := clBlack;
    TDragState.dsDragMove:
      Accept := true;
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  item: TShape;
begin
  item := TShape.Create(Self);
  item.Left := X;
  item.Top := Y;
  item.Width := 33;
  item.Height := 33;
  item.Tag := integer(TList<TShape>.Create);
  item.Pen.Width := 3;
  item.Shape := stEllipse;
  item.DragMode := dmAutomatic;
  item.OnDragOver := shapeDragOver;
  item.OnDragDrop := shapeDragDrop;
  item.Parent := Self;
  list.Add(item);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  obj: TMyLine;
begin
  for obj in list2 do
    with PaintBox1.Canvas do
    begin
      MoveTo(obj.start.X, obj.start.Y);
      LineTo(obj.endPoint.X, obj.endPoint.Y);
    end;
end;

procedure TForm1.shapeDragDrop(Sender, Source: TObject; X, Y: integer);
var
  item: TMyLine;
begin
  if active = Sender then
    Exit;
  item := TMyLine.Create;
  list2.Add(item);
  with Source as TShape do
  begin
    item.start := Point(Left, Top);
    DragCursor := crDrag;
  end;
  with Sender as TShape do
    item.endPoint := Point(Left, Top);
end;

end.
