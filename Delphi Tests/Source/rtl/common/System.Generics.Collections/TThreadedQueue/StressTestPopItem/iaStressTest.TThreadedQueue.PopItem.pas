unit iaStressTest.TThreadedQueue.PopItem;

interface
uses
  System.Classes,
  System.Generics.Collections,
  System.SyncObjs;


const
  POP_TIMEOUT = 10; //the lower the timeout, the more pronounced the problem
  MAX_TEST_RUNTIME_SECONDS = 600;
  ACCEPTABLE_TIMEOUTVARIANCE_MS = 60;
  {$IFDEF MSWINDOWS}
    RESERVED_STACK_SIZE = 65536;
    {$IFDEF WIN32}
    MAX_WORKER_THREADS = 6000;
    {$ELSE} //WIN64
    MAX_WORKER_THREADS = 30000;
    {$ENDIF}
  {$ENDIF}


type

  TItem = class (TObject);

  TThreadCreator = Class(TThread)
  public
    procedure Execute(); override;
  end;

  TTestThread = class (TThread)
  private
    FQueue: TThreadedQueue<TItem>;
  public
    procedure AfterConstruction(); override;
    procedure BeforeDestruction(); override;
    procedure Execute(); override;
  end;


  function StressTestPopItem():Boolean;

var
  pubTestCompletionCheck:TEvent;
  pubSyncrhonizedStart:TEvent;


implementation
uses
  System.SysUtils,
  System.DateUtils,
  System.Diagnostics,
  System.RTTI,
  System.TimeSpan,
  iaTestSupport.Log;


function StressTestPopItem():Boolean;
var
  vMaxTestRuntime:TTimeSpan;
  vTestCompletion:TWaitResult;
  vStartedTest:TDateTime;
begin
  vMaxTestRuntime.Create(0, 0, MAX_TEST_RUNTIME_SECONDS);
  LogIt('StressTestPopItem Start: Waiting up to [' + IntToStr(MAX_TEST_RUNTIME_SECONDS) + '] seconds for PopItem to prematurely timeout.');
  LogIt('Note: Using [' + IntToStr(POP_TIMEOUT) + '] as PopTimeout on TThreadedQueue creation');
  vStartedTest := Now;

  //create a bunch of threads, all continuously calling PopItem on an empty TThreadQueue
  TThreadCreator.Create(False);

  //wait until a PopItem fails or test times-out
  vTestCompletion := pubTestCompletionCheck.WaitFor(vMaxTestRuntime);

  Result := (vTestCompletion = TWaitResult.wrTimeout);
  if Result then
  begin
    pubTestCompletionCheck.SetEvent(); //tell threads to terminate
    LogIt('StressTestPopItem End: Overall maximum time limit reached for this test without an error detected...we will call this a success!');
  end
  else
  begin
    LogIt('StressTestPopItem End: After [' + IntToStr(SecondsBetween(Now, vStartedTest)) + '] seconds, a failure of PopItem was detected in at least one thread');
  end;
end;


procedure TThreadCreator.Execute();
var
  vThreadsCreated:Integer;
  vWorkerThreads:Array[0..MAX_WORKER_THREADS-1] of TTestThread;
begin
  Sleep(1000);//More than enough time to ensure the main thread completely settles-in on WaitFor()
  LogIt('TThreadCreator Start: Creating up to [' + IntToStr(MAX_WORKER_THREADS) + '] threads');
  {$IFDEF MSWINDOWS}
  LogIt('Note: Creating threads with a StackSize of [' + IntToStr(RESERVED_STACK_SIZE) + ']');
  {$ENDIF}
  vThreadsCreated := 0;
  while vThreadsCreated < MAX_WORKER_THREADS do
  begin

    if pubTestCompletionCheck.WaitFor(0) = wrSignaled then
    begin
      LogIt('TThreadCreator Note: aborting thread creation at [' + IntToStr(vThreadsCreated) + '] threads as a failure has already been detected.');
      Break;
    end;

    try
      vWorkerThreads[vThreadsCreated] := TTestThread.Create(True{$IFDEF MSWINDOWS}, RESERVED_STACK_SIZE{$ENDIF});
      Inc(vThreadsCreated);
    except on E: Exception do
      begin
        LogIt('TThreadCreator Note: created the maximum number of threads before experiencing system error [' + IntToStr(GetLastError) + ']');
        Break;
      end;
    end;
  end;

  LogIt('Starting [' + IntToStr(vThreadsCreated) + '] worker threads');
  for var i := 0 to vThreadsCreated-1 do
  begin
    vWorkerThreads[i].Start();
  end;

  LogIt('All worker threads started, now signaling synchronized start event to activate them all');
  pubSyncrhonizedStart.SetEvent();

  LogIt('TThreadCreator End: [' + IntToStr(vThreadsCreated) + '] worker threads started');
end;



procedure TTestThread.AfterConstruction();
begin
  FQueue := TThreadedQueue<TItem>.Create(10, 10, POP_TIMEOUT);
  FreeOnTerminate := True;
  inherited;
end;


procedure TTestThread.BeforeDestruction();
begin
  FQueue.DoShutDown();
  FQueue.Free;
  inherited;
end;


procedure TTestThread.Execute();
var
  Item: TItem;
  vWaitResult:TWaitResult;
  vStopwatch:TStopwatch;
begin
  while not Terminated do
  begin
    vStopwatch := TStopwatch.StartNew;
    vWaitResult := FQueue.PopItem( Item );
    vStopWatch.Stop();

    if fQueue.ShutDown then Break;
    if pubTestCompletionCheck.WaitFor(0) = wrSignaled then Break;

    //Note: Reason for ACCEPTABLE_VARIANCE_MS is that on some low timeout values (like 200ms) it occasionally times out a little early (like 180ms)
    if (vWaitResult = wrTimeout) and (vStopWatch.ElapsedMilliseconds > 0) and (vStopWatch.ElapsedMilliseconds >= POP_TIMEOUT-ACCEPTABLE_TIMEOUTVARIANCE_MS) then
    begin
      //successful PopItem operation as we aren't adding anything into our queue
      Continue;
    end
    else
    begin
      LogIt('TTestThread ERROR: TThreadedQueue.PopItem returned [' + TRttiEnumerationType.GetName(vWaitResult) + '] unexpectedly after [' + IntToStr(vStopWatch.ElapsedMilliseconds) + 'ms]');
      pubTestCompletionCheck.SetEvent();
      Break;
    end;
  end;
end;

initialization
  pubTestCompletionCheck := TEvent.Create();
  pubSyncrhonizedStart := TEvent.Create();

finalization
  pubSyncrhonizedStart.Free();
  pubTestCompletionCheck.Free();

end.
