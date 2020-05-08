unit iaTestSupport.Log;

interface
uses
  System.SyncObjs;


  procedure LogIt(const pText:string);

var
  pubConsoleLock:TCriticalSection;


implementation
uses
  System.SysUtils;


procedure LogIt(const pText:string);
begin
  pubConsoleLock.Enter();
  try
    WriteLn(FormatDateTime('yyyy-mm-dd hh.nn.ss', Now) + ': ' + pText);
  finally
    pubConsoleLock.Leave();
  end;
end;


initialization
  pubConsoleLock := TCriticalSection.Create();

finalization
  pubConsoleLock.Free();


end.

