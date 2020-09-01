unit FizzBuzzExamples;

interface

procedure FizzBuzzExample1;
procedure FizzBuzzExample2;
procedure FizzBuzzExample3(const pFizz, pBuzz:Integer; const pRangeStart, pRangeEnd:Integer);
procedure FizzBuzzExample4(const pFizz, pBuzz:Integer; const pRangeStart, pRangeEnd:Integer);
procedure FizzBuzzExample_UseCase;
procedure FizzBuzzExample_UseDictionary;

implementation

uses
  SysUtils,
  Math,
  Generics.Collections;


// First instinct - code exactly as requested. (Wrong)
procedure FizzBuzzExample1;
var
  i:Integer;
begin
  for i := 1 to 100 do
  begin
    if i mod 3 = 0 then
    begin
      WriteLn('Fizz');
    end
    else if i mod 5 = 0 then
    begin
      WriteLn('Buzz');
    end
    else if (i mod 3 = 0) and (i mod 5 = 0) then
    begin
      WriteLn('FizzBuzz');
    end
    else
    begin
      WriteLn(IntToStr(i));
    end;
  end;
end;


// corrects the FizzBuzz output
procedure FizzBuzzExample2;
var
  i:Integer;
begin
  for i := 1 to 100 do
  begin
    if (i mod 3 = 0) and (i mod 5 = 0) then
    begin
      WriteLn('FizzBuzz');
    end
    else if i mod 3 = 0 then
    begin
      WriteLn('Fizz');
    end
    else if i mod 5 = 0 then
    begin
      WriteLn('Buzz');
    end
    else
    begin
      WriteLn(IntToStr(i));
    end;
  end;
end;


// Possible refactor: Add parameters
procedure FizzBuzzExample3(const pFizz, pBuzz:Integer; const pRangeStart, pRangeEnd:Integer);
var
  i:Integer;
begin
  for i := pRangeStart to pRangeEnd do
  begin
    if (i mod pFizz = 0) and (i mod pBuzz = 0) then
    begin
      WriteLn('FizzBuzz');
    end
    else if i mod pFizz = 0 then
    begin
      WriteLn('Fizz');
    end
    else if i mod pBuzz = 0 then
    begin
      WriteLn('Buzz');
    end
    else
    begin
      WriteLn(IntToStr(i));
    end;
  end;
end;


// Possible refactor: math/logic reduction
procedure FizzBuzzExample4(const pFizz, pBuzz:Integer; const pRangeStart, pRangeEnd:Integer);

  function IsMultiple(const x, y:Integer):Boolean;
  begin
    Result := (x mod y = 0);
  end;


var
  i:Integer;
  vOutput:string;
begin
  for i := pRangeStart to pRangeEnd do
  begin
    vOutput := '';

    if IsMultiple(i, pFizz) then
    begin
      vOutput := 'Fizz';
    end;
    if IsMultiple(i, pBuzz) then
    begin
      vOutput := vOutput + 'Buzz';
    end;
    if vOutput = '' then
    begin
      vOutput := IntToStr(i);
    end;

    WriteLn(vOutput);
  end;
end;


// Example requiring the use of Case statement
procedure FizzBuzzExample_UseCase;
var
  i:Integer;
begin
  for i := 1 to 100 do
  begin
    case i mod 15 of
      3, 6, 9, 12:
        WriteLn('Fizz');
      5, 10:
        WriteLn('Buzz');
      0:
        WriteLn('FizzBuzz');
      else
        WriteLn(IntToStr(i));
    end;
  end;
end;


// Example requiring the use of Dictionary
procedure FizzBuzzExample_UseDictionary;
var
  i:Integer;
  vValue:string;
  vDict:TDictionary<Integer, string>;
begin
  vDict := TDictionary<Integer, string>.Create;
  try
    vDict.Add(0, 'FizzBuzz');
    vDict.Add(3, 'Fizz');
    vDict.Add(5, 'Buzz');
    vDict.Add(6, 'Fizz');
    vDict.Add(9, 'Fizz');
    vDict.Add(10, 'Buzz');
    vDict.Add(12, 'Fizz');
    for i := 1 to 100 do
    begin
      if vDict.TryGetValue(i mod 15, vValue) then
      begin
        WriteLn(vValue);
      end
      else
      begin
        WriteLn(IntToStr(i));
      end;
    end;
  finally
    vDict.Free();
  end;
end;


end.
