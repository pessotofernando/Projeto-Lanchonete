unit U_Pes_Usuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, u_Frame_impressao, DB,
  AppEvnts;

type
  TFr_Pes_Usuarios = class(TForm)
    Frame_Impressao1: TFrame_Impressao;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Codigo: TEdit;
    descri: TEdit;
    ds_USUARIO_SP_SEL: TDataSource;
    ApplicationEvents1: TApplicationEvents;
    procedure Frame_Impressao1BntFecharClick(Sender: TObject);
    procedure Frame_Impressao1BntLimpaClick(Sender: TObject);
    procedure CodigoExit(Sender: TObject);
    procedure descriExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Frame_Impressao1BntGravaClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure retorna_Usuarios;
    procedure limpa_campos;
  end;

var
  Fr_Pes_Usuarios: TFr_Pes_Usuarios;
  var_fr_tecla  : string;

implementation


uses u_module,u_valida,u_rot_busca;
{$R *.dfm}

procedure TFr_Pes_Usuarios.Frame_Impressao1BntFecharClick(Sender: TObject);
begin
   close;
end;

procedure TFr_Pes_Usuarios.Frame_Impressao1BntLimpaClick(Sender: TObject);
begin
   limpa_campos;
   retorna_Usuarios;
end;

procedure TFr_Pes_Usuarios.CodigoExit(Sender: TObject);
begin
   if var_fr_tecla <> '13' then exit;

   retorna_Usuarios;
end;

procedure TFr_Pes_Usuarios.retorna_Usuarios;
begin
   with Module.USUARIO_SP_SEL do
   begin
      close;
      parambyname('@INP_SIGLA').asstring  := codigo.text;
      parambyname('@INP_DESCRI').asstring := descri.text;
      execproc;open;first;
   end;

end;

procedure TFr_Pes_Usuarios.limpa_campos;
begin
   codigo.Text := '';
   descri.text := '';

   activecontrol := codigo;
end;

procedure TFr_Pes_Usuarios.descriExit(Sender: TObject);
begin
   retorna_Usuarios;
end;

procedure TFr_Pes_Usuarios.FormCreate(Sender: TObject);
begin
   Frame_Impressao1BntLimpaClick(Frame_Impressao1.BntLimpa);
end;

procedure TFr_Pes_Usuarios.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   if ((var_fr_tecla = '27') and (key = 27)) then close;

   var_fr_tecla :=  inttostr(key);

   if key = 13 then SelectNext(activecontrol,true,true);
   if key = 27 then Frame_Impressao1BntLimpaClick(Frame_Impressao1.BntLimpa);
   if key = 38 then SelectNext(activecontrol,false,true);


   if key = Vk_f5 then Frame_Impressao1BntGravaClick(Frame_Impressao1.BntGrava);
   if key = Vk_F12 then close;
end;

procedure TFr_Pes_Usuarios.Frame_Impressao1BntGravaClick(Sender: TObject);
begin

   if not Module.USUARIO_SP_SEL.active then exit;
   if Module.USUARIO_SP_SEL.FieldByName('USU_SIGLA').asstring = '' then exit;

   paramentros[1] := Module.USUARIO_SP_SEL.fieldbyname('USU_SIGLA').asstring;
   paramentros[2] := Module.USUARIO_SP_SEL.fieldbyname('USU_NOME').asstring;

   close;
end;

procedure TFr_Pes_Usuarios.DBGrid1DblClick(Sender: TObject);
begin
   Frame_Impressao1BntGravaClick(Frame_Impressao1.BntGrava);
end;

procedure TFr_Pes_Usuarios.ApplicationEvents1Message(var Msg: tagMSG;var Handled: Boolean);
var
  i : Smallint;
begin
   case Msg.Message of WM_KEYDOWN:
   begin
      if (Msg.wParam = VK_TAB) then var_fr_tecla := '13';
    end;
  end;

  // rolagem do scroll do mouse no DBGrid
  if Msg.message = WM_MOUSEWHEEL then
  begin
     Msg.message := WM_KEYDOWN;
     Msg.lParam := 0;

     i := HiWord(Msg.wParam);

     if i > 0 then Msg.wParam := VK_UP
     else
     Msg.wParam := VK_DOWN;
     Handled := False;
  end;

end;


procedure TFr_Pes_Usuarios.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 13 then  Frame_Impressao1BntGravaClick(Frame_Impressao1.BntGrava);
end;

end.
