unit u_rot_busca;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask;


Function valida_acesso(usu,form:string):boolean;
Function busca_usuarios(campo:string): boolean;
Function busca_Endereco(campo:string): boolean;
Function busca_cliente(campo:string): boolean;

{
Function busca_Categoria(campo:string): boolean;
function busca_taxa(taxa,evento:string) :boolean;
Function busca_Equipe(campo:string): boolean;
Function busca_Piloto(campo:string): boolean;
Function busca_Carro(campo,Piloto,Item:string): boolean;
Function busca_Comerciante(campo:string): boolean;
Function busca_Cota(campo:string): boolean;
Function busca_patrocinadores(campo:string): boolean;

Function busca_vendedor(campo:string): boolean;
Function busca_Credencial(campo:string): boolean;
Function busca_boxes(modulo,boxe:string): boolean;
}

var
  Usuario     : string;
  Usu_nome    : string;
  Rot_status  : string;

  Rot_nodulo  : string;
  Rot_numbox  : string;
  Rot_evecod  : string;
  Rot_comcod  : string;
  Rot_patcod  : string;
  Rot_codigo  : string;
  Rot_cgccpf  : string;

  Rot_descri  : string;
  Rot_Valor   : string;
  Rot_quanti  : string;
  Rot_carbox  : string;
  Rot_Veiculo : string;
  Rot_Medida  : string;

  Rot_endere  : string;
  Rot_numero  : string;
  Rot_bairro  : string;
  Rot_cidade  : string;
  Rot_cep     : string;
  Rot_uf      : string;
  Rot_telefone: string;
  Rot_tiposan : string;
  Rot_rh      : string;
  Rot_rg      : string;
  Rot_cpf     : string;
  Rot_regcba  : string;
  Rot_email   : string;
  Rot_data    : string;
  Rot_eqpcod  : string;
  Rot_tipcome : string;
  Rot_CorCar  : string;


implementation

uses u_module;

Function valida_acesso(usu,form:string):boolean;
begin
   result := true;

   with MODULE.CONTROLE_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_SIGLA'  ).asstring := usu;
      parambyname('@INP_NOME'   ).asstring := form;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         Application.MessageBox(pchar(parambyname('@OUT_MENERR').asstring),'Pista',16);
         result := false;
         abort;
      end;
   end;

end;


Function busca_usuarios(campo:string): boolean;
begin

   result := true;

   with MODULE.USUARIO_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_SIGLA').asstring   := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         Application.MessageBox(pchar(parambyname('@OUT_MENERR').asstring),'Pista',16);
         abort;
      end;

      Rot_descri := parambyname('@OUT_NOME').asstring;
   end;

end;

Function busca_Endereco(campo:string): boolean;
begin
   result := true;

   with MODULE.ENDERECO_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS').asstring := 'CON';
      parambyname('@INP_CEP'   ).asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_endere    := parambyname('@OUT_ENDERE').asstring;
      Rot_bairro    := parambyname('@OUT_BAIRRO').asstring;
      Rot_cidade    := parambyname('@OUT_CIDADE').asstring;
      Rot_uf        := parambyname('@OUT_UF'	   ).asstring;
   end;
end;




Function busca_Cliente(campo:string): boolean;
begin

   result     := true;

   with MODULE.CLIENTE_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri := parambyname('@OUT_DESCRI').asstring;
   end;

end;

