program iaStressTest.TThreadedQueue;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  iaStressTest.TThreadedQueue.PopItem in 'iaStressTest.TThreadedQueue.PopItem.pas',
  iaTestSupport.Log in '..\..\..\..\..\iaTestSupport.Log.pas',
  MonitorWaitStackFix in 'MonitorWaitStackFix.pas';

begin

  try
    if not StressTestPopItem() then
    begin
      ExitCode := 1;
    end;
  except on E: Exception do
    begin
      LogIt('Test failed due to exception: ' + E.Message);
      ExitCode := 2;
    end;
  end;
  LogIt('Hit <enter> to exit');
  ReadLn;
end.
