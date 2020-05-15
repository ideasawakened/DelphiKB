unit iaExample.CDE.ControllerThread;

interface
uses
  System.Classes,
  System.SyncObjs,
  Vcl.StdCtrls;

type

  TExampleControllerThread = class(TThread)
  private const
    WorkerThreadCount = 3;
  private
    fCDE:TCountdownEvent;
    fCallBackMemo:TMemo;
  protected
    procedure Execute(); override;
    procedure CallBack(const pText:string);
    procedure Fork();
    procedure Join();
  public
    constructor Create(const pCallbackTo:TMemo);
    destructor Destroy(); override;
  end;


implementation
uses
  System.SysUtils,
  iaExample.CDE.ParallelTask;


constructor TExampleControllerThread.Create(const pCallbackTo:TMemo);
begin
  fCDE := TCountdownEvent.Create(1);
  fCallBackMemo := pCallbackTo;
  FreeOnTerminate := True;
  inherited Create(False);
end;


destructor TExampleControllerThread.Destroy();
begin
  fCDE.Free();
  inherited;
end;


procedure TExampleControllerThread.Execute();
begin
  NameThreadForDebugging('ExampleCDEControllerThread');
  CallBack('Creating worker threads');

  Fork();
  CallBack('Controller waiting for workers to finish');
  Join();

  CallBack('Work completed');
end;


(*
Alternate, AddCount for each task
procedure TExampleControllerThread.Fork();
begin
  for var i := 1 to WorkerThreadCount do
  begin
    fCDE.AddCount;
    TExampleParallelTask.Create(fCDE);
  end;
end;
*)

//spin up some child threads
procedure TExampleControllerThread.Fork();
begin
  fCDE.AddCount(WorkerThreadCount);

  for var i := 1 to WorkerThreadCount do
  begin
    TExampleParallelTask.Create(fCDE);
  end;
end;


//wait for the children to be done with their work
procedure TExampleControllerThread.Join();
begin
  fCDE.Signal();
  fCDE.WaitFor();
end;


procedure TExampleControllerThread.CallBack(const pText:string);
begin
  Synchronize(procedure()
              begin
                fCallBackMemo.Lines.Add(FormatDateTime('hh:nn:ss.zzzz', Now) + ' ' + pText);
              end);
end;

end.
