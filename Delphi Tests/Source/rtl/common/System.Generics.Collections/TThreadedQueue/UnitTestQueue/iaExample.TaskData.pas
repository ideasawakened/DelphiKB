unit iaExample.TaskData;

interface

type

  TExampleTaskData = class
  private
    fId:Integer;
    fSomeAttribute:string;
  public
    constructor Create(const InitialId:Integer; const InitialAttribute:string);

    property Id:Integer read fId write fId;
    property SomeAttribute:string read fSomeAttribute write fSomeAttribute;
  end;


implementation


constructor TExampleTaskData.Create(const InitialId:Integer; const InitialAttribute:string);
begin
  fId := InitialId;
  fSomeAttribute := InitialAttribute;
end;


end.
