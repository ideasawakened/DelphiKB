unit iaDemo.IFileDialogCustomize.CustomComboBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    butOpenFile: TButton;
    ExampleDialog: TFileOpenDialog;
    Label1: TLabel;
    lstCustomItems: TListBox;
    Label2: TLabel;
    procedure ExampleDialogFileOkClick(Sender: TObject; var CanClose: Boolean);
    procedure ExampleDialogExecute(Sender: TObject);
    procedure butOpenFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  CUSTOM_CONTROL_ID = 1;  //multiple custom controls are allowed per dialog, uniquely numbered


implementation
uses
  WinAPI.ShlObj;

{$R *.dfm}


//Standard Onclick event except manage custom control's selection result via the .Tag property
//Using .Tag is an easy approach for a single numeric custom response.
procedure TForm1.butOpenFileClick(Sender: TObject);
begin
  ExampleDialog.Tag := 0; //reset on use
  if ExampleDialog.Execute(self.Handle) then
  begin
    ShowMessage(Format('You selected custom item index %d' + sLineBreak
                       + 'When opening file: %s', [ExampleDialog.Tag, ExampleDialog.FileName]));
  end;
end;


//let's customize the FileOpen Dialog by adding a custom combobox
procedure TForm1.ExampleDialogExecute(Sender: TObject);
var
  iCustomize:IFileDialogCustomize;
  vItem:string;
  i:Integer;
begin
  if ExampleDialog.Dialog.QueryInterface(IFileDialogCustomize, iCustomize) = S_OK then
  begin
    //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-startvisualgroup
    iCustomize.StartVisualGroup(0, 'Custom description here');
    try
      //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addcombobox
      //note other controls available: AddCheckButton, AddEditBox, AddPushButton, AddRadioButtonList...
      iCustomize.AddComboBox(CUSTOM_CONTROL_ID);

      for i := 0 to lstCustomItems.Items.Count - 1 do
      begin
        vItem := lstCustomItems.Items[i];
        //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-addcontrolitem
        //+1 note: If user doesn't select an item, the result is 0 so lets start indexed items with 1
        iCustomize.AddControlItem(CUSTOM_CONTROL_ID, i+1, PChar(vItem));
      end;

      if lstCustomItems.ItemIndex >= 0 then //let's optionally pre-select a custom item
      begin
        //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-setselectedcontrolitem
        iCustomize.SetSelectedControlItem(CUSTOM_CONTROL_ID, lstCustomItems.ItemIndex+1);
      end;
    finally
      //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-endvisualgroup
      iCustomize.EndVisualGroup;
    end;
  end;
end;


//Grab the custom control's selection
procedure TForm1.ExampleDialogFileOkClick(Sender: TObject; var CanClose: Boolean);
var
  iCustomize: IFileDialogCustomize;
  vSelectedIndex:DWORD;
begin
  vSelectedIndex := 0;
  if ExampleDialog.Dialog.QueryInterface(IFileDialogCustomize, iCustomize) = S_OK then
  begin
    //https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifiledialogcustomize-getselectedcontrolitem
    iCustomize.GetSelectedControlItem(CUSTOM_CONTROL_ID, vSelectedIndex);
    ExampleDialog.Tag := vSelectedIndex;
  end;
end;

end.
