//Initially created 2024-12-30 for: https://stackoverflow.com/questions/79318289/implement-multithreading-with-a-queue-in-delphi-to-limit-to-n-threads-running-si
unit Unit1;

interface

uses
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  System.Classes,
  System.Generics.Collections;

type

  TMyRecord = record
    id:Integer;
    msg:string;
    sleep:Integer;
  end;

  TMyRecConsumerThread = class(TThread)
  private
    fQueue:TThreadedQueue<TMyRecord>;
    fThreadNumber:Integer;
  public
    constructor Create(const Queue:TThreadedQueue<TMyRecord>; const ThreadNumber:Integer);

    procedure Execute(); override;
  end;


  TMainForm = class(TForm)
    Memo1:TMemo;
    butProduce:TButton;
    procedure butProduceClick(Sender:TObject);
    procedure FormCreate(Sender:TObject);
    procedure FormDestroy(Sender:TObject);
  private const
    ConsumerThreadCount = 2;

    QueueDepth = 100;
    ProduceCount = 5;
    PushTimeout = 500;
    PopTimeout = 3000;
  private
    fQueue:TThreadedQueue<TMyRecord>;
    fRecId:Integer;
    fConsumers:TArray<TMyRecConsumerThread>;
    function CreateWorkItem:TMyRecord;
  end;

var
  MainForm:TMainForm;

implementation

uses
  System.SysUtils,
  System.SyncObjs;

{$R *.dfm}


procedure TMainForm.FormCreate(Sender:TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  fRecId := 1;
  butProduce.Caption := Format('Produce %d records', [ProduceCount]);

  fQueue := TThreadedQueue<TMyRecord>.Create(QueueDepth, PushTimeout, PopTimeout);

  SetLength(fConsumers, ConsumerThreadCount);
  for var i := 1 to ConsumerThreadCount do
  begin
    fConsumers[i-1] := TMyRecConsumerThread.Create(fQueue, i);
  end;
end;


procedure TMainForm.FormDestroy(Sender:TObject);
begin
  for var ConsumerThread in fConsumers do
  begin
    ConsumerThread.Free;
  end;
  fQueue.DoShutDown;
  fQueue.Free;
end;


function TMainForm.CreateWorkItem:TMyRecord;
begin
  Result := Default(TMyRecord);
  Result.id := fRecId;
  Result.sleep := Random(PopTimeout div 2);
  Result.msg := Format('Task %d sleeping %dms', [fRecId, Result.sleep]);

  Memo1.Lines.Add(Format('Produced Task %d to sleep %dms', [fRecId, Result.sleep]));
  Inc(fRecId); // if threaded producer: InterlockedIncrement(fRecId);
end;


//click the button one or more times to queue up some work items
procedure TMainForm.butProduceClick(Sender:TObject);
var
  wr:TWaitResult;
begin
  for var i := 1 to ProduceCount do
  begin
    wr := fQueue.PushItem(CreateWorkItem);
    Assert(wr = TWaitResult.wrSignaled);  // IRL deal with <> wrSignaled (e.g., timeout if queue is full)
  end;
end;


constructor TMyRecConsumerThread.Create(const Queue:TThreadedQueue<TMyRecord>; const ThreadNumber:Integer);
begin
  fQueue := Queue;
  fThreadNumber := ThreadNumber;
  inherited Create({CreateSuspended=}False);
end;


procedure TMyRecConsumerThread.Execute;
var
  wr:TWaitResult;
  r:TMyRecord;
begin
  NameThreadForDebugging(Format('Consumer%d', [fThreadNumber]));

  while (not Terminated) and (not fQueue.ShutDown) do
  begin
    wr := fQueue.PopItem(r);
    if (wr = wrSignaled) then
    begin
      if r.id > 0 then //Note: if 0, then PopItem was signalled as Queue was told to shut down (rec will be "Default(TMyRecord)")
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            MainForm.Memo1.Lines.Add(Format('Consumed %s', [r.msg]));
          end);
        sleep(r.sleep); //would be better to have an abortable sleep using an TEvent
      end;
    end;
  end;
end;


end.
