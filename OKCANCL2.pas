unit OKCANCL2;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit;

type
  TOKRightDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ValueListEditor1: TValueListEditor;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private 宣言 }
    list: TStringList;
  public
    { Public 宣言 }
  end;

var
  OKRightDlg: TOKRightDlg;

implementation

{$R *.dfm}

procedure TOKRightDlg.FormCreate(Sender: TObject);
begin
  list := TStringList.Create;
end;

procedure TOKRightDlg.FormDestroy(Sender: TObject);
begin
  list.Free;
end;

procedure TOKRightDlg.FormHide(Sender: TObject);
begin
  list.Assign(ValueListEditor1.Strings);
end;

procedure TOKRightDlg.FormShow(Sender: TObject);
var
  i, j: Integer;
  s, t: string;
begin
  for i := 0 to list.Count - 1 do
  begin
    s := list.Names[i];
    t := list.ValueFromIndex[i];
    if ValueListEditor1.Strings.IndexOf(s + '=') > -1 then
      ValueListEditor1.Values[s] := t;
  end;
end;

end.
