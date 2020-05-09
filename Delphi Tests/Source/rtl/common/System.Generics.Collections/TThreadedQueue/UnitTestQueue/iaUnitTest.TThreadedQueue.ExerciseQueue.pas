unit iaUnitTest.TThreadedQueue.ExerciseQueue;

interface
uses
  DUnitX.TestFramework,
  System.Generics.Collections,
  iaExample.ProducerThread,
  iaExample.ConsumerThread;


type

  [TestFixture]
  TiaTestMultiThreadedProducerAndConsumer = class(TObject)
  private
    fConsumers:Array of TExampleLinkedConsumerThread;
    fProducers:Array of TExampleLinkedProducerThread;
    fTasksConsumed:Integer;
    fTasksUnderflow:Integer;
    fTasksProduced:Integer;
    fTasksOverflow:Integer;
    fQueueProducerFailures:Integer;
    fQueueConsumerFailures:Integer;
  protected
    procedure CreateConsumers(const pConsumerThreadCount:Integer; const pTaskQueue:TThreadedQueue<TObject>; const pPopTimeout:Cardinal);
    procedure CreateProducers(const pProducerThreadCount:Integer; const pTaskQueue:TThreadedQueue<TObject>; const pPushTimeout:Cardinal; const pTaskCount:Integer);
    procedure FreeConsumers();
    procedure FreeProducers();
  public
    [Test]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1,0,0,1,1,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1,0,0,1,1,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1,0,0,1,1,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1,0,0,1,1,100000')]

    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1,0,0,2,2,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1,0,0,2,2,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1,0,0,2,2,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1,0,0,2,2,100000')]

    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1,0,0,40,40,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1,0,0,40,40,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1,0,0,40,40,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1,0,0,40,40,100000')]

    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1,0,0,1,40,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1,0,0,1,40,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1,0,0,1,40,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1,0,0,1,40,100000')]

    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1,0,0,2,40,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1,0,0,2,40,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1,0,0,2,40,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1,0,0,2,40,100000')]

    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1,0,0,40,1,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1,0,0,40,1,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1,0,0,40,1,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1,0,0,40,1,100000')]

    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1,0,0,40,2,1')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1,0,0,40,2,2')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1,0,0,40,2,3')]
    [TestCase('1 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1,0,0,40,2,100000')]


    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1,1,1,1,1,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1,1,1,1,1,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1,1,1,1,1,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1,1,1,1,1,100000')]

    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1,1,1,2,2,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1,1,1,2,2,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1,1,1,2,2,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1,1,1,2,2,100000')]

    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1,1,1,40,40,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1,1,1,40,40,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1,1,1,40,40,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1,1,1,40,40,100000')]

    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1,1,1,1,40,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1,1,1,1,40,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1,1,1,1,40,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1,1,1,1,40,100000')]

    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1,1,1,2,40,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1,1,1,2,40,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1,1,1,2,40,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1,1,1,2,40,100000')]

    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1,1,1,40,1,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1,1,1,40,1,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1,1,1,40,1,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1,1,1,40,1,100000')]

    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1,1,1,40,2,1')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1,1,1,40,2,2')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1,1,1,40,2,3')]
    [TestCase('1 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1,1,1,40,2,100000')]


    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1,1000,1000,1,1,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1,1000,1000,1,1,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1,1000,1000,1,1,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1,1000,1000,1,1,100000')]

    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1,1000,1000,2,2,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1,1000,1000,2,2,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1,1000,1000,2,2,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1,1000,1000,2,2,100000')]

    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1,1000,1000,40,40,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1,1000,1000,40,40,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1,1000,1000,40,40,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1,1000,1000,40,40,100000')]

    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1,1000,1000,1,40,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1,1000,1000,1,40,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1,1000,1000,1,40,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1,1000,1000,1,40,100000')]

    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1,1000,1000,2,40,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1,1000,1000,2,40,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1,1000,1000,2,40,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1,1000,1000,2,40,100000')]

    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1,1000,1000,40,1,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1,1000,1000,40,1,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1,1000,1000,40,1,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1,1000,1000,40,1,100000')]

    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1,1000,1000,40,2,1')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1,1000,1000,40,2,2')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1,1000,1000,40,2,3')]
    [TestCase('1 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1,1000,1000,40,2,100000')]


    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,1,1,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,1,1,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,1,1,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,1,1,100000')]

    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,2,2,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,2,2,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,2,2,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,2,2,100000')]

    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,40,40,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,40,40,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,40,40,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,40,40,100000')]

    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,1,40,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,1,40,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,1,40,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,1,40,100000')]

    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,2,40,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,2,40,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,2,40,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,2,40,100000')]

    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,40,1,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,40,1,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,40,1,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,40,1,100000')]

    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1,$FFFFFFFF,$FFFFFFFF,40,2,1')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1,$FFFFFFFF,$FFFFFFFF,40,2,2')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1,$FFFFFFFF,$FFFFFFFF,40,2,3')]
    [TestCase('1 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1,$FFFFFFFF,$FFFFFFFF,40,2,100000')]



    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','10,0,0,1,1,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','10,0,0,1,1,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','10,0,0,1,1,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','10,0,0,1,1,100000')]

    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','10,0,0,2,2,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','10,0,0,2,2,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','10,0,0,2,2,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','10,0,0,2,2,100000')]

    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','10,0,0,40,40,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','10,0,0,40,40,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','10,0,0,40,40,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','10,0,0,40,40,100000')]

    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','10,0,0,1,40,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','10,0,0,1,40,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','10,0,0,1,40,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','10,0,0,1,40,100000')]

    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','10,0,0,2,40,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','10,0,0,2,40,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','10,0,0,2,40,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','10,0,0,2,40,100000')]

    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','10,0,0,40,1,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','10,0,0,40,1,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','10,0,0,40,1,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','10,0,0,40,1,100000')]

    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','10,0,0,40,2,1')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','10,0,0,40,2,2')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','10,0,0,40,2,3')]
    [TestCase('10 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','10,0,0,40,2,100000')]


    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','10,1,1,1,1,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','10,1,1,1,1,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','10,1,1,1,1,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','10,1,1,1,1,100000')]

    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','10,1,1,2,2,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','10,1,1,2,2,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','10,1,1,2,2,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','10,1,1,2,2,100000')]

    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','10,1,1,40,40,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','10,1,1,40,40,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','10,1,1,40,40,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','10,1,1,40,40,100000')]

    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','10,1,1,1,40,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','10,1,1,1,40,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','10,1,1,1,40,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','10,1,1,1,40,100000')]

    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','10,1,1,2,40,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','10,1,1,2,40,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','10,1,1,2,40,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','10,1,1,2,40,100000')]

    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','10,1,1,40,1,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','10,1,1,40,1,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','10,1,1,40,1,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','10,1,1,40,1,100000')]

    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','10,1,1,40,2,1')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','10,1,1,40,2,2')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','10,1,1,40,2,3')]
    [TestCase('10 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','10,1,1,40,2,100000')]


    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','10,1000,1000,1,1,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','10,1000,1000,1,1,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','10,1000,1000,1,1,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','10,1000,1000,1,1,100000')]

    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','10,1000,1000,2,2,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','10,1000,1000,2,2,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','10,1000,1000,2,2,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','10,1000,1000,2,2,100000')]

    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','10,1000,1000,40,40,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','10,1000,1000,40,40,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','10,1000,1000,40,40,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','10,1000,1000,40,40,100000')]

    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','10,1000,1000,1,40,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','10,1000,1000,1,40,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','10,1000,1000,1,40,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','10,1000,1000,1,40,100000')]

    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','10,1000,1000,2,40,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','10,1000,1000,2,40,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','10,1000,1000,2,40,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','10,1000,1000,2,40,100000')]

    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','10,1000,1000,40,1,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','10,1000,1000,40,1,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','10,1000,1000,40,1,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','10,1000,1000,40,1,100000')]

    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','10,1000,1000,40,2,1')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','10,1000,1000,40,2,2')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','10,1000,1000,40,2,3')]
    [TestCase('10 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','10,1000,1000,40,2,100000')]


    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,1,1,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,1,1,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,1,1,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,1,1,100000')]

    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,2,2,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,2,2,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,2,2,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,2,2,100000')]

    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,40,40,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,40,40,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,40,40,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,40,40,100000')]

    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,1,40,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,1,40,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,1,40,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,1,40,100000')]

    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,2,40,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,2,40,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,2,40,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,2,40,100000')]

    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,40,1,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,40,1,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,40,1,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,40,1,100000')]

    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','10,$FFFFFFFF,$FFFFFFFF,40,2,1')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','10,$FFFFFFFF,$FFFFFFFF,40,2,2')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','10,$FFFFFFFF,$FFFFFFFF,40,2,3')]
    [TestCase('10 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','10,$FFFFFFFF,$FFFFFFFF,40,2,100000')]



    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1000,0,0,1,1,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1000,0,0,1,1,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1000,0,0,1,1,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1000,0,0,1,1,100000')]

    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1000,0,0,2,2,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1000,0,0,2,2,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1000,0,0,2,2,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1000,0,0,2,2,100000')]

    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1000,0,0,40,40,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1000,0,0,40,40,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1000,0,0,40,40,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1000,0,0,40,40,100000')]

    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1000,0,0,1,40,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1000,0,0,1,40,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1000,0,0,1,40,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1000,0,0,1,40,100000')]

    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1000,0,0,2,40,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1000,0,0,2,40,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1000,0,0,2,40,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1000,0,0,2,40,100000')]

    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1000,0,0,40,1,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1000,0,0,40,1,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1000,0,0,40,1,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1000,0,0,40,1,100000')]

    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1000,0,0,40,2,1')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1000,0,0,40,2,2')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1000,0,0,40,2,3')]
    [TestCase('1000 Depth, Zero Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1000,0,0,40,2,100000')]


    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1000,1,1,1,1,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1000,1,1,1,1,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1000,1,1,1,1,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1000,1,1,1,1,100000')]

    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1000,1,1,2,2,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1000,1,1,2,2,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1000,1,1,2,2,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1000,1,1,2,2,100000')]

    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1000,1,1,40,40,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1000,1,1,40,40,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1000,1,1,40,40,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1000,1,1,40,40,100000')]

    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1000,1,1,1,40,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1000,1,1,1,40,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1000,1,1,1,40,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1000,1,1,1,40,100000')]

    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1000,1,1,2,40,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1000,1,1,2,40,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1000,1,1,2,40,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1000,1,1,2,40,100000')]

    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1000,1,1,40,1,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1000,1,1,40,1,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1000,1,1,40,1,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1000,1,1,40,1,100000')]

    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1000,1,1,40,2,1')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1000,1,1,40,2,2')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1000,1,1,40,2,3')]
    [TestCase('1000 Depth, 1 Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1000,1,1,40,2,100000')]


    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1000,1000,0,1,1,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1000,1000,0,1,1,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1000,1000,0,1,1,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1000,1000,0,1,1,100000')]

    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1000,1000,0,2,2,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1000,1000,0,2,2,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1000,1000,0,2,2,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1000,1000,0,2,2,100000')]

    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1000,1000,0,40,40,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1000,1000,0,40,40,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1000,1000,0,40,40,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1000,1000,0,40,40,100000')]

    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1000,1000,0,1,40,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1000,1000,0,1,40,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1000,1000,0,1,40,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1000,1000,0,1,40,100000')]

    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1000,1000,0,2,40,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1000,1000,0,2,40,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1000,1000,0,2,40,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1000,1000,0,2,40,100000')]

    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1000,1000,0,40,1,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1000,1000,0,40,1,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1000,1000,0,40,1,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1000,1000,0,40,1,100000')]

    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1000,1000,0,40,2,1')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1000,1000,0,40,2,2')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1000,1000,0,40,2,3')]
    [TestCase('1000 Depth, 1000 Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1000,1000,0,40,2,100000')]


    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,1,1,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,1,1,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,1,1,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer/Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,1,1,100000')]

    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,2,2,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,2,2,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,2,2,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer/Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,2,2,100000')]

    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,40,40,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,40,40,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,40,40,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer/Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,40,40,100000')]

    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,1,40,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,1,40,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,1,40,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 1 Consumer 40 Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,1,40,100000')]

    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,2,40,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,2,40,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,2,40,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 2 Consumer 40 Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,2,40,100000')]

    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,40,1,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,40,1,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,40,1,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 1 Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,40,1,100000')]

    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      1 Task','1000,$FFFFFFFF,$FFFFFFFF,40,2,1')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      2 Task','1000,$FFFFFFFF,$FFFFFFFF,40,2,2')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread,      3 Task','1000,$FFFFFFFF,$FFFFFFFF,40,2,3')]
    [TestCase('1000 Depth, Infinite Push/Pop Timeout, 40 Consumer 2 Producer Thread, 100000 Task','1000,$FFFFFFFF,$FFFFFFFF,40,2,100000')]


    procedure ExerciseQueue(const pQueueDepth:Integer; const pPushTimeout, pPopTimeout:Cardinal; const pConsumerThreadCount, pProducerThreadCount, pTaskCount:Integer);
  end;

