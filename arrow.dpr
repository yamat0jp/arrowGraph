program arrow;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  OKCANCL2 in 'OKCANCL2.pas' {OKRightDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOKRightDlg, OKRightDlg);
  Application.Run;
end.
