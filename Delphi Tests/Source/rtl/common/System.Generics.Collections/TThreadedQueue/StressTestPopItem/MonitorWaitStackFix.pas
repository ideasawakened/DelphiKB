unit MonitorWaitStackFix;
{
  Fixes TMonitor event stack
  See https://en.delphipraxis.net/topic/2824-revisiting-tthreadedqueue-and-tmonitor/
  for discussion.
}
{$DEFINE DEBUG_OUTPUT}
{$DEFINE DEBUG_CONSOLEWRITE}
interface
{$IFDEF DEBUG_CONSOLEWRITE}
Uses
  System.SyncObjs;
{$ENDIF DEBUG_CONSOLEWRITE}

{$IFDEF DEBUG_CONSOLEWRITE}
var
  ConsoleWriteLock: TSpinLock;
{$ENDIF DEBUG_CONSOLEWRITE}

implementation
uses
  WinApi.Windows,
  System.SysUtils;


{$IFDEF DEBUG_OUTPUT}
procedure DebugWrite(S: String);
begin
  {$IFDEF DEBUG_CONSOLEWRITE}
  ConsoleWriteLock.Enter;
  try
    WriteLn(S);
  finally
    ConsoleWriteLock.Exit;
  end;
  {$ELSE DEBUG_CONSOLEWRITE}
  OutputDebugString(PChar(S));
  {$ENDIF DEBUG_CONSOLEWRITE}
end;
{$ENDIF DEBUG_OUTPUT}


{====================== Patched TMonitorSupport below =========================}
{ This section provides the required support to the TMonitor record in System. }
type
  PEventItemHolder = ^TEventItemHolder;
  TEventItemHolder = record
    Next: PEventItemHolder;
    Event: Pointer;
  end align {$IFDEF CPUX64}16{$ELSE CPUX64}8{$ENDIF CPUX64};

  TEventStack = record
    Head: PEventItemHolder;
    Counter: NativeInt;
    procedure Push(EventItem: PEventItemHolder);
    function Pop: PEventItemHolder;
  end align {$IFDEF CPUX64}16{$ELSE CPUX64}8{$ENDIF CPUX64};


// taken from OmniThreadLibrary and adapted.
// either 8-byte or 16-byte CAS, depending on the platform;
// destination must be propely aligned (8- or 16-byte)
//function CAS(const oldData: pointer; oldReference: NativeInt; newData: pointer;
//  newReference: NativeInt; var destination): boolean;
//asm
//{$IFNDEF CPUX64}
//  push  edi
//  push  ebx
//  mov   ebx, newData
//  mov   ecx, newReference
//  mov   edi, destination
//  lock cmpxchg8b qword ptr [edi]
//  pop   ebx
//  pop   edi
//{$ELSE CPUX64}
//  .pushnv rbx
//  mov   rax, oldData
//  mov   rbx, newData
//  mov   rcx, newReference
//  mov   r8, [destination]
//  lock cmpxchg16b [r8]
//{$ENDIF CPUX64}
//  setz  al
//end; { CAS }

// Delphi's InterlockedCompareExchange128 is broken
{$IFDEF Win64}
function InterlockedCompareExchange128(Destination: Pointer; ExchangeHigh, ExchangeLow: Int64; ComparandResult: Pointer): boolean;
// The parameters are in the RCX, RDX, R8 and R9 registers per the MS x64 calling convention:
//   RCX        Destination
//   RDX        ExchangeHigh
//   R8         ExchangeLow
//   R9         ComparandResult
//
// CMPXCHG16B requires the following register setup:
//   RDX:RAX    ComparandResult.High:ComparandResult.Low
//   RCX:RBX    ExchangeHigh:ExchangeLow
// See: https://www.felixcloutier.com/x86/cmpxchg8b:cmpxchg16b
asm
      .PUSHNV RBX
      MOV   R10,Destination             // RCX
      MOV   RBX,ExchangeLow             // R8
      MOV   RCX,ExchangeHigh            // RDX
      MOV   RDX,[ComparandResult+8]     // R9
      MOV   RAX,[ComparandResult]       // R9
 LOCK CMPXCHG16B [R10]
      MOV   [ComparandResult+8],RDX     // R9
      MOV   [ComparandResult],RAX       // R9
      SETZ  AL
 end;
{$ENDIF Win64}

function InterlockedCompareExchange(var Dest: TEventStack; const NewValue, CurrentValue: TEventStack): Boolean;
begin
  //Result := CAS(CurrentValue.Head, CurrentValue.Counter, NewValue.Head, NewValue.Counter, Dest);
  {$IFDEF CPUX64}
  Result := InterlockedCompareExchange128(@Dest, NewValue.Counter, Int64(NewValue.Head), @CurrentValue);
  {$ELSE CPUX64}
  Result := InterlockedCompareExchange64(Int64(Dest), Int64(NewValue), Int64(CurrentValue)) = Int64(CurrentValue);
  {$ENDIF CPUX64}