implementation
uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  iaTestSupport.Log;

procedure TiaTestMultiThreadedProducerAndConsumer.ExerciseQueue(const pQueueDepth:Integer; const pPushTimeout, pPopTimeout:Cardinal; const pConsumerThreadCount, pProducerThreadCount, pTaskCount:Integer);
var
  vQueue:TThreadedQueue<TObject>;
  vProducing:Boolean;
  vProducer:TExampleLinkedProducerThread;
  vTasksPerThread:Integer;
begin
  LogIt(Format('Test started: Queue Depth: %d  Push Timeout: %d  Pop Timeout: %d  ConsumerThreads: %d  ProducerThreads %d  Tasks: %d',[pQueueDepth, pPushTimeout, pPopTimeout, pConsumerThreadCount, pProducerThreadCount, pTaskCount]));
  if pQueueDepth = 0 then
  begin
    Assert.Fail('Queue Depth cannot be zero');
  end;
  if pProducerThreadCount = 0 then
  begin
    Assert.Fail('Producer Thread Count cannot be zero');
  end;

  vQueue := TThreadedQueue<TObject>.Create(pQueueDepth, pPushTimeout, pPopTimeout);
  try
    vTasksPerThread := pTaskCount div pProducerThreadCount;
    if vTasksPerThread = 0 then
    begin
      vTasksPerThread := 1;
    end;

    CreateConsumers(pConsumerThreadCount, vQueue, pPopTimeout);
    CreateProducers(pProducerThreadCount, vQueue, pPushTimeout, vTasksPerThread);

    LogIt(Format('Producing %d tasks', [vTasksPerThread*pProducerThreadCount]));
    vProducing := True;
    while vProducing do
    begin
      vProducing := False;

      for vProducer in fProducers do
      begin
        if vProducer.ThreadState = TProducerState.ProducerWorking then
        begin
          vProducing := True;
        end;
      end;
      TThread.CurrentThread.Yield;
    end;

    LogIt('Production completed, waiting for consumers to finish');
    while vQueue.QueueSize <> 0 do
    begin
      TThread.CurrentThread.Yield;
    end;

    LogIt('Shutting down queue');
    vQueue.DoShutDown();
    FreeProducers();
    FreeConsumers();

    Assert.AreEqual(fTasksProduced, fTasksConsumed, 'Did not consume as many tasks produced');
    Assert.AreEqual(fQueueProducerFailures, 0, 'Queue producer errors not zero');
    Assert.AreEqual(fQueueConsumerFailures, 0, 'Queue consumer errors not zero');
  finally
    LogIt('Freeing queue');
    vQueue.Free();
  end;
  LogIt('Test completed');
