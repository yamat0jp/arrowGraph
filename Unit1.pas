unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.Menus,
  Vcl.ExtCtrls, System.Generics.Collections, System.Types;

type
  TMyData = class;

  TMyLine = class
  public
    start: TPoint;
    endPoint: TPoint;
    prev, next: TMyData;
  end;

  TMyData = class
  public
    left, top: integer;
    Length: integer;
    color: TColor;
    id: Char;
    data1, data2, data3: integer;
    lines: TList<TMyLine>;
    constructor Create;
    destructor Destroy; override;
  end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    start: TAction;
    checkRoot: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1DragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: Boolean);
    procedure startExecute(Sender: TObject);
    procedure checkRootExecute(Sender: TObject);
  private
    { Private êÈåæ }
    function checkClick(X, Y: integer): Boolean;
    function createBox(X, Y: integer): TMyData;
    procedure addLine(prev, next: TMyData);
  public
    { Public êÈåæ }
    list: TList<TMyData>;
    list2: TList<TMyLine>;
    active: TMyData;
    dragitem: TObject;
    starting, stopping: TMyData;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.startExecute(Sender: TObject);
begin
  starting := TMyData.Create;
  starting.left := PaintBox1.left + 10;
  starting.top := PaintBox1.Height div 2;
  list.Add(starting);
  stopping := TMyData.Create;
  stopping.left := PaintBox1.Width - stopping.Length - 10;
  stopping.top := PaintBox1.Height div 2;
  list.Add(stopping);
  PaintBox1Paint(Sender);
end;

procedure TForm1.addLine(prev, next: TMyData);
var
  obj: TMyLine;
begin
  obj := TMyLine.Create;
  list2.Add(obj);
  obj.start := Point(prev.left, prev.top);
  obj.endPoint := Point(next.left, next.top);
  obj.prev := prev;
  obj.next := next;
  prev.lines.Add(obj);
end;

function TForm1.checkClick(X, Y: integer): Boolean;
var
  data: TMyData;
begin
  result := false;
  for data in list do
    if (data.left < X) and (X < data.left + data.Length) and (data.top < Y) and
      (Y < data.top + data.Length) then
    begin
      active := data;
      result := true;
      break;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  list := TList<TMyData>.Create;
  list2 := TList<TMyLine>.Create;
  PaintBox1.Canvas.Pen.Width := 3;
  startExecute(Sender);
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  obj: TObject;
begin
  for obj in list do
    obj.Free;
  list.Free;
  for obj in list2 do
    obj.Free;
  list2.Free;
end;

procedure TForm1.checkRootExecute(Sender: TObject);
var
  item: TMyData;
  ls: TList<TMyData>;
  c: Char;
  i: integer;
  j: integer;
begin
  c := 'A';
  for i := 0 to list.Count - 1 do
    list[i].id := #0;
  ls := TList<TMyData>.Create;
  ls.Add(starting);
  try
    for i := 0 to list.Count - 1 do
      while ls.Count > 0 do
      begin
        item := ls[0];
        if item.id = #0 then
        begin
          for j := 0 to item.lines.Count - 1 do
            ls.Add(item.lines[j].next);
          item.id := c;
          c := Succ(c);
        end;
        ls.Delete(0);
      end;
  finally
    ls.Free;
  end;
  PaintBox1Paint(Sender);
end;

function TForm1.createBox(X, Y: integer): TMyData;
begin
  result := TMyData.Create;
  result.left := X;
  result.top := Y;
  list.Add(result);
end;

procedure TForm1.PaintBox1DragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: Boolean);
var
  item: TMyData;
begin
  case State of
    TDragState.dsDragEnter:
      if checkClick(X, Y) = true then
      begin
        dragitem := active;
        active.color := clYellow;
      end;
    TDragState.dsDragLeave:
      begin
        if checkClick(X, Y) = true then
        begin
          if dragitem <> active then
            with dragitem as TMyData do
            begin
              if list.IndexOf(active) = -1 then
                list.Add(active);
              addLine(dragitem as TMyData, active);
            end;
        end
        else
        begin
          item := createBox(X, Y);
          addLine(dragitem as TMyData, item);
        end;
        TMyData(dragitem).color := clBlack;
        PaintBox1Paint(Sender);
      end;
    TDragState.dsDragMove:
      if (checkClick(X, Y) = true) and (dragitem = active) then
        Accept := false;
  end;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if checkClick(X, Y) = true then
    PaintBox1.BeginDrag(true)
  else
    createBox(X, Y);
  PaintBox1Paint(Sender);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  obj: TMyLine;
  item: TMyData;
begin
  Canvas.FillRect(ClientRect);
  for item in list do
    with PaintBox1.Canvas do
    begin
      Pen.color := item.color;
      Ellipse(item.left, item.top, item.left + item.Length,
        item.top + item.Length);
      Font.color := clGreen;
      Font.Size := 13;
      TextOut(item.left + 8, item.top + 8, item.id);
    end;
  PaintBox1.Canvas.Pen.color := clBlack;
  for obj in list2 do
    with PaintBox1.Canvas do
    begin
      MoveTo(obj.start.X, obj.start.Y);
      LineTo(obj.endPoint.X, obj.endPoint.Y);
    end;
end;

{ TMyData }

constructor TMyData.Create;
begin
  Length := 33;
  color := clBlack;
  lines := TList<TMyLine>.Create;
end;

destructor TMyData.Destroy;
begin
  lines.Free;
  inherited;
end;

end.
