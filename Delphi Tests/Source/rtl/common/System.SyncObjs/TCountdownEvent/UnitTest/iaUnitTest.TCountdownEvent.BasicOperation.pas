unit iaUnitTest.TCountdownEvent.BasicOperation;

interface
uses
  DUnitX.TestFramework,
  System.SyncObjs;

type

  [TestFixture]
  TiaTestTCountdownEventBasicOperation = class(TObject)
  public
    [Test]
    procedure InitialZeroCount_IsImmediatelySignaled();
    [Test]
    procedure InitialZeroCount_ResetToZeroSignals();
    [Test]
    procedure InitialZeroCount_ResetGreaterThanZeroNotSignaled();


    [Test]
    procedure InitialNegativeCount_ExceptionOnCreate();


    [Test]
    procedure EventCountOverMaxInt_Exception();


    [Test]
    procedure TryAddZero_Exception();
    [Test]
    procedure TryAddNegative_Exception();


    [Test]
    procedure ResetNegative_Exception();


    [Test]
    procedure ResetChangesBothInitialAndCurrentCount();


    [Test]
    procedure ZeroCount_TryAddFails();
    [Test]
    procedure ZeroCount_ExceptionOnAddCount();
    [Test]
    procedure ZeroCount_ExceptionOnSignal();


    [Test]
    procedure SignalDefaultAmountIsOneCount();


    [Test]
    procedure AddChangesCurrentCountButNotInitialCount();


    //procedure SignalDefault_ZeroInitialCount = ZeroCount_ExceptionOnSignal
    [Test]
    procedure SignalDefault_OneInitialCountReturnsTrue();
    [Test]
    procedure SignalDefault_MoreThanOneInitialCountReturnsFalse();
    [Test]
    procedure SignalOne_OneInitalCountReturnsTrue();
    [Test]
    procedure SignalOne_MoreThanOneIntialCountReturnsFalse();
    [Test]
    procedure SignalTwo_TwoInitalCountReturnsTrue();
    [Test]
    procedure SignalTwo_MoreThanTwoIntialCountReturnsFalse();


    [Test]
    procedure SignalGreaterThanCount_Exception();


    [Test]
    [TestCase('Created with 0 Count','0')]
    [TestCase('Created with 1 Count','1')]
    [TestCase('Created with 2 Count','2')]
    [TestCase('Created with 3 Count','3')]
    [TestCase('Created with 1000 Count','1000')]
    [TestCase('Created with MaxInt-1 Count','2147483646')]
    [TestCase('Created with MaxInt Count','2147483647')]
    procedure CountsMatchCreatedAmount(const pCreateCount:Integer);
  end;

implementation
uses
  System.SysUtils,
  System.Classes;


procedure TiaTestTCountdownEventBasicOperation.InitialZeroCount_IsImmediatelySignaled();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(0);
  try
    Assert.IsTrue(obj.IsSet, 'Creating object with 0 count should be immediately signaled');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.InitialZeroCount_ResetToZeroSignals();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(0);
  try
    //variation 1: No argument passed, should use InitialCount
    obj.Reset;
    Assert.IsTrue(obj.IsSet, 'Resetting object with no argument and 0 initial count should be signaled');

    //variation 2: Explicit count of 0 passed on reset
    obj.Reset(0);
    Assert.IsTrue(obj.IsSet, 'Resetting object with 0 new count should be signaled');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.InitialZeroCount_ResetGreaterThanZeroNotSignaled();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(0);
  try
    //variation 1: after creation with 0 count
    obj.Reset(1);
    Assert.IsFalse(obj.IsSet, 'Resetting object initially created with 0 but reset above 0 should not be be signaled');

    obj.Reset(0);
    Assert.IsTrue(obj.IsSet, 'Resetting object with 0 new count should be signaled');

    //variation 2: after reset to 0 count
    obj.Reset(1);
    Assert.IsFalse(obj.IsSet, 'Resetting object reset to 0 and reset > 0 should not be be signaled');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.ResetChangesBothInitialAndCurrentCount();
const
  INITIAL_COUNT = 0;
  NEW_COUNT = INITIAL_COUNT + 1;
var
  obj:TCountdownEvent;

begin
  obj := TCountdownEvent.Create(INITIAL_COUNT);
  try
    obj.Reset(NEW_COUNT);
    Assert.AreEqual(obj.InitialCount, NEW_COUNT, 'Resetting count should change initial count');
    Assert.AreEqual(obj.CurrentCount, NEW_COUNT, 'Resetting count should change current count');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.ZeroCount_TryAddFails();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(0);
  try
    //variant 1: Default (1)
    Assert.IsFalse(obj.TryAddCount(), 'TryAddCount() when count is zero should fail');
    //variant 2: Explict 1
    Assert.IsFalse(obj.TryAddCount(1), 'TryAddCount(1) when count is zero should fail');
    //variant 3: Explicit > 1
    Assert.IsFalse(obj.TryAddCount(2), 'TryAddCount(2) when count is zero should fail');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.ZeroCount_ExceptionOnAddCount();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(0);
  try
    Assert.WillRaise(procedure
                     begin
                        obj.AddCount(1);
                     end,
                     EInvalidOperation, 'AddCount when count is zero should raise an exception');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.ZeroCount_ExceptionOnSignal();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(0);
  try
    Assert.WillRaise(procedure
                     begin
                        obj.Signal;
                     end,
                     EInvalidOperation, 'Signal when count is zero should raise an exception');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.InitialNegativeCount_ExceptionOnCreate();
begin
  Assert.WillRaise(procedure
                   begin
                      TCountdownEvent.Create(-1);
                   end,
                   EArgumentOutOfRangeException, 'Negative initial count should raise an exception');
