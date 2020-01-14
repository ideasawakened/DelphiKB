program iaDemo.IFileDialogCustomize;

uses
  Vcl.Forms,
  iaDemo.IFileDialogCustomize.CustomComboBox in 'iaDemo.IFileDialogCustomize.CustomComboBox.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
