GO
DROP PROCEDURE INGREDIENTES_SP_MNT
GO
CREATE PROCEDURE INGREDIENTES_SP_MNT
(
@INP_STATUS	VARCHAR(03)	,
@INP_CODIGO	INTEGER		,
@INP_DESCRI	VARCHAR(70)	,
@INP_VALOR	FLOAT		,
@INP_IMAGEM	VARCHAR(200),
@INP_LANCHE	VARCHAR(01)	,

@OUT_CODIGO	INTEGER			OUTPUT	,
@OUT_DESCRI	VARCHAR(70)		OUTPUT	,
@OUT_VALOR	FLOAT			OUTPUT	,
@OUT_IMAGEM	VARCHAR(200)	OUTPUT	,	
@OUT_LANCHE	VARCHAR(01)		OUTPUT	,

@OUT_CODERR	INTEGER			OUTPUT	,
@OUT_MENERR	VARCHAR(200)	OUTPUT	
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

	SELECT	@V_CONT		=	1				,
			@OUT_CODIGO	=	ING_CODIGO		,		
			@OUT_DESCRI	=	ING_DESCRICAO	,
			@OUT_VALOR	=	ING_VALOR		,
			@OUT_IMAGEM	=	ING_IMAGEM		,
			@OUT_LANCHE	=	ING_LANCHE	

	FROM	INGREDIENTES
	WHERE	INGREDIENTES.ING_CODIGO	=	@INP_CODIGO	


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
	FROM	INGREDIENTES
	WHERE	INGREDIENTES.ING_CODIGO	=	@INP_CODIGO

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
						GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	
	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	MAX(ING_CODIGO)
	FROM	INGREDIENTES

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 


	INSERT INTO INGREDIENTES
	(
		ING_CODIGO		,
		ING_DESCRICAO	,
		ING_VALOR		,
		ING_IMAGEM		,
		ING_LANCHE
	)
	
	SELECT	@V_CONT		,		
			@INP_DESCRI	,
			@INP_VALOR	,
			@INP_IMAGEM	,
			@INP_LANCHE
	
	
	SELECT	@OUT_CODIGO	=	@V_CONT

GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	UPDATE	INGREDIENTES	SET

			ING_DESCRICAO	=	@INP_DESCRI	,
			ING_VALOR		=	@INP_VALOR	,
			ING_IMAGEM		=	@INP_IMAGEM	,
			ING_LANCHE		=	@INP_LANCHE

	FROM	INGREDIENTES
	WHERE	INGREDIENTES.ING_CODIGO	=	@INP_CODIGO


GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------

	DELETE	INGREDIENTES	
	WHERE	INGREDIENTES.ING_CODIGO	=	@INP_CODIGO	


GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
PROXIMO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MIN(ING_CODIGO)
	FROM	INGREDIENTES
	WHERE	ING_CODIGO	>	@INP_CODIGO

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA
	

---------------------------------------------------------------------------------------------------------------------------------------
ANTERIOR:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MAX(ING_CODIGO)
	FROM	INGREDIENTES
	WHERE	ING_CODIGO	<	@INP_CODIGO

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------

RETURN