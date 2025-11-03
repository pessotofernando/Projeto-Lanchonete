GO
DROP PROCEDURE CLIENTE_SP_MNT
GO
CREATE PROCEDURE CLIENTE_SP_MNT
(
@INP_STATUS		VARCHAR(03)	,
@INP_CODIGO		VARCHAR(03)	,
@INP_DESCRI		VARCHAR(60)	,

@INP_CPF		VARCHAR(15)	,
@INP_ENDERE		VARCHAR(80)	,
@INP_NUMERO		VARCHAR(08)	,
@INP_CIDADE		VARCHAR(30)	,
@INP_BAIRRO		VARCHAR(30)	,
@INP_CEP		VARCHAR(10)	,
@INP_ESTADO		VARCHAR(02)	,
@INP_TELEFONE	VARCHAR(15)	,
@INP_CELULAR	VARCHAR(15)	,

@OUT_CODIGO		VARCHAR(03)	OUTPUT	,
@OUT_DESCRI		VARCHAR(60)	OUTPUT	,
@OUT_CPF		VARCHAR(15)	OUTPUT	,
@OUT_ENDERE		VARCHAR(80)	OUTPUT	,
@OUT_NUMERO		VARCHAR(08)	OUTPUT	,
@OUT_CIDADE		VARCHAR(30)	OUTPUT	,
@OUT_BAIRRO		VARCHAR(30)	OUTPUT	,
@OUT_CEP		VARCHAR(10)	OUTPUT	,
@OUT_ESTADO		VARCHAR(02)	OUTPUT	,
@OUT_TELEFONE	VARCHAR(15)	OUTPUT	,
@OUT_CELULAR	VARCHAR(15)	OUTPUT	,
@OUT_DATA		VARCHAR(10)	OUTPUT	,


@OUT_MENERR	VARCHAR(100)	OUTPUT	,
@OUT_CODERR	INTEGER			OUTPUT	
)

WITH ENCRYPTION 
AS

DECLARE
@V_CONT		INTEGER		

	SELECT	@V_CONT		=	0	
	SELECT	@OUT_CODERR	=	0

	IF	@INP_STATUS	=	'CON'		GOTO	CONSULTA
	IF	@INP_STATUS	=	'MNT'		GOTO	MANUTENCAO
	IF	@INP_STATUS	=	'EXC'		GOTO	EXCLUI

	IF	@INP_STATUS	=	'PRO'		GOTO	PROXIMO
	IF	@INP_STATUS	=	'ANT'		GOTO	ANTERIOR
							GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------
CONSULTA:
---------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	1				,
		@OUT_CODIGO		=	CLI_CODIGO		,
		@OUT_DESCRI		=	CLI_DESCRI		,
		@OUT_CPF		=	CLI_CPF			,		
		@OUT_ENDERE		=	CLI_ENDERE		,
		@OUT_NUMERO		=	CLI_NUMERO		,
		@OUT_CIDADE		=	CLI_CIDADE		,
		@OUT_BAIRRO		=	CLI_BAIRRO		,
		@OUT_CEP		=	CLI_CEP			,
		@OUT_ESTADO		=	CLI_ESTADO		,
		@OUT_TELEFONE	=	CLI_TELEFONE	,
		@OUT_CELULAR	=	CLI_CELULAR		,
		@OUT_DATA		=	CLI_DATA	
	
	FROM	CLIENTE
	WHERE	CLIENTE.CLI_CODIGO	=	@INP_CODIGO	


	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	


	IF	@V_CONT		=	0	
	BEGIN
		SELECT	@OUT_CODERR	=	1	,
				@OUT_MENERR	=	'Operação Cancelada. Registro Não Cadastrado'
		GOTO	FAZNADA
	END


GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	1
	FROM	CLIENTE
	WHERE	CLIENTE.CLI_CODIGO	=	@INP_CODIGO

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
							GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	

	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	MAX(CLI_CODIGO)
	FROM	CLIENTE

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 


	INSERT INTO CLIENTE
	(
		CLI_CODIGO		,
		CLI_DESCRI		,
		CLI_CPF			,		
		CLI_ENDERE		,
		CLI_NUMERO		,
		CLI_CIDADE		,
		CLI_BAIRRO		,
		CLI_CEP			,
		CLI_ESTADO		,
		CLI_TELEFONE	,
		CLI_CELULAR		,
		CLI_DATA
	)
	
	SELECT	@V_CONT		,
		@INP_DESCRI	,
		@INP_CPF	,		
		@INP_ENDERE	,
		@INP_NUMERO	,
		@INP_CIDADE	,
		@INP_BAIRRO	,
		@INP_CEP	,
		@INP_ESTADO	,
		@INP_TELEFONE,
		@INP_CELULAR,
		SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),1,10)

	SELECT	@OUT_CODIGO	=	@V_CONT
	SELECT  @OUT_DATA   =	SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),1,10)


GOTO	FAZNADA



---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	UPDATE	CLIENTE	SET

		CLI_DESCRI		=	@INP_DESCRI	,
		CLI_CPF			=	@INP_CPF	,		
		CLI_ENDERE		=	@INP_ENDERE	,
		CLI_NUMERO		=	@INP_NUMERO	,
		CLI_CIDADE		=	@INP_CIDADE	,
		CLI_BAIRRO		=	@INP_BAIRRO	,
		CLI_CEP			=	@INP_CEP	,
		CLI_ESTADO		=	@INP_ESTADO	,
		CLI_TELEFONE	=	@INP_TELEFONE	,
		CLI_CELULAR		=	@INP_CELULAR	
	
	FROM	CLIENTE
	WHERE	CLIENTE.CLI_CODIGO	=	@INP_CODIGO

	SELECT	@OUT_CODIGO		=	@INP_CODIGO

GOTO	FAZNADA




---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------


	DELETE	CLIENTE	
	WHERE	CLIENTE.CLI_CODIGO	=	@INP_CODIGO	
		

GOTO	FAZNADA



---------------------------------------------------------------------------------------------------------------------------------------
PROXIMO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MIN(CLI_CODIGO)
	FROM	CLIENTE
	WHERE	CLI_CODIGO	>	@INP_CODIGO

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA
	

---------------------------------------------------------------------------------------------------------------------------------------
ANTERIOR:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MAX(CLI_CODIGO)
	FROM	CLIENTE
	WHERE	CLI_CODIGO	<	@INP_CODIGO

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------
RETURN
