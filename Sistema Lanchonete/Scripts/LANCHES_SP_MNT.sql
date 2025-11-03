GO
DROP PROCEDURE LANCHES_SP_MNT
GO
CREATE PROCEDURE LANCHES_SP_MNT
(
@INP_STATUS		VARCHAR(03)	,
@INP_CODIGO		INTEGER		,
@INP_DESCRI		VARCHAR(70)	,
@INP_VALORTOT	FLOAT		,
@INP_IMAGEM		VARCHAR(200),	

@OUT_CODIGO		INTEGER			OUTPUT	,
@OUT_DESCRI		VARCHAR(70)		OUTPUT	,
@OUT_VALORTOT	FLOAT			OUTPUT	,
@OUT_IMAGEM		VARCHAR(200)	OUTPUT	,

@OUT_CODERR		INTEGER			OUTPUT	,
@OUT_MENERR		VARCHAR(200)	OUTPUT	
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

---------------------------------------------------------------------------------------------------------------------------------------
CONSULTA:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT			=	1				,
			@OUT_CODIGO		=	LAN_CODIGO		,		
			@OUT_DESCRI		=	LAN_DESCRICAO	,
			@OUT_VALORTOT	=	LAN_VALORTOTAL	,
			@OUT_IMAGEM		=	LAN_IMAGEM

	FROM	LANCHES
	WHERE	LANCHES.LAN_CODIGO	=	@INP_CODIGO	


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

	SELECT	@V_CONT		=	1
	FROM	LANCHES
	WHERE	LANCHES.LAN_CODIGO	=	@INP_CODIGO

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
						GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	
	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	MAX(LAN_CODIGO)
	FROM	LANCHES

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 


	INSERT INTO LANCHES
	(
		LAN_CODIGO		,
		LAN_DESCRICAO	,
		LAN_VALORTOTAL	,
		LAN_IMAGEM
	)
	
	SELECT	@V_CONT			,		
			@INP_DESCRI		,
			@INP_VALORTOT	,
			@INP_IMAGEM
	
	
	SELECT	@OUT_CODIGO	=	@V_CONT

GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	UPDATE	LANCHES	SET

			LAN_DESCRICAO	=	@INP_DESCRI		,
			LAN_VALORTOTAL	=	@INP_VALORTOT	,
			LAN_IMAGEM		=	@INP_IMAGEM

	FROM	LANCHES
	WHERE	LANCHES.LAN_CODIGO	=	@INP_CODIGO


	SELECT	@OUT_CODIGO			=	@INP_CODIGO

GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------

	DELETE	LANCHES	
	WHERE	LANCHES.LAN_CODIGO	=	@INP_CODIGO	


	DELETE	LANCHEINGR
	WHERE	LAN_CODIGO			=	@INP_CODIGO	


GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
PROXIMO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MIN(LAN_CODIGO)
	FROM	LANCHES
	WHERE	LAN_CODIGO	>	@INP_CODIGO

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA
	

---------------------------------------------------------------------------------------------------------------------------------------
ANTERIOR:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MAX(LAN_CODIGO)
	FROM	LANCHES
	WHERE	LAN_CODIGO	<	@INP_CODIGO

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------

RETURN