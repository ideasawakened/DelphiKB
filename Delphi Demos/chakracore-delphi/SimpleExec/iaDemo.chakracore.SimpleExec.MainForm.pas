unit iaDemo.chakracore.SimpleExec.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Themes,
  ChakraCoreClasses; //replace project search path for your location of source files from: https://github.com/tondrej/chakracore-delphi

type
  TForm1 = class(TForm)
    memJS: TMemo;
    Button1: TButton;
    edtResult: TEdit;
    Label1: TLabel;
    labMS: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FRuntime: TChakraCoreRuntime;
    FContext: TChakraCoreContext;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  System.Diagnostics, System.Math, System.TimeSpan,
  ChakraCommon, ChakraCoreUtils;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FRuntime := TChakraCoreRuntime.Create();
  FContext := TChakraCoreContext.Create(FRuntime);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FContext.Free();
  FRuntime.Free();
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  vResult:JsValueRef;
  vStopWatch:TStopWatch;
begin
  vStopWatch := TStopwatch.StartNew;
  vResult := FContext.RunScript(memJS.Text, 'MyScriptName');
  vStopWatch.Stop;

  if vStopWatch.ElapsedMilliseconds = 0 then
  begin
    labMS.Caption := FormatFloat('0.00', RoundTo(vStopWatch.ElapsedTicks / TTimeSpan.TicksPerMillisecond, -2)) + 'ms';
  end
  else
  begin
    labMS.Caption := IntToStr(vStopWatch.ElapsedMilliseconds) + 'ms';
  end;
  edtResult.Text := JsStringToUnicodeString(vResult);
end;

end.
