program arrow;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  OKCANCL2 in 'OKCANCL2.pas' {OKRightDlg},
  ABOUT in 'ABOUT.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOKRightDlg, OKRightDlg);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