end;


procedure TiaTestMultiThreadedProducerAndConsumer.CreateConsumers(const pConsumerThreadCount:Integer; const pTaskQueue:TThreadedQueue<TObject>; const pPopTimeout:Cardinal);
var
  i:Integer;
begin
  LogIt(Format('Creating %d consumer threads', [pConsumerThreadCount]));
  fTasksConsumed := 0;
  fTasksUnderflow := 0;
  fQueueConsumerFailures := 0;

  SetLength(fConsumers, pConsumerThreadCount);
  for i := 0 to pConsumerThreadCount-1 do
  begin
    fConsumers[i] := TExampleLinkedConsumerThread.Create(pTaskQueue, pPopTimeout);
  end;
end;


procedure TiaTestMultiThreadedProducerAndConsumer.CreateProducers(const pProducerThreadCount:Integer; const pTaskQueue:TThreadedQueue<TObject>; const pPushTimeout:Cardinal; const pTaskCount:Integer);
var
  i:Integer;
begin
  LogIt(Format('Creating %d producer threads', [pProducerThreadCount]));
  fTasksProduced := 0;
  fTasksOverflow := 0;
  fQueueProducerFailures := 0;

  SetLength(fProducers, pProducerThreadCount);
  for i := 0 to pProducerThreadCount-1 do
  begin
    fProducers[i] := TExampleLinkedProducerThread.Create(pTaskQueue, pPushTimeout, pTaskCount);
  end;
end;


procedure TiaTestMultiThreadedProducerAndConsumer.FreeConsumers();
var
  vThread:TExampleLinkedProducerThread;
begin
  LogIt('Freeing producer threads');
  for vThread in fProducers do
  begin
    Inc(fTasksProduced, vThread.TasksProduced);
    Inc(fTasksOverflow, vThread.TasksOverflow);
    Inc(fQueueProducerFailures, vThread.QueueFailures);
    vThread.Free();
  end;
end;


procedure TiaTestMultiThreadedProducerAndConsumer.FreeProducers();
var
  vThread:TExampleLinkedConsumerThread;
begin
  LogIt('Freeing consumer threads');
  for vThread in fConsumers do
  begin
    Inc(fTasksConsumed, vThread.TasksConsumed);
    Inc(fTasksUnderflow, vThread.TasksUnderflow);
    Inc(fQueueConsumerFailures, vThread.QueueFailures);
    vThread.Free();
  end;
end;


end.
