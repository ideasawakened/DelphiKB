program iaStressTest.TThreadedQueue;

{$APPTYPE CONSOLE}

uses
  iaStressTest.TThreadedQueue.PopItem in 'iaStressTest.TThreadedQueue.PopItem.pas',
  iaTestSupport.Log in '..\..\..\..\..\iaTestSupport.Log.pas';

begin
  if not StressTestPopItem() then
  begin
    ExitCode := 1;
  end;
  LogIt('Hit <enter> to exit');
  ReadLn;
end.
