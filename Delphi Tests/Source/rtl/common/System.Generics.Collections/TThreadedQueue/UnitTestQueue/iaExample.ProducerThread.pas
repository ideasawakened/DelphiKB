unit iaExample.ProducerThread;

interface
uses
  System.Classes,
  System.Generics.Collections;

type
  TProducerState = (ProducerWorking,
                    ProducerDone,
                    ProducerAbortedWithException);

  TExampleLinkedProducerThread = class(TThread)
  private
    fTaskQueue:TThreadedQueue<TObject>;
    fQueueTimeout:Cardinal;
    fNumberOfTasksToProduce:Integer;
    fThreadState:TProducerState;
    fTasksProduced:Integer;
    fTasksOverflow:Integer;
    fQueueFailures:Integer;
  public
    constructor Create(const TaskQueue:TThreadedQueue<TObject>; const QueueTimeout:Cardinal; const NumberOfTasksToProduce:Integer);

    procedure Execute(); override;

    property ThreadState:TProducerState read fThreadState write fThreadState;
    property TasksProduced:Integer read fTasksProduced write fTasksProduced;
    property TasksOverflow:Integer read fTasksOverflow write fTasksOverflow;
    property QueueFailures:Integer read fQueueFailures write fQueueFailures;
  end;


implementation
uses
  System.SysUtils,
  System.SyncObjs,
  System.RTTI,
  iaExample.TaskData,
  iaTestSupport.Log;


constructor TExampleLinkedProducerThread.Create(const TaskQueue:TThreadedQueue<TObject>; const QueueTimeout:Cardinal; const NumberOfTasksToProduce:Integer);
begin
  self.FreeOnTerminate := False;
  fTaskQueue := TaskQueue;
  fQueueTimeout := QueueTimeout;
  fNumberOfTasksToProduce := NumberOfTasksToProduce;
  fThreadState := TProducerState.ProducerWorking;
  inherited Create({CreateSuspended=}False);
end;


procedure TExampleLinkedProducerThread.Execute();
var
  i:Integer;
  PushResult:TWaitResult;
  TaskItem:TExampleTaskData;
begin
  NameThreadForDebugging('ExampleLinkedProducer_' + FormatDateTime('hhnnss.zzzz', Now));
  try

    for i := 1 to fNumberOfTasksToProduce do
    begin
      TaskItem := TExampleTaskData.Create(i, IntToStr(i));
      PushResult := fTaskQueue.PushItem(TaskItem);
      if PushResult = TWaitResult.wrSignaled then
      begin
        Inc(fTasksProduced);
      end
      else
      begin
        if (PushResult = TWaitResult.wrTimeout) then
        begin
          if fQueueTimeout = INFINITE then
          begin
            //shouldn't get here
            LogIt('PushItem logic failure: Queue timeout was INFINITE but the Push resulted in Timeout');
            Inc(fQueueFailures);
          end
          else
          begin
            //Timeout was specified and the queue is full, keep producing
            //Normal code would likely be to keep trying to add item created to queue
            Inc(fTasksOverflow);
          end;
        end
        else
        begin
          LogIt('PushItem failed: ' + TRttiEnumerationType.GetName(PushResult));
          Inc(fQueueFailures);
        end;
        TaskItem.Free();
      end;
    end;

    fThreadState := TProducerState.ProducerDone;
  except on E:Exception do
    begin
      LogIt('Producer thread exception trapped: ' + E.Message);
      fThreadState := TProducerState.ProducerAbortedWithException;
    end;
  end;
end;

end.