{
Function busca_Categoria(campo:string): boolean;
begin
   result     := true;
   Rot_descri := '';

   with MODULE.DCAT01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri := parambyname('@OUT_DESCRI').asstring;
      Rot_carbox := parambyname('@OUT_CARBOX').asstring;
   end;

end;


Function busca_Equipe(campo:string): boolean;
begin

   result := true;

   with MODULE.DEQP01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri := parambyname('@OUT_DESCRI').asstring;
   end;

end;


Function busca_Cota(campo:string): boolean;
begin

   result := true;

   with MODULE.DCOT01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri := parambyname('@OUT_DESCRI').asstring;
      Rot_Valor  := parambyname('@OUT_VALOR').asstring;
   end;

end;


Function busca_Piloto(campo:string): boolean;
begin
   result := true;

   with MODULE.DPIL01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri    := parambyname('@OUT_NOME'    ).asstring;
      Rot_endere    := parambyname('@OUT_ENDERE'	 ).asstring;
      Rot_numero    := parambyname('@OUT_NUMERO'	 ).asstring;
      Rot_bairro    := parambyname('@OUT_BAIRRO'	 ).asstring;
      Rot_cidade    := parambyname('@OUT_CIDADE'	 ).asstring;
      Rot_cep       := parambyname('@OUT_CEP'	    ).asstring;
      Rot_uf        := parambyname('@OUT_ESTADO'	 ).asstring;
      Rot_telefone  := parambyname('@OUT_TELEFONE').asstring;
      Rot_tiposan   := parambyname('@OUT_TIPSANG'	).asstring;
      Rot_rh        := parambyname('@OUT_FATORRH'	).asstring;
      Rot_rg        := parambyname('@OUT_RG'		    ).asstring;
      Rot_cpf       := parambyname('@OUT_CPF'	    ).asstring;
      Rot_regcba    := parambyname('@OUT_REGCBA'  ).asstring;
      Rot_email     := parambyname('@OUT_EMAIL'	  ).asstring;
      Rot_data      := parambyname('@OUT_DATNAS'	 ).asstring;
      Rot_eqpcod    := parambyname('@OUT_EQPCOD'	 ).asstring;
   end;
end;


Function busca_Carro(campo,Piloto,Item:string): boolean;
begin
   result := true;

   with Module.DCAR01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS').asstring := 'PCO';
      parambyname('@INP_CODIGO').asstring := campo;
      parambyname('@INP_PILCOD').asstring := piloto;
      parambyname('@INP_ITEM'  ).asstring := Item;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_Codigo   := parambyname('@OUT_CATCOD'	 ).asstring;
      Rot_Veiculo  := parambyname('@OUT_VEICAR'	 ).asstring;
      Rot_Numero   := parambyname('@OUT_NUMERO'	 ).asstring;
      Rot_CorCar   := parambyname('@OUT_COR'	    ).asstring;
   end;

end;

Function busca_Comerciante(campo:string): boolean;
begin
   result := true;

   with MODULE.DCOM01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri    := parambyname('@OUT_DESCRI' ).asstring;
      Rot_endere    := parambyname('@OUT_ENDERE' ).asstring;
      Rot_bairro    := parambyname('@OUT_BAIRRO' ).asstring;
      Rot_cidade    := parambyname('@OUT_CIDADE' ).asstring;
      Rot_cep       := parambyname('@OUT_CEP'    ).asstring;
      Rot_uf        := parambyname('@OUT_ESTADO' ).asstring;
      Rot_telefone  := parambyname('@OUT_TELEFO' ).asstring;
      Rot_cpf       := parambyname('@OUT_CGCCPF' ).asstring;
      Rot_tipcome   := parambyname('@OUT_TIPCOM' ).asstring;
   end;
end;




Function busca_Patrocinadores(campo:string): boolean;
begin
   result := true;

   with MODULE.DPAT01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring  := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri  := parambyname('@OUT_DESCRI'  ).asstring;
      Rot_cpf     := parambyname('@OUT_CGCCPF'	 ).asstring;

   end;
end;


Function busca_vendedor(campo:string): boolean;
begin

   result := true;

   with MODULE.DVED01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring   := campo;
      execproc;

      if parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         Application.MessageBox(pchar(parambyname('@OUT_MENERR').asstring),'Pista',16);
         abort;
      end;

      Rot_descri := parambyname('@OUT_NOME').asstring;
   end;

end;


Function busca_Credencial(campo:string): boolean;
begin

   result := true;

   with MODULE.DCRE01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS' ).asstring := 'CON';
      parambyname('@INP_CODIGO').asstring   := campo;
      execproc;

      if MODULE.DCRE01_SP_MNT.parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         result := false;
         exit;
      end;

      Rot_descri := parambyname('@OUT_DESCRI').asstring;
   end;

end;


Function busca_boxes(modulo,boxe:string): boolean;
begin

   result := true;

   with MODULE.DBOX01_SP_MNT do
   begin
      close;
      parambyname('@INP_STATUS').asstring := 'CON';
      parambyname('@INP_MODULO').asstring := modulo;
      parambyname('@INP_VAGAS' ).asstring := boxe;
      execproc;

      if MODULE.DBOX01_SP_MNT.parambyname('@OUT_CODERR').asinteger > 0 then
      begin
         Application.MessageBox(pchar(parambyname('@OUT_MENERR').asstring),'Pista',16);
         abort;
      end;

      Rot_medida  := parambyname('@OUT_MEDIDAS').asstring;
      Rot_quanti  := parambyname('@OUT_QUANTIDADE').asstring;
   end;
   
end;

}

end.


