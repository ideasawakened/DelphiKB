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
    procedure CreateConsumers(const ConsumerThreadCount:Integer; const TaskQueue:TThreadedQueue<TObject>; const PopTimeout:Cardinal);
    procedure CreateProducers(const ProducerThreadCount:Integer; const TaskQueue:TThreadedQueue<TObject>; const PushTimeout:Cardinal; const TaskCount:Integer);
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


    procedure ExerciseQueue(const QueueDepth:Integer; const PushTimeout, PopTimeout:Cardinal; const ConsumerThreadCount, ProducerThreadCount, TaskCount:Integer);
  end;

implementation
uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  iaTestSupport.Log;

procedure TiaTestMultiThreadedProducerAndConsumer.ExerciseQueue(const QueueDepth:Integer; const PushTimeout, PopTimeout:Cardinal; const ConsumerThreadCount, ProducerThreadCount, TaskCount:Integer);
var
  Queue:TThreadedQueue<TObject>;
  IsProducing:Boolean;
  ProducerThread:TExampleLinkedProducerThread;
  TasksPerThread:Integer;
begin
  LogIt(Format('Test started: Queue Depth: %d  Push Timeout: %d  Pop Timeout: %d  ConsumerThreads: %d  ProducerThreads %d  Tasks: %d',[QueueDepth, PushTimeout, PopTimeout, ConsumerThreadCount, ProducerThreadCount, TaskCount]));
  if QueueDepth = 0 then
  begin
    Assert.Fail('Queue Depth cannot be zero');
  end;
  if ProducerThreadCount = 0 then
  begin
    Assert.Fail('Producer Thread Count cannot be zero');
  end;

  Queue := TThreadedQueue<TObject>.Create(QueueDepth, PushTimeout, PopTimeout);
  try
    TasksPerThread := TaskCount div ProducerThreadCount;
    if TasksPerThread = 0 then
    begin
      TasksPerThread := 1;
    end;

    CreateConsumers(ConsumerThreadCount, Queue, PopTimeout);
    CreateProducers(ProducerThreadCount, Queue, PushTimeout, TasksPerThread);

    LogIt(Format('Producing %d tasks', [TasksPerThread*ProducerThreadCount]));
    IsProducing := True;
    while IsProducing do
    begin
      IsProducing := False;

      for ProducerThread in fProducers do
      begin
        if ProducerThread.ThreadState = TProducerState.ProducerWorking then
        begin
          IsProducing := True;
        end;
      end;
      TThread.CurrentThread.Yield;
    end;

    LogIt('Production completed, waiting for consumers to finish');
    while Queue.QueueSize <> 0 do
    begin
      TThread.CurrentThread.Yield;
    end;

    LogIt('Shutting down queue');
    Queue.DoShutDown();
    FreeProducers();
    FreeConsumers();

    Assert.AreEqual(fTasksProduced, fTasksConsumed, 'Did not consume as many tasks produced');
    Assert.AreEqual(fQueueProducerFailures, 0, 'Queue producer errors not zero');
    Assert.AreEqual(fQueueConsumerFailures, 0, 'Queue consumer errors not zero');
  finally
    LogIt('Freeing queue');
    Queue.Free();
  end;
  LogIt('Test completed');
end;


procedure TiaTestMultiThreadedProducerAndConsumer.CreateConsumers(const ConsumerThreadCount:Integer; const TaskQueue:TThreadedQueue<TObject>; const PopTimeout:Cardinal);
var
  i:Integer;
begin
  LogIt(Format('Creating %d consumer threads', [ConsumerThreadCount]));
  fTasksConsumed := 0;
  fTasksUnderflow := 0;
  fQueueConsumerFailures := 0;

  SetLength(fConsumers, ConsumerThreadCount);
  for i := 0 to ConsumerThreadCount-1 do
  begin
    fConsumers[i] := TExampleLinkedConsumerThread.Create(TaskQueue, PopTimeout);
  end;
end;


procedure TiaTestMultiThreadedProducerAndConsumer.CreateProducers(const ProducerThreadCount:Integer; const TaskQueue:TThreadedQueue<TObject>; const PushTimeout:Cardinal; const TaskCount:Integer);
var
  i:Integer;
begin
  LogIt(Format('Creating %d producer threads', [ProducerThreadCount]));
  fTasksProduced := 0;
  fTasksOverflow := 0;
  fQueueProducerFailures := 0;

  SetLength(fProducers, ProducerThreadCount);
  for i := 0 to ProducerThreadCount-1 do
  begin
    fProducers[i] := TExampleLinkedProducerThread.Create(TaskQueue, PushTimeout, TaskCount);
  end;
end;


procedure TiaTestMultiThreadedProducerAndConsumer.FreeConsumers();
var
  ProducerThread:TExampleLinkedProducerThread;
begin
  LogIt('Freeing producer threads');
  for ProducerThread in fProducers do
  begin
    Inc(fTasksProduced, ProducerThread.TasksProduced);
    Inc(fTasksOverflow, ProducerThread.TasksOverflow);
    Inc(fQueueProducerFailures, ProducerThread.QueueFailures);
    ProducerThread.Free();
  end;
end;


procedure TiaTestMultiThreadedProducerAndConsumer.FreeProducers();
var
  ConsumerThread:TExampleLinkedConsumerThread;
begin
  LogIt('Freeing consumer threads');
  for ConsumerThread in fConsumers do
  begin
    Inc(fTasksConsumed, ConsumerThread.TasksConsumed);
    Inc(fTasksUnderflow, ConsumerThread.TasksUnderflow);
    Inc(fQueueConsumerFailures, ConsumerThread.QueueFailures);
    ConsumerThread.Free();
  end;
end;


end.
