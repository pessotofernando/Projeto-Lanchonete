object Fr_CadEndereco: TFr_CadEndereco
  Left = 253
  Top = 282
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cadastro de Endere'#231'os'
  ClientHeight = 162
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 49
    Width = 393
    Height = 113
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 389
    ExplicitHeight = 112
    object Label5: TLabel
      Left = 33
      Top = 12
      Width = 22
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'Cep:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 19
      Top = 62
      Width = 36
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'Cidade:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 9
      Top = 87
      Width = 46
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'Endere'#231'o'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentFont = False
    end
    object Label3: TLabel
      Left = 323
      Top = 12
      Width = 17
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'UF:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentFont = False
    end
    object Label4: TLabel
      Left = 25
      Top = 37
      Width = 30
      Height = 13
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'Bairro:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBiDiMode = False
      ParentColor = False
      ParentFont = False
    end
    object bairro: TEdit
      Left = 62
      Top = 34
      Width = 315
      Height = 20
      AutoSize = False
      CharCase = ecUpperCase
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 60
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
    end
    object cidade: TEdit
      Left = 62
      Top = 59
      Width = 315
      Height = 20
      AutoSize = False
      CharCase = ecUpperCase
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 60
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
    end
    object endereco: TEdit
      Left = 62
      Top = 84
      Width = 315
      Height = 20
      AutoSize = False
      CharCase = ecUpperCase
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 80
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
    end
    object UF: TEdit
      Left = 347
      Top = 10
      Width = 30
      Height = 20
      AutoSize = False
      CharCase = ecUpperCase
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 2
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
  end
  inline Frame_Cadastro021: TFrame_Cadastro02
    Left = 0
    Top = 0
    Width = 393
    Height = 49
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 389
    inherited Panel1: TPanel
      Width = 393
      ExplicitWidth = 389
      inherited BntAltera: TSpeedButton
        Left = 114
        Width = 55
        Hint = ''
        Enabled = False
        Glyph.Data = {00000000}
        ExplicitLeft = 114
        ExplicitWidth = 55
      end
      inherited BntNovo: TSpeedButton
        Width = 55
        OnClick = Frame_Cadastro021BntNovoClick
        ExplicitWidth = 55
      end
      inherited BntGrava: TSpeedButton
        Left = 57
        Width = 55
        OnClick = Frame_Cadastro021BntGravaClick
        ExplicitLeft = 57
        ExplicitWidth = 55
      end
      inherited BntExcluir: TSpeedButton
        Left = 170
        Width = 55
        OnClick = Frame_Cadastro021BntExcluirClick
        ExplicitLeft = 170
        ExplicitWidth = 55
      end
      inherited BntLimpa: TSpeedButton
        Left = 280
        Width = 55
        OnClick = Frame_Cadastro021BntLimpaClick
        ExplicitLeft = 280
        ExplicitWidth = 55
      end
      inherited BntFechar: TSpeedButton
        Left = 335
        Width = 55
        OnClick = Frame_Cadastro021BntFecharClick
        ExplicitLeft = 335
        ExplicitWidth = 55
      end
      inherited SpeedButton9: TSpeedButton
        Left = 225
        Width = 55
        ExplicitLeft = 225
        ExplicitWidth = 55
      end
      inherited Panel2: TPanel
        Width = 392
        ExplicitWidth = 392
      end
    end
  end
  object cep: TMaskEdit
    Left = 62
    Top = 60
    Width = 58
    Height = 19
    Ctl3D = False
    EditMask = '99999-999;1;_'
    MaxLength = 9
    ParentCtl3D = False
    TabOrder = 2
    Text = '     -   '
    OnExit = cepExit
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 408
    Top = 10
  end
  object ApplicationEvents2: TApplicationEvents
    OnMessage = ApplicationEvents2Message
    Left = 200
    Top = 89
  end
end
