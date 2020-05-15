unit iaDemo.VCLForkJoin.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    memLog: TMemo;
    butPerformWork: TButton;
    Image1: TImage;
    lnkBlog: TLinkLabel;
    procedure butPerformWorkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lnkBlogLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
uses
  WinAPI.ShellAPI,
  iaExample.CDE.ControllerThread;

{$R *.dfm}


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;


procedure TfrmMain.lnkBlogLinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
begin
  ShellExecute(Application.Handle, 'Open', PChar(Link), nil, nil, SW_SHOW)
end;


procedure TfrmMain.butPerformWorkClick(Sender: TObject);
begin
  TExampleControllerThread.Create(memLog);
end;


end.
