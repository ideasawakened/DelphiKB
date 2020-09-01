(*
This doesn't state the strength of a candidate, rather it quickly flags the weak ones.

Write a program in five minutes or less which outputs the string representation of numbers from 1 to 100.

But for multiples of three it should output “Fizz” instead of the number and for the multiples of five output “Buzz”.
For numbers which are multiples of both three and five output “FizzBuzz”.

Example:
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
etc...

*)
program FizzBuzz;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  FizzBuzz.GameLogic in '..\Source\FizzBuzz.GameLogic.pas';

var
  i:Integer;
begin
  try
    for i := 1 to 100 do
    begin
      WriteLn(CalcFizzBuzz(3,5,i));
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  ReadLn;
end.
