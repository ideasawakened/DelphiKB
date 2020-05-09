unit iaExample.TaskData;

interface

type

  TExampleTaskData = class
  private
    fId:Integer;
    fSomeAttribute:string;
  public
    constructor Create(const pId:Integer; const pSomeAttribute:string);

    property Id:Integer read fId write fId;
    property SomeAttribute:string read fSomeAttribute write fSomeAttribute;
  end;


implementation


constructor TExampleTaskData.Create(const pId:Integer; const pSomeAttribute:string);
begin
  fId := pId;
  fSomeAttribute := pSomeAttribute;
end;


end.
