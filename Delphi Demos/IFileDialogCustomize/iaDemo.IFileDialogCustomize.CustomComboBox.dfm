object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Demonstrate adding a custom combo box via IFileDialogCustomize'
  ClientHeight = 411
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 88
    Width = 96
    Height = 13
    Caption = 'Combo Box choices:'
  end
  object Label2: TLabel
    Left = 48
    Top = 210
    Width = 249
    Height = 13
    Caption = 'Select one to have it auto-selected in the File Dialog'
  end
  object butOpenFile: TButton
    Left = 40
    Top = 32
    Width = 89
    Height = 25
    Caption = 'Test OpenFile'
    TabOrder = 0
    OnClick = butOpenFileClick
  end
  object lstCustomItems: TListBox
    Left = 48
    Top = 107
    Width = 113
    Height = 97
    ItemHeight = 13
    Items.Strings = (
      'Demo 1'
      'Demo 2'
      'Demo 3')
    TabOrder = 1
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Testing - No files actually opened'
        FileMask = '*.*'
      end>
    Options = []
    OnExecute = FileOpenDialog1Execute
    OnFileOkClick = FileOpenDialog1FileOkClick
    Left = 184
    Top = 24
  end
end