end;

procedure TEventStack.Push(EventItem: PEventItemHolder);
var
  Current, Next: TEventStack;
begin
  repeat
    Current := Self;
    EventItem.Next := Current.Head;
    Next.Head := EventItem;
    Next.Counter := Current.Counter + 1;
  until InterlockedCompareExchange(Self, Next, Current);
end;

function TEventStack.Pop: PEventItemHolder;
var
  Current, Next: TEventStack;
begin
  repeat
    Current := Self;
    if (Current.Head = nil) then
      Exit(nil);
    Next.Head := Current.Head.Next;
    Next.Counter := Current.Counter + 1;
  until InterlockedCompareExchange(Self, Next, Current);
  Result := Current.Head;
end;

var
  EventCache: TEventStack = (Head: nil; Counter: 0);
  EventItemHolders: TEventStack = (Head: nil; Counter: 0);
{$IFDEF DEBUG_OUTPUT}
  NewWaitObjCount: NativeUInt = 0;
{$ENDIF DEBUG_OUTPUT}

function NewWaitObj: Pointer;
var
  EventItem: PEventItemHolder;
begin
  {$IFDEF DEBUG_OUTPUT}
  AtomicIncrement(NewWaitObjCount);
  if NewWaitObjCount mod 100000 = 0 then
    DebugWrite(Format('New Wait objects created: %d', [NewWaitObjCount]));
  {$ENDIF DEBUG_OUTPUT}
  EventItem := EventCache.Pop;
  if EventItem <> nil then
  begin
    {$IFDEF DEBUG_OUTPUT}
    if EventItem.Event = nil then
      DebugWrite('NewWaitObj EventItem.Event is nil');
    {$ENDIF DEBUG_OUTPUT}
    Result := EventItem.Event;
    EventItem.Event := nil;
    EventItemHolders.Push(EventItem);
  end else begin
    Result := Pointer(CreateEvent(nil, False, False, nil));
    {$IFDEF DEBUG_OUTPUT}
    if not Assigned(Result) Then
      DebugWrite('NewWaitObj CreateEvent failure');
    {$ENDIF DEBUG_OUTPUT}
end;
  {$IFDEF DEBUG_OUTPUT}
  if not ResetEvent(THandle(Result))then
    DebugWrite('ResetEvent returned false');
  {$ELSE DEBUG_OUTPUT}
  ResetEvent(THandle(Result)
  {$ENDIF DEBUG_OUTPUT}
end;

procedure FreeWaitObj(WaitObject: Pointer);
var
  EventItem: PEventItemHolder;
begin
  EventItem := EventItemHolders.Pop;
  if EventItem = nil then
    New(EventItem);
  EventItem.Event := WaitObject;
  {$IFDEF DEBUG_OUTPUT}
  if not Assigned(EventItem.Event) then
    DebugWrite('FreeWaitObj WaitObject is nil');
  {$ENDIF DEBUG_OUTPUT}
  EventCache.Push(EventItem);
end;

procedure CleanStack(Stack: PEventItemHolder);
var
  Walker: PEventItemHolder;
begin
  Walker := Stack;
  while Walker <> nil do
  begin
    Stack := Walker.Next;
    if Walker.Event <> nil then
      CloseHandle(THandle(Walker.Event));
    Dispose(Walker);
    Walker := Stack;
  end;
end;

function WaitOrSignalObj(SignalObject, WaitObject: Pointer; Timeout: Cardinal): Cardinal;
begin
  if (SignalObject <> nil) and (WaitObject = nil) then
  begin
    Result := 0;
    SetEvent(THandle(SignalObject));
  end else if (WaitObject <> nil) and (SignalObject = nil) then begin
    Result := WaitForSingleObject(THandle(WaitObject), Timeout);
    {$IFDEF DEBUG_OUTPUT}
    if (Result <> WAIT_TIMEOUT) and (Result <> WAIT_OBJECT_0) then
      DebugWrite('WaitOrSignalObj returned: ' + Result.ToString );
    {$ENDIF DEBUG_OUTPUT}
  end
  else
    Result := 1;
end;

initialization
  {$IFDEF DEBUG_CONSOLEWRITE}
  ConsoleWriteLock := TSpinLock.Create(True);
  {$ENDIF DEBUG_CONSOLEWRITE}
  System.MonitorSupport.NewWaitObject := NewWaitObj;
  System.MonitorSupport.FreeWaitObject := FreeWaitObj;
  System.MonitorSupport.WaitOrSignalObject := WaitOrSignalObj;
finalization
  CleanStack(AtomicExchange(Pointer(EventCache.Head), nil));
  CleanStack(AtomicExchange(Pointer(EventItemHolders.Head), nil));
end.
