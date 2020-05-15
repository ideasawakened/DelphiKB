unit iaExample.CDE.WaitingThread;

interface
uses
  System.Classes,
  System.SyncObjs;

type

  TExampleWaitingThread = class(TThread)
  private
    fCDE:TCountdownEvent;
  protected
    procedure Execute(); override;
    procedure AllDone();
  public
    constructor Create(const pCDE:TCountdownEvent);
  end;


implementation
uses
  System.SysUtils,
  iaTestSupport.Log;


constructor TExampleWaitingThread.Create(const pCDE:TCountdownEvent);
begin
  fCDE := pCDE;
  inherited Create(False);
end;


procedure TExampleWaitingThread.Execute();
begin
  NameThreadForDebugging('ExampleCDEBackgroundThread');
  try
    fCDE.WaitFor(); //could provide timeout here, otherwise INFINITE

    //resources exhausted: either refill or cleanup and exit.
    //We'll simply exit for the demo
    Synchronize(AllDone);
  except on E:Exception do
    begin
      LogIt('CDE demo: waiting thread exception trapped: ' + E.Message);
    end;
  end;
end;


procedure TExampleWaitingThread.AllDone();
begin
  WriteLn('CDE count reached zero');
end;


end.
