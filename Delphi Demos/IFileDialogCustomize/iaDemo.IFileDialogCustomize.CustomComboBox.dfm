object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demonstrate adding a custom combo box via IFileDialogCustomize'
  ClientHeight = 190
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 188
    Top = 26
    Width = 170
    Height = 13
    Caption = 'TComboBox choices listed in Dialog:'
  end
  object Label2: TLabel
    Left = 184
    Top = 154
    Width = 168
    Height = 13
    Caption = 'Select one to have it auto-selected'
  end
  object butOpenFile: TButton
    Left = 56
    Top = 20
    Width = 89
    Height = 25
    Caption = 'Test OpenFile'
    TabOrder = 0
    OnClick = butOpenFileClick
  end
  object lstCustomItems: TListBox
    Left = 184
    Top = 47
    Width = 113
    Height = 97
    ItemHeight = 13
    Items.Strings = (
      'Demo 1'
      'Demo 2'
      'Demo 3')
    TabOrder = 1
  end
  object ExampleDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Testing - No files actually opened'
        FileMask = '*.*'
      end>
    Options = []
    OnExecute = ExampleDialogExecute
    OnFileOkClick = ExampleDialogFileOkClick
    Left = 84
    Top = 60
  end
end
