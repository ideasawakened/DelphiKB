unit iaExample.CDE.ParallelTask;

interface
uses
  System.Classes,
  System.SyncObjs;

type

  TExampleParallelTask = class(TThread)
  private
    fCDE:TCountdownEvent;
  protected
    procedure Execute(); override;
    procedure DoSomeWork();
  public
    constructor Create(const pCDE:TCountdownEvent);
  end;


implementation
uses
  System.SysUtils;


constructor TExampleParallelTask.Create(const pCDE:TCountdownEvent);
begin
  fCDE := pCDE;
  FreeOnTerminate := True;
  inherited Create(False);
end;


procedure TExampleParallelTask.Execute();
begin
  NameThreadForDebugging('ExampleCDEWorkerThread');
  DoSomeWork();
  fCDE.Signal();
end;


procedure TExampleParallelTask.DoSomeWork();
begin
  Sleep(Random(2000));
end;

end.
