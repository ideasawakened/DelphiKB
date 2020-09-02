unit FizzBuzz.GameLogic;

interface

type

  TFizzBuzzGame = class
  public const
    FizzText = 'Fizz';
    BuzzText = 'Buzz';
  private const
    defFizzValue = 3;
    defBuzzValue = 5;
  private
    fFizz:Integer;
    fBuzz:Integer;
  protected
    function IsMultiple(const x, y:Integer):Boolean;
  public
    constructor Create();

    function CalcFizzBuzz(const pValue:Integer):string;

    property Fizz:Integer read fFizz write fFizz;
    property Buzz:Integer read fBuzz write fBuzz;
  end;


implementation

uses
  System.SysUtils;


constructor TFizzBuzzGame.Create();
begin
  inherited;
  fFizz := defFizzValue;
  fBuzz := defBuzzValue;
end;


function TFizzBuzzGame.IsMultiple(const x, y:Integer):Boolean;
begin
  Result := (x mod y = 0);
end;


function TFizzBuzzGame.CalcFizzBuzz(const pValue:Integer):string;
begin
  Result := '';

  if IsMultiple(pValue, Fizz) then
  begin
    Result := FizzText;
  end;
  if IsMultiple(pValue, Buzz) then
  begin
    Result := Result + BuzzText;
  end;
  if Result = '' then
  begin
    Result := IntToStr(pValue);
  end;
end;


end.
