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
    constructor Create(const TaskQueue:TThreadedQueue<TObject>; const QueueTimeout:Cardinal);

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


constructor TExampleLinkedConsumerThread.Create(const TaskQueue:TThreadedQueue<TObject>; const QueueTimeout:Cardinal);
const
  CreateSuspendedParam = False;
begin
  self.FreeOnTerminate := False;
  fTaskQueue := TaskQueue;
  fQueueTimeout := QueueTimeout;
  inherited Create(CreateSuspendedParam);
end;


procedure TExampleLinkedConsumerThread.Execute();
var
  PopResult:TWaitResult;
  DataItem:TExampleTaskData;
begin
  NameThreadForDebugging('ExampleLinkedConsumer_' + FormatDateTime('hhnnss.zzzz', Now));
  try

    while (not self.Terminated) and (not fTaskQueue.ShutDown) do
    begin
      PopResult := fTaskQueue.PopItem(TObject(DataItem));
      if (PopResult = wrSignaled) then
      begin
        if Assigned(DataItem) then
        begin
          Inc(fTasksConsumed);
          DataItem.Free();
        end
        else if not fTaskQueue.ShutDown then
        begin
          LogIt('PopItem failed to return object');
          Int(fQueueFailures);
        end;
        //else: queue signal to shut down
      end
      else if (PopResult = wrTimeout) then
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
        LogIt('PopItem failed: ' + TRttiEnumerationType.GetName(PopResult));
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
