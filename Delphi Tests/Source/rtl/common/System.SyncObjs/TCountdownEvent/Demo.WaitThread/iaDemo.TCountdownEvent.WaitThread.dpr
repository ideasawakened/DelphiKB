program iaDemo.TCountdownEvent.WaitThread;

{$APPTYPE CONSOLE}

{$R *.res}
uses
  System.SyncObjs,
  System.Classes,
  iaExample.CDE.WaitingThread in 'iaExample.CDE.WaitingThread.pas',
  iaTestSupport.Log in '..\..\..\..\..\iaTestSupport.Log.pas';


begin
  //TCountdownEvent:
  //Alternative to TThread.WaitFor, acts like an inverse semphore as signaled when 0, available in XE2+
  //Nice feature: You can specify a timeout on waiting

  var vCDE := TCountdownEvent.Create(20);
  try
    var vThread := TExampleWaitingThread.Create(vCDE);
    try
      WriteLn('Hit <ENTER> to start work (background thread has been spun up and is waiting)');
      ReadLn;

      //Demo countdown in the main thread from 20 to 0...work typically done in threads
      while not vCDE.IsSet do
      begin
        WriteLn(vCDE.CurrentCount);  //Display: 20,19,18,...
        vCDE.Signal;
      end;
      WriteLn(vCDE.CurrentCount);  //Display: 0  (IsSet is true, so CurrentCount = 0)
      WriteLn('Work complete, hit <ENTER> to continue (Background thread has completed waiting by now)');
      ReadLn;

      CheckSynchronize; // Only needed in a console app to pump messages from the sync queue
      //Display: CDE Count reached zero
    finally
      vThread.Free();
    end;
  finally
    vCDE.Free();
  end;
  WriteLn('Hit <ENTER> to exit');
  ReadLn;

end.
