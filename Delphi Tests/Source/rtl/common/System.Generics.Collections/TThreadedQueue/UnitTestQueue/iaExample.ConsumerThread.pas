unit iaExample.ConsumerThread;

interface
uses
  System.Classes,
  System.Generics.Collections;

type
  TConsumerState = (ConsumerWorking,
                    ConsumerDone,
                    ConsumerAbortedWithException);

  TExampleLinkedConsumerThread = class(TThread)
  private
    fTaskQueue:TThreadedQueue<TObject>;
    fQueueTimeout:Cardinal;
    fThreadState:TConsumerState;
    fTasksConsumed:Integer;
    fTasksUnderflow:Integer;
    fQueueFailures:Integer;
  public
    constructor Create(const pTaskQueue:TThreadedQueue<TObject>; const pQueueTimeout:Cardinal);

    procedure Execute(); override;

    property ThreadState:TConsumerState read fThreadState write fThreadState;
    property TasksConsumed:Integer read fTasksConsumed write fTasksConsumed;
    property TasksUnderflow:Integer read fTasksUnderflow write fTasksUnderflow;
    property QueueFailures:Integer read fQueueFailures write fQueueFailures;
  end;


implementation
uses
  System.SysUtils,
  System.SyncObjs,
  System.RTTI,
  iaExample.TaskData,
  iaTestSupport.Log;


constructor TExampleLinkedConsumerThread.Create(const pTaskQueue:TThreadedQueue<TObject>; const pQueueTimeout:Cardinal);
const
  CreateSuspendedParam = False;
begin
  self.FreeOnTerminate := False;
  fTaskQueue := pTaskQueue;
  fQueueTimeout := pQueueTimeout;
  inherited Create(CreateSuspendedParam);
end;


procedure TExampleLinkedConsumerThread.Execute();
var
  vPopResult:TWaitResult;
  vDataItem:TExampleTaskData;
begin
  NameThreadForDebugging('ExampleLinkedConsumer_' + FormatDateTime('hhnnss.zzzz', Now));
  try

    while (not self.Terminated) and (not fTaskQueue.ShutDown) do
    begin
      vPopResult := fTaskQueue.PopItem(TObject(vDataItem));
      if (vPopResult = wrSignaled) then
      begin
        if Assigned(vDataItem) then
        begin
          Inc(fTasksConsumed);
          vDataItem.Free();
        end
        else if not fTaskQueue.ShutDown then
        begin
          LogIt('PopItem failed to return object');
          Int(fQueueFailures);
        end;
        //else: queue signal to shut down
      end
      else if (vPopResult = wrTimeout) then
      begin
        if fQueueTimeout = INFINITE then
        begin
          //shouldn't get here
          LogIt('PopItem logic failure: Queue timeout was INFINITE but the Pop resulted in Timeout');
          Inc(fQueueFailures);
        end
        else
        begin
          //queue caught up, keep consuming
          Inc(fTasksUnderflow);
        end;
      end
      else
      begin
        LogIt('PopItem failed: ' + TRttiEnumerationType.GetName(vPopResult));
        Inc(fQueueFailures);
      end;
    end;

    fThreadState := TConsumerState.ConsumerDone;
  except on E:Exception do
    begin
      LogIt('Consumer thread exception trapped: ' + E.Message);
      fThreadState := TConsumerState.ConsumerAbortedWithException;
    end;
  end;
end;


end.