end;


procedure TiaTestTCountdownEventBasicOperation.EventCountOverMaxInt_Exception();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(MaxInt);
  try
    //variant 1: Add a small amount to a large amount, total > MaxInt
    Assert.WillRaise(procedure
                     begin
                        obj.TryAddCount(1);
                     end,
                     EInvalidOperation, 'TryAddCount(1) pushing total count above MaxInt should raise an exception');

    //variant 2: Add a large amount to a small amount, total > MaxInt
    obj.Reset(1);
    Assert.WillRaise(procedure
                     begin
                        obj.TryAddCount(MaxInt);
                     end,
                     EInvalidOperation, 'TryAddCount(MaxInt) pushing total count above MaxInt should raise an exception');

  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.TryAddZero_Exception();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    Assert.WillRaise(procedure
                     begin
                        obj.TryAddCount(0);
                     end,
                     EArgumentOutOfRangeException, 'TryAddCount(0) should raise an exception');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.TryAddNegative_Exception();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    Assert.WillRaise(procedure
                     begin
                        obj.TryAddCount(-1);
                     end,
                     EArgumentOutOfRangeException, 'TryAddCount(negative count) should raise an exception');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.ResetNegative_Exception();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    Assert.WillRaise(procedure
                     begin
                        obj.Reset(-1);
                     end,
                     EArgumentOutOfRangeException, 'Reset(negative count) should raise an exception');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalDefaultAmountIsOneCount();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    obj.Signal;
    Assert.AreEqual(obj.CurrentCount, 1, 'Using Signal without a parameter should be a count of one');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.AddChangesCurrentCountButNotInitialCount();
const
  INITIAL_COUNT = 1;
  ADD_COUNT = 1;
var
  obj:TCountdownEvent;
  vCurrentCountBeforeAdd:Integer;
begin
  obj := TCountdownEvent.Create(INITIAL_COUNT);
  try
    vCurrentCountBeforeAdd := obj.CurrentCount;
    obj.AddCount(ADD_COUNT);

    Assert.AreEqual(obj.CurrentCount, vCurrentCountBeforeAdd + ADD_COUNT, 'Adding should reset current count');
    Assert.AreEqual(obj.InitialCount, INITIAL_COUNT, 'Adding should not change initial count');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalDefault_OneInitialCountReturnsTrue();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(1);
  try
    //variant 1: Signal with known creation count
    Assert.IsTrue(obj.Signal, 'When count reaches zero immediately after creation of count 1, Signal should return true');

    //variant 2: Signal with known reset count
    obj.Reset(1);
    Assert.IsTrue(obj.Signal, 'When count reaches zero immediately after reset with count 1, Signal should return true');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalDefault_MoreThanOneInitialCountReturnsFalse();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    //variant 1: Signal with known creation count
    Assert.IsFalse(obj.Signal, 'When initial creation count above 1, Signal should return false');

    //variant 2: Signal with known reset count
    obj.Reset(2);
    Assert.IsFalse(obj.Signal, 'When reset count above 1, Signal should return false');
  finally
    obj.Free();
  end;
end;



procedure TiaTestTCountdownEventBasicOperation.SignalOne_OneInitalCountReturnsTrue();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(1);
  try
    //variant 1: Signal with known creation count
    Assert.IsTrue(obj.Signal(1), 'When count reaches zero immediately after creation of count 1, Signal should return true');

    //variant 2: Signal with known reset count
    obj.Reset(1);
    Assert.IsTrue(obj.Signal(1), 'When count reaches zero immediately after reset with count 1, Signal should return true');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalOne_MoreThanOneIntialCountReturnsFalse();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    //variant 1: Signal with known creation count
    Assert.IsFalse(obj.Signal(1), 'When initial creation count above 1, Signal should return false');

    //variant 2: Signal with known reset count
    obj.Reset(2);
    Assert.IsFalse(obj.Signal(1), 'When reset count above 1, Signal should return false');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalTwo_TwoInitalCountReturnsTrue();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(2);
  try
    //variant 1: Signal with known creation count
    Assert.IsTrue(obj.Signal(2), 'When count reaches zero immediately after creation of count 2, Signal(2) should return true');

    //variant 2: Signal with known reset count
    obj.Reset(2);
    Assert.IsTrue(obj.Signal(2), 'When count reaches zero immediately after reset with count 2, Signal(2) should return true');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalTwo_MoreThanTwoIntialCountReturnsFalse();
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(3);
  try
    //variant 1: Signal with known creation count
    Assert.IsFalse(obj.Signal(2), 'When initial creation count above 2, Signal(2) should return false');

    //variant 2: Signal with known reset count
    obj.Reset(3);
    Assert.IsFalse(obj.Signal(2), 'When reset count above 2, Signal(2) should return false');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.SignalGreaterThanCount_Exception();
const
  SIGNALCOUNT = 2;
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(SIGNALCOUNT);
  try
    Assert.WillRaise(procedure
                     begin
                        obj.Signal(SIGNALCOUNT+1);
                     end,
                     EInvalidOperation, 'Signaling more than current count should raise an exception');
  finally
    obj.Free();
  end;
end;


procedure TiaTestTCountdownEventBasicOperation.CountsMatchCreatedAmount(const pCreateCount:Integer);
var
  obj:TCountdownEvent;
begin
  obj := TCountdownEvent.Create(pCreateCount);
  try
    Assert.AreEqual(pCreateCount, obj.InitialCount, 'When created, Initial count should match created count');
    Assert.AreEqual(pCreateCount, obj.CurrentCount, 'When created, Current count should match created count');
  finally
    obj.Free();
  end;
end;


end.
