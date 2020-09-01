unit TestFizzBuzz;

interface

uses
  TestFramework;

type

  TTestFizzBuzz = class(TTestCase)
  published
    procedure CheckFizz;
    procedure CheckBuzz;
    procedure CheckFizzBuzz;
    procedure CheckNonFizzBuzz;
  end;

const
  FizzOutput = 'Fizz';
  BuzzOutput = 'Buzz';
  FizzVal = 3;
  BuzzVal = 5;


implementation
uses
 FizzBuzz.GameLogic;

procedure TTestFizzBuzz.CheckFizz;
begin
  CheckEqualsString(FizzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal));
  CheckEqualsString(FizzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*2));
  CheckEqualsString(FizzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*3));
  CheckEqualsString(FizzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*101));
end;

procedure TTestFizzBuzz.CheckBuzz;
begin
  CheckEqualsString(BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, BuzzVal));
  CheckEqualsString(BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, BuzzVal*2));
  CheckEqualsString(BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, BuzzVal*4));
  CheckEqualsString(BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, BuzzVal*101));
end;

procedure TTestFizzBuzz.CheckFizzBuzz;
begin
  CheckEqualsString(FizzOutput+BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*BuzzVal));
  CheckEqualsString(FizzOutput+BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*BuzzVal*2));
  CheckEqualsString(FizzOutput+BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*BuzzVal*3));
  CheckEqualsString(FizzOutput+BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*BuzzVal*4));
  CheckEqualsString(FizzOutput+BuzzOutput, CalcFizzBuzz(FizzVal, BuzzVal, FizzVal*BuzzVal*5));
end;

procedure TTestFizzBuzz.CheckNonFizzBuzz;
begin
  CheckEqualsString('1', CalcFizzBuzz(FizzVal, BuzzVal, 1));
  CheckEqualsString('2', CalcFizzBuzz(FizzVal, BuzzVal, 2));
  CheckEqualsString('4', CalcFizzBuzz(FizzVal, BuzzVal, 4));
  CheckEqualsString('7', CalcFizzBuzz(FizzVal, BuzzVal, 7));
end;

initialization
  RegisterTest(TTestFizzBuzz.Suite);

end.


