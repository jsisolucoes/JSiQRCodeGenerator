object viewMain: TviewMain
  Left = 0
  Top = 0
  Caption = 'JSi Solu'#231#245'es - QRCode Generator'
  ClientHeight = 614
  ClientWidth = 360
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgQR: TImage
    Left = 24
    Top = 183
    Width = 313
    Height = 313
    Center = True
    Proportional = True
  end
  object Label3: TLabel
    Left = 24
    Top = 12
    Width = 48
    Height = 13
    Caption = 'Text Data'
  end
  object lblTime: TLabel
    Left = 315
    Top = 12
    Width = 22
    Height = 13
    Alignment = taRightJustify
    Caption = '0 ms'
  end
  object Button1: TButton
    Left = 24
    Top = 152
    Width = 113
    Height = 25
    Caption = 'Generate'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtDATA: TEdit
    Left = 24
    Top = 31
    Width = 313
    Height = 21
    TabOrder = 1
    TextHint = 'QR Code Contents'
  end
  object mLog: TMemo
    Left = 24
    Top = 509
    Width = 313
    Height = 89
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 58
    Width = 313
    Height = 87
    Caption = 'Settings'
    TabOrder = 3
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 43
      Height = 13
      Caption = 'Encoding'
    end
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 53
      Height = 13
      Caption = 'Quiet Zone'
    end
    object edtEncoding: TComboBox
      Left = 144
      Top = 24
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Auto'
      Items.Strings = (
        'Auto'
        'Numeric'
        'Alphanumeric'
        'ISO88591'
        'UTF8NoBOM'
        'UTF8BOM')
    end
    object edtQZ: TSpinEdit
      Left = 144
      Top = 51
      Width = 145
      Height = 22
      MaxValue = 8
      MinValue = 1
      TabOrder = 1
      Value = 4
    end
  end
  object btnSave: TButton
    Left = 224
    Top = 152
    Width = 113
    Height = 25
    Caption = 'Save as ...'
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object JSiQCodeGenVCL1: TJSiQCodeGenVCL
    Encoding = qrAuto
    QuietZone = 4
    ImageControl = imgQR
    OnGenerate = JSiQCodeGenVCL1Generate
    OnError = JSiQCodeGenVCL1Error
    Left = 152
    Top = 280
  end
  object SD: TSavePictureDialog
    Left = 264
    Top = 272
  end
end
