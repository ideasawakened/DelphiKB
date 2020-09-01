unit FizzBuzz.GameLogic;

interface

function CalcFizzBuzz(const pFizz, pBuzz, pValue:Integer):string;


implementation

uses
  System.SysUtils;


function CalcFizzBuzz(const pFizz, pBuzz, pValue:Integer):string;

  function IsMultiple(const x, y:Integer):Boolean;
  begin
    Result := (x mod y = 0);
  end;


begin
  Result := '';

  if IsMultiple(pValue, pFizz) then
  begin
    Result := 'Fizz';
  end;
  if IsMultiple(pValue, pBuzz) then
  begin
    Result := Result + 'Buzz';
  end;
  if Result = '' then
  begin
    Result := IntToStr(pValue);
  end;
end;

end.
