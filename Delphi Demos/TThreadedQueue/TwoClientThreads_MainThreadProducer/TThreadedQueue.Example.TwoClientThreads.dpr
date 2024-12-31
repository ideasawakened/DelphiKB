program TThreadedQueue.Example.TwoClientThreads;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
