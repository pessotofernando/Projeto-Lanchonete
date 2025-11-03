object Fr_Cardapio: TFr_Cardapio
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Cardapio dos Lanches'
  ClientHeight = 589
  ClientWidth = 816
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = -5
    Top = 8
    Width = 817
    Height = 574
    Caption = 'Cardapio'
    TabOrder = 0
    DesignSize = (
      817
      574)
    object Label1: TLabel
      Left = 751
      Top = 477
      Width = 56
      Height = 30
      Caption = 'Valor '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox2: TGroupBox
      Left = 15
      Top = 17
      Width = 453
      Height = 386
      TabOrder = 0
      object DBGrid1: TDBGrid
        Left = 15
        Top = 18
        Width = 426
        Height = 355
        DataSource = DS_LANCHES_SP_CON
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnCellClick = DBGrid1CellClick
        OnKeyUp = DBGrid1KeyUp
        Columns = <
          item
            Expanded = False
            FieldName = 'LAN_DESCRICAO'
            Title.Caption = 'Lanche'
            Width = 402
            Visible = True
          end>
      end
    end
    object GroupBox3: TGroupBox
      Left = 474
      Top = 17
      Width = 333
      Height = 386
      TabOrder = 1
      object DBGrid2: TDBGrid
        Left = 12
        Top = 18
        Width = 308
        Height = 355
        Hint = 'Para incluir novos Ingredientes, bot'#227'o direito do mouse'
        DataSource = LANCHEINGR_SP_SEL
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnCellClick = DBGrid2CellClick
        OnKeyUp = DBGrid2KeyUp
        Columns = <
          item
            Expanded = False
            FieldName = 'ING_DESCRI'
            Title.Caption = 'Ingredientes'
            Width = 273
            Visible = True
          end>
      end
    end
    object GroupBox4: TGroupBox
      Left = 15
      Top = 409
      Width = 218
      Height = 156
      Caption = 'Lanche '
      TabOrder = 2
      object Image1: TImage
        Left = 15
        Top = 22
        Width = 194
        Height = 122
        Stretch = True
      end
    end
    object valor: TEdit
      Left = 624
      Top = 513
      Width = 183
      Height = 43
      Anchors = [akLeft]
      AutoSize = False
      BiDiMode = bdRightToLeft
      CharCase = ecUpperCase
      Ctl3D = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 70
      ParentBiDiMode = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
    end
    object GroupBox5: TGroupBox
      Left = 250
      Top = 409
      Width = 218
      Height = 156
      Caption = 'Ingredientes'
      TabOrder = 4
      object Image2: TImage
        Left = 15
        Top = 22
        Width = 194
        Height = 122
        Stretch = True
      end
    end
  end
  object DS_LANCHES_SP_CON: TDataSource
    AutoEdit = False
    DataSet = MODULE.LANCHES_SP_CON
    Left = 232
    Top = 113
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 232
    Top = 176
  end
  object LANCHEINGR_SP_SEL: TDataSource
    DataSet = MODULE.LANCHEINGR_SP_SEL
    Left = 611
    Top = 119
  end
  object OpenDialog1: TOpenDialog
    Left = 368
    Top = 120
  end
end
