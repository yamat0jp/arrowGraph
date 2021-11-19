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
    dash: Boolean;
    time: integer;
    constructor Create;
  end;

  TMyData = class
  public
    left, top: integer;
    Length: integer;
    color: TColor;
    id: Char;
    data1, data2, data3: integer;
    prev, next: TList<TMyData>;
    constructor Create;
    destructor Destroy; override;
  end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    PaintBox1: TPaintBox;
    start: TAction;
    checkRoot: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    dummyArrow1: TMenuItem;
    inputData: TAction;
    back: TAction;
    N4: TMenuItem;
    back1: TMenuItem;
    calcurate: TAction;
    execApp: TAction;
    inputData1: TMenuItem;
    calcurate2: TMenuItem;
    N5: TMenuItem;
    execApp1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1DragOver(Sender, Source: TObject; X, Y: integer;
      State: TDragState; var Accept: Boolean);
    procedure startExecute(Sender: TObject);
    procedure checkRootExecute(Sender: TObject);
    procedure dummyArrow1Click(Sender: TObject);
    procedure inputDataExecute(Sender: TObject);
    procedure backExecute(Sender: TObject);
    procedure calcurateExecute(Sender: TObject);
    procedure execAppExecute(Sender: TObject);
  private
    { Private êÈåæ }
    list: TList<TMyData>;
    list2: TList<TMyLine>;
    stack: TStack<TObject>;
    active: TMyData;
    dragitem: TMyData;
    starting, stopping: TMyData;
    dummy: Boolean;
    complete: Boolean;
    function checkClick(X, Y: integer): Boolean;
    function createBox(X, Y: integer): TMyData;
    procedure addLine(prev, next: TMyData);
    function isError: Boolean;
    function getTime(prev, next: TMyData): integer;
    procedure setTime(obj: TMyData; reverse: Boolean);
  public
    { Public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses OKCANCL2;

procedure TForm1.setTime(obj: TMyData; reverse: Boolean);
var
  s: TMyData;
  i: integer;
begin
  if reverse = false then
    for s in obj.next do
    begin
      i := getTime(obj, s) + obj.data1;
      if s.data1 < i then
        s.data1 := i;
      if stopping <> s then
        setTime(s, reverse);
    end
  else
    for s in obj.prev do
    begin
      i := obj.data2 - getTime(s, obj);
      if (s.data2 = -1) or (s.data2 > i) then
        s.data2 := i;
      if starting <> s then
        setTime(s, reverse);
    end;
end;

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
  if (prev.next.IndexOf(next) > -1)or(next.prev.IndexOf(prev) > -1) then
    Exit;
  if (dummy = true) and ((prev = starting) or (next = stopping)) then
    Exit;
  obj := TMyLine.Create;
  list2.Add(obj);
  stack.Push(obj);
  obj.start := Point(prev.left, prev.top);
  obj.endPoint := Point(next.left, next.top);
  obj.prev := prev;
  obj.next := next;
  if dummy = true then
  begin
    obj.dash := true;
    obj.time := 0;
    dummyArrow1.Click;
  end;
  prev.next.Add(next);
  next.prev.Add(prev);
end;

procedure TForm1.backExecute(Sender: TObject);
var
  obj: TObject;
  s, prev, next: TMyData;
  line: TMyLine;
  i: integer;
begin
  obj := stack.Pop;
  if obj is TMyLine then
  begin
    line := obj as TMyLine;
    list2.Delete(list2.IndexOf(line));
    prev := line.prev;
    next := line.next;
    i := prev.next.IndexOf(next);
    prev.next.Delete(i);
    i := next.prev.IndexOf(prev);
    next.prev.Delete(i);
    obj.Free;
  end
  else if obj is TMyData then
  begin
    s := obj as TMyData;
    list.Delete(list.IndexOf(s));
    for prev in s.prev do
    begin
      i := prev.next.IndexOf(s);
      prev.next.Delete(i);
    end;
    for next in s.next do
    begin
      i := next.prev.IndexOf(s);
      next.prev.Delete(i);
    end;
    obj.Free;
  end;
  PaintBox1Paint(Sender);
end;

procedure TForm1.calcurateExecute(Sender: TObject);
var
  s: TMyData;
begin
  for s in list do
  begin
    s.data1 := -1;
    s.data2 := -1;
    s.data3 := -1;
  end;
  starting.data1 := 0;
  setTime(starting, false);
  stopping.data2 := stopping.data1;
  setTime(stopping, true);
  for s in list do
    s.data3 := s.data2 - s.data1;
  complete := true;
  PaintBox1Paint(Sender);
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

procedure TForm1.inputDataExecute(Sender: TObject);
var
  obj: TMyLine;
  s: string;
  i: integer;
begin
  OKRightDlg.ValueListEditor1.Strings.Clear;
  for obj in list2 do
    if obj.dash = false then
    begin
      s := obj.prev.id + ' --> ' + obj.next.id + '=';
      OKRightDlg.ValueListEditor1.Strings.AddObject(s, obj);
    end;
  if OKRightDlg.ShowModal = mrOK then
    with OKRightDlg.ValueListEditor1.Strings do
      for i := 0 to Count - 1 do
        TMyLine(Objects[i]).time := ValueFromIndex[i].ToInteger;
  PaintBox1Paint(Sender);
end;

function TForm1.isError: Boolean;
var
  s: TMyData;
begin
  result := list2.Count = 0;
  for s in list do
    if (s <> starting) and (s <> stopping) then
      if (s.prev.Count = 0) or (s.next.Count = 0) then
        result := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  list := TList<TMyData>.Create;
  list2 := TList<TMyLine>.Create;
  stack := TStack<TObject>.Create;
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
  stack.Free;
end;

function TForm1.getTime(prev, next: TMyData): integer;
var
  s: TMyLine;
begin
  result := 0;
  for s in list2 do
    if (s.prev = prev) and (s.next = next) then
      result := s.time;
end;

procedure TForm1.checkRootExecute(Sender: TObject);
var
  item, s: TMyData;
  ls: TList<TMyData>;
  c: Char;
begin
  c := 'A';
  for item in list do
    item.id := #0;
  ls := TList<TMyData>.Create;
  ls.Add(starting);
  try
    while ls.Count > 0 do
    begin
      item := ls[0];
      item.id := c;
      c := Succ(c);
      for s in item.next do
        if (s <> stopping) and (s.id = #0) and (ls.IndexOf(s) = -1) then
          ls.Add(s);
      ls.Delete(0);
    end;
  finally
    ls.Free;
  end;
  stopping.id := c;
  if isError = true then
    Showmessage('error');
  PaintBox1Paint(Sender);
end;

function TForm1.createBox(X, Y: integer): TMyData;
begin
  result := TMyData.Create;
  result.left := X;
  result.top := Y;
  list.Add(result);
  stack.Push(result);
end;

procedure TForm1.dummyArrow1Click(Sender: TObject);
begin
  dummy := dummyArrow1.Checked;
end;

procedure TForm1.execAppExecute(Sender: TObject);
begin
  checkRootExecute(Sender);
  inputDataExecute(Sender);
  calcurateExecute(Sender);
end;

procedure TForm1.PaintBox1DragOver(Sender, Source: TObject; X, Y: integer;
  State: TDragState; var Accept: Boolean);
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
        if (checkClick(X, Y) = true) and (active <> starting) then
        begin
          if dragitem <> active then
            if list.IndexOf(active) = -1 then
              list.Add(active);
          addLine(dragitem, active);
        end
        else if (starting.left + 50 < X) and (X < stopping.left - 50) and
          (50 < Y) and (Y < ClientHeight - 50) and (dummy = false) then
          addLine(dragitem, createBox(X, Y));
        dragitem.color := clBlack;
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
  begin
    if active <> stopping then
      PaintBox1.BeginDrag(true);
  end
  else if dummy = false then
    createBox(X, Y);
  PaintBox1Paint(Sender);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  obj: TMyLine;
  item: TMyData;
  X, Y: integer;
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
      X := item.left + 8;
      Y := item.top + 8;
      TextOut(X, Y, item.id);
      TextOut(X, Y + 25, item.data1.ToString);
      TextOut(X, Y + 50, item.data2.ToString);
      if item.data3 = 0 then
        Font.color := clRed;
      TextOut(X, Y + 75, string.Format('(%d)', [item.data3]));
    end;
  PaintBox1.Canvas.Font.color := clBlue;
  for obj in list2 do
    with PaintBox1.Canvas do
    begin
      if obj.dash = true then
        Pen.Style := psDash
      else
        Pen.Style := psSolid;
      if (complete = true) and (obj.prev.data3 = 0) and (obj.next.data3 = 0)
      then
        Pen.color := clRed
      else
        Pen.color := clBlack;
      MoveTo(obj.start.X, obj.start.Y);
      LineTo(obj.endPoint.X, obj.endPoint.Y);
      if obj.time <> -1 then
      begin
        X := obj.start.X + obj.endPoint.X;
        Y := obj.start.Y + obj.endPoint.Y;
        TextOut(X div 2, Y div 2, obj.time.ToString);
      end;
    end;
end;

{ TMyData }

constructor TMyData.Create;
begin
  Length := 33;
  color := clBlack;
  prev := TList<TMyData>.Create;
  next := TList<TMyData>.Create;
end;

destructor TMyData.Destroy;
begin
  prev.Free;
  next.Free;
  inherited;
end;

{ TMyLine }

constructor TMyLine.Create;
begin
  time := -1;
end;

end.
