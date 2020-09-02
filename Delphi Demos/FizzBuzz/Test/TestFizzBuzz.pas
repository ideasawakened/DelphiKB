unit TestFizzBuzz;

interface

uses
//  DUnitX.TestFramework, DUnitX.DUnitCompatibility,
  TestFramework,
  FizzBuzz.GameLogic;

type

  TestTFizzBuzzGame = class(TTestCase)
  private const
    TestFizzVal = 3;
    TestBuzzVal = 5;
  strict private
    fGame:TFizzBuzzGame;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure CheckFizz;
    procedure CheckBuzz;
    procedure CheckFizzBuzz;
    procedure CheckNonFizzBuzz;
    procedure CheckFizzText;
    procedure CheckBuzzText;
  end;


implementation


procedure TestTFizzBuzzGame.SetUp;
begin
  fGame := TFizzBuzzGame.Create;
  fGame.Fizz := TestFizzVal;
  fGame.Buzz := TestBuzzVal;
end;


procedure TestTFizzBuzzGame.TearDown;
begin
  fGame.Free;
  fGame := nil;
end;


procedure TestTFizzBuzzGame.CheckFizz;
begin
  CheckEqualsString(fGame.FizzText, fGame.CalcFizzBuzz(TestFizzVal));
  CheckEqualsString(fGame.FizzText, fGame.CalcFizzBuzz(TestFizzVal * 2));
  CheckEqualsString(fGame.FizzText, fGame.CalcFizzBuzz(TestFizzVal * 3));
  CheckEqualsString(fGame.FizzText, fGame.CalcFizzBuzz(TestFizzVal * 101));
end;


procedure TestTFizzBuzzGame.CheckBuzz;
begin
  CheckEqualsString(fGame.BuzzText, fGame.CalcFizzBuzz(TestBuzzVal));
  CheckEqualsString(fGame.BuzzText, fGame.CalcFizzBuzz(TestBuzzVal * 2));
  CheckEqualsString(fGame.BuzzText, fGame.CalcFizzBuzz(TestBuzzVal * 4));
  CheckEqualsString(fGame.BuzzText, fGame.CalcFizzBuzz(TestBuzzVal * 101));
end;


procedure TestTFizzBuzzGame.CheckFizzBuzz;
begin
  CheckEqualsString(fGame.FizzText + fGame.BuzzText, fGame.CalcFizzBuzz(TestFizzVal * TestBuzzVal));
  CheckEqualsString(fGame.FizzText + fGame.BuzzText, fGame.CalcFizzBuzz(TestFizzVal * TestBuzzVal * 2));
  CheckEqualsString(fGame.FizzText + fGame.BuzzText, fGame.CalcFizzBuzz(TestFizzVal * TestBuzzVal * 3));
  CheckEqualsString(fGame.FizzText + fGame.BuzzText, fGame.CalcFizzBuzz(TestFizzVal * TestBuzzVal * 4));
  CheckEqualsString(fGame.FizzText + fGame.BuzzText, fGame.CalcFizzBuzz(TestFizzVal * TestBuzzVal * 5));
end;


procedure TestTFizzBuzzGame.CheckNonFizzBuzz;
begin
  CheckEqualsString('1', fGame.CalcFizzBuzz(1));
  CheckEqualsString('2', fGame.CalcFizzBuzz(2));
  CheckEqualsString('4', fGame.CalcFizzBuzz(4));
  CheckEqualsString('7', fGame.CalcFizzBuzz(7));
end;


procedure TestTFizzBuzzGame.CheckFizzText;
begin
  CheckEqualsString('Fizz', fGame.FizzText);
end;


procedure TestTFizzBuzzGame.CheckBuzzText;
begin
  CheckEqualsString('Buzz', fGame.BuzzText);
end;


initialization

//TDUnitX.RegisterTestFixture(TestTFizzBuzzGame);
RegisterTest(TestTFizzBuzzGame.Suite);

end.
