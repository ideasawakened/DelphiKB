program iaDemo.VCLForkJoin;

uses
  Vcl.Forms,
  iaDemo.VCLForkJoin.MainForm in 'iaDemo.VCLForkJoin.MainForm.pas' {frmMain},
  iaExample.CDE.ParallelTask in 'iaExample.CDE.ParallelTask.pas',
  iaExample.CDE.ControllerThread in 'iaExample.CDE.ControllerThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
