unit U_Cardapio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Menus, Vcl.AppEvnts, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFr_Cardapio = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    DBGrid1: TDBGrid;
    GroupBox3: TGroupBox;
    DBGrid2: TDBGrid;
    GroupBox4: TGroupBox;
    Image1: TImage;
    DS_LANCHES_SP_CON: TDataSource;
    ApplicationEvents1: TApplicationEvents;
    LANCHEINGR_SP_SEL: TDataSource;
    OpenDialog1: TOpenDialog;
    valor: TEdit;
    Label1: TLabel;
    GroupBox5: TGroupBox;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CARDAPIO_LIMPA;

    procedure LANCHES_SP_CON;
    procedure LANCHES_LER;

    procedure LANCHESINGREDIENTES;
    procedure INGREDIENTES_LER;
  end;

var
  Fr_Cardapio: TFr_Cardapio;

implementation

uses u_module;

{$R *.dfm}

procedure TFr_Cardapio.DBGrid1CellClick(Column: TColumn);
begin
   LANCHES_LER;
   LANCHESINGREDIENTES;
end;

procedure TFr_Cardapio.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   LANCHES_LER;
   LANCHESINGREDIENTES;
end;

procedure TFr_Cardapio.DBGrid2CellClick(Column: TColumn);
begin
   INGREDIENTES_LER;
end;

procedure TFr_Cardapio.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   INGREDIENTES_LER;
end;

procedure TFr_Cardapio.FormCreate(Sender: TObject);
begin
   CARDAPIO_LIMPA;

   MODULE.LANCHES_SP_CON.close;
   MODULE.LANCHEINGR_SP_SEL.close;

   LANCHES_SP_CON;
   LANCHES_LER;

   LANCHESINGREDIENTES;
   INGREDIENTES_LER
end;

Procedure  TFr_Cardapio.CARDAPIO_LIMPA;
begin
   valor.Text  := '';
   Image1.Picture.Assign(nil);
   Image2.Picture.Assign(nil);
end;


procedure TFr_Cardapio.LANCHES_SP_CON;
begin

   with Module.LANCHES_SP_CON do
   begin
      close;
      parambyname('@INP_CODIGO').asinteger := 0;
      execproc;open;first;
   end;

end;


procedure TFr_Cardapio.LANCHES_LER;
var
  var_imagem : string;
begin

   var_imagem := '';

   with Module.LANCHES_SP_CON do
   begin
      valor.Text   := FormatFloat('###,##0.00',fieldbyname('LAN_VALORTOTAL' ).asfloat);

      var_imagem   := fieldbyname('LAN_IMAGEM' ).asstring;
      Image1.Picture.Assign(nil);
      if var_imagem <> '' then Image1.Picture.LoadFromFile(var_imagem);
   end;

end;



procedure TFr_Cardapio.LANCHESINGREDIENTES;
begin
   with MODULE.LANCHEINGR_SP_SEL do
   begin
      close;
      parambyname('@INP_LANCHE').asinteger := Module.LANCHES_SP_CON.FieldByName('LAN_CODIGO').AsInteger;
      execproc;open;first;
   end;
end;


procedure TFr_Cardapio.INGREDIENTES_LER;
var
  var_imagem : string;
begin

   var_imagem := '';

   with MODULE.LANCHEINGR_SP_SEL do
   begin
      var_imagem   := fieldbyname('ING_IMAGEM' ).asstring;
      Image2.Picture.Assign(nil);
      if var_imagem <> '' then Image2.Picture.LoadFromFile(var_imagem);
   end;

end;


end.
