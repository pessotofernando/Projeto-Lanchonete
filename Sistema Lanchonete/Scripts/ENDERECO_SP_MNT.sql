GO
DROP PROCEDURE ENDERECO_SP_MNT
GO
CREATE PROCEDURE ENDERECO_SP_MNT
(
@INP_STATUS	VARCHAR(03)	,
@INP_CEP	VARCHAR(09)	,
@INP_UF		VARCHAR(02)	,
@INP_BAIRRO	VARCHAR(80)	,
@INP_CIDADE	VARCHAR(80)	,
@INP_ENDERE	VARCHAR(120)	,

@OUT_CEP	VARCHAR(09)		OUTPUT	,
@OUT_UF		VARCHAR(02)		OUTPUT	,
@OUT_BAIRRO	VARCHAR(80)		OUTPUT	,
@OUT_CIDADE	VARCHAR(80)		OUTPUT	,
@OUT_ENDERE	VARCHAR(120)	OUTPUT	,

@OUT_CODERR	INTEGER			OUTPUT	,
@OUT_MENERR	VARCHAR(200)	OUTPUT	
)

WITH ENCRYPTION 
AS

DECLARE
@V_CONT		INTEGER		

	SELECT	@V_CONT		=	0
	SELECT  @OUT_CODERR	=	0

	IF	@INP_STATUS	=	'CON'		GOTO	CONSULTA
	IF	@INP_STATUS	=	'MNT'		GOTO	MANUTENCAO
	IF	@INP_STATUS	=	'EXC'		GOTO	EXCLUI
									GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
CONSULTA:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT		=	0
	
	SELECT	@V_CONT		=	1		,
			@OUT_CEP	=	LTRIM(RTRIM(END_CEP))		,
			@OUT_UF		=	LTRIM(RTRIM(END_UF))		,
			@OUT_BAIRRO	=	LTRIM(RTRIM(END_BAIRRO))	,
			@OUT_CIDADE	=	LTRIM(RTRIM(END_CIDADE))	,
			@OUT_ENDERE	=	LTRIM(RTRIM(END_ENDERECO))	

	FROM	ENDERECO
	WHERE	ENDERECO.END_CEP	=	@INP_CEP		

	IF	@V_CONT	 IS	NULL	SELECT	@V_CONT		=	0	


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
	FROM	ENDERECO
	WHERE	ENDERECO.END_CEP	=	@INP_CEP		

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
						GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	
	INSERT INTO ENDERECO
	(
		END_CEP		,
		END_UF 		,
		END_BAIRRO 	,
		END_CIDADE 	,
		END_ENDERECO 	
	)
	
	SELECT	@INP_CEP	,
		@INP_UF		,
		@INP_BAIRRO	,
		@INP_CIDADE	,
		@INP_ENDERE


GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	UPDATE	ENDERECO	SET

		END_UF 		=	@INP_UF		,
		END_BAIRRO 	=	@INP_BAIRRO	,
		END_CIDADE 	=	@INP_CIDADE	,
		END_ENDERECO 	=	@INP_ENDERE	

	FROM	ENDERECO
	WHERE	ENDERECO.END_CEP	=	@INP_CEP		

GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------

	DELETE	ENDERECO	
	WHERE	ENDERECO.END_CEP	=	@INP_CEP		


GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------

RETURN