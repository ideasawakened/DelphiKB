object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'ThreadedQueue Example'
  ClientHeight = 366
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    624
    366)
  TextHeight = 15
  object Memo1: TMemo
    Left = 8
    Top = 69
    Width = 608
    Height = 289
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object butProduce: TButton
    Left = 8
    Top = 24
    Width = 137
    Height = 25
    Caption = 'Produce'
    TabOrder = 1
    OnClick = butProduceClick
  end
end
