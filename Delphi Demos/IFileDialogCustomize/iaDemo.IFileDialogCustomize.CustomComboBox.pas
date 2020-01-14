unit iaDemo.IFileDialogCustomize.CustomComboBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    butOpenFile: TButton;
    FileOpenDialog1: TFileOpenDialog;
    Label1: TLabel;
    lstCustomItems: TListBox;
    Label2: TLabel;
    procedure FileOpenDialog1FileOkClick(Sender: TObject;
      var CanClose: Boolean);
    procedure FileOpenDialog1Execute(Sender: TObject);
    procedure butOpenFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  CUSTOM_CONTROL_ID = 1;

implementation
uses
  WinAPI.ShlObj;

{$R *.dfm}

procedure TForm1.butOpenFileClick(Sender: TObject);
begin
  FileOpenDialog1.Tag := 0; //reset on use
  if FileOpenDialog1.Execute then
  begin
    ShowMessage(Format('You selected custom item index %d', [FileOpenDialog1.Tag]));
  end;
end;


procedure TForm1.FileOpenDialog1Execute(Sender: TObject);
var
  iCustomize:IFileDialogCustomize;
  vItem:string;
  i:Integer;
begin
  if FileOpenDialog1.Dialog.QueryInterface(IFileDialogCustomize, iCustomize) = S_OK then
  begin
    iCustomize.StartVisualGroup(0, 'Custom description here');
    try
      iCustomize.AddComboBox(CUSTOM_CONTROL_ID);
      for i := 0 to lstCustomItems.Items.Count -1 do
      begin
        vItem := lstCustomItems.Items[i];
        iCustomize.AddControlItem(CUSTOM_CONTROL_ID, i+1, PChar(vItem));  //+1 note: If user didn't select an item, result is 0 so start indexed items with 1
      end;

      if lstCustomItems.ItemIndex >= 0 then //let's optionally pre-select a custom item
      begin
        //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setselectedcontrolitem
        iCustomize.SetSelectedControlItem(CUSTOM_CONTROL_ID, lstCustomItems.ItemIndex+1);
      end;
    finally
      iCustomize.EndVisualGroup;
    end;
  end;
end;


procedure TForm1.FileOpenDialog1FileOkClick(Sender: TObject; var CanClose: Boolean);
var
  iCustomize: IFileDialogCustomize;
  vSelectedIndex:DWORD;
begin
  vSelectedIndex := 0;
  if FileOpenDialog1.Dialog.QueryInterface(IFileDialogCustomize, iCustomize) = S_OK then
  begin
    iCustomize.GetSelectedControlItem(CUSTOM_CONTROL_ID, vSelectedIndex);
    FileOpenDialog1.Tag := vSelectedIndex;  //Tag offers a simple way to pass back custom selection.
  end;
end;

end.
