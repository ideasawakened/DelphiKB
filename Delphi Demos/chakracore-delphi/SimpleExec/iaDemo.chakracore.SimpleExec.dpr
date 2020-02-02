program iaDemo.chakracore.SimpleExec;

uses
  Vcl.Forms,
  //replace project search path for your location of source files from: https://github.com/tondrej/chakracore-delphi
  iaDemo.chakracore.SimpleExec.MainForm in 'iaDemo.chakracore.SimpleExec.MainForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
