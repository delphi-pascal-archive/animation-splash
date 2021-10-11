object frm_Main: Tfrm_Main
  Left = 285
  Top = 169
  Width = 401
  Height = 372
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'ASFDemo - Antonn'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    393
    342)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 94
    Width = 393
    Height = 128
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Animation'#13#10'Splash Form'#13#10'Demo Application'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -35
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Tag = 255
    Left = 264
    Top = 215
    Width = 129
    Height = 24
    Hint = 'bitoff@pisem.net'
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'by Andy BitOff'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlue
    Font.Height = -19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = Label2Click
    OnMouseEnter = LabelMouseEnter
    OnMouseLeave = LabelMouseLeave
  end
  object Label3: TLabel
    Tag = 16711680
    Left = 74
    Top = 313
    Width = 245
    Height = 14
    Hint = 'http://AnimationSplash.elementfx.com/'
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'http://AnimationSplash.elementfx.com/'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = Label3Click
    OnMouseEnter = LabelMouseEnter
    OnMouseLeave = LabelMouseLeave
  end
end
