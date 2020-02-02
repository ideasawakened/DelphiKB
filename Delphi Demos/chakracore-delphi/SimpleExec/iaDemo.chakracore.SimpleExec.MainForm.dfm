object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'ChakraCore'
  ClientHeight = 161
  ClientWidth = 533
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 186
    Top = 127
    Width = 34
    Height = 13
    Caption = 'Result:'
  end
  object labMS: TLabel
    Left = 492
    Top = 146
    Width = 19
    Height = 13
    Alignment = taRightJustify
    Caption = '0ms'
  end
  object Label2: TLabel
    Left = 20
    Top = 7
    Width = 54
    Height = 13
    Caption = 'JavaScript:'
  end
  object memJS: TMemo
    Left = 20
    Top = 26
    Width = 491
    Height = 89
    Lines.Strings = (
      '(()=>{return "Hello world!";})()')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 20
    Top = 121
    Width = 75
    Height = 25
    Caption = 'Exec Script'
    TabOrder = 1
    OnClick = Button1Click
  end
  object edtResult: TEdit
    Left = 226
    Top = 123
    Width = 285
    Height = 21
    TabOrder = 2
  end
end
