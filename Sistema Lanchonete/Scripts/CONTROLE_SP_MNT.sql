GO
DROP PROCEDURE 	CONTROLE_SP_MNT
GO
CREATE PROCEDURE CONTROLE_SP_MNT
(
@INP_STATUS	VARCHAR(03)	,
@INP_SIGLA	VARCHAR(03)	,		
@INP_NOME	VARCHAR(10)	,

@OUT_CODERR	INTEGER		OUTPUT	,
@OUT_MENERR	VARCHAR(100)	OUTPUT	
)

WITH ENCRYPTION 
AS
DECLARE	
@V_CONT		INTEGER		,
@V_SELECI	VARCHAR(01)	


	SELECT	@OUT_CODERR	=	0
	SELECT	@V_CONT		=	0
	SELECT	@V_SELECI	=	0


	IF	@INP_STATUS	=	'MDS'	GOTO	MARCA_DESMARCA
	IF	@INP_STATUS	=	'GRA'	GOTO	GRAVA_ACESSO
	IF	@INP_STATUS	=	'EXC'	GOTO	EXCLUIR_ACESSO
	IF	@INP_STATUS	=	'CON'	GOTO	CONSULTA_ACESSO
								GOTO	FAZNADA


------------------------------------------------------------------------------------------------------------
MARCA_DESMARCA:
------------------------------------------------------------------------------------------------------------

	SELECT	@V_SELECI	=	''

	SELECT	@V_SELECI	=	FOR_SELECI
	FROM	FORMULARIO_AUX
	WHERE	FOR_NOME	=	@INP_NOME

	IF	@V_SELECI	IS	NULL	SELECT	@V_SELECI	=	''

	IF	@V_SELECI	=	''	SELECT	@V_SELECI	=	'X'
	ELSE					SELECT	@V_SELECI	=	''


	UPDATE	FORMULARIO_AUX	SET

		FOR_SELECI	=	@V_SELECI
	
	FROM	FORMULARIO_AUX
	WHERE	FOR_NOME	=	@INP_NOME


GOTO	FAZNADA
	

------------------------------------------------------------------------------------------------------------
GRAVA_ACESSO:
------------------------------------------------------------------------------------------------------------
	
	DELETE FROM CONTROLE WHERE USU_SIGLA	=	@INP_SIGLA

	INSERT INTO CONTROLE
	(
		USU_SIGLA	,
		FOR_NOME	,
		CON_SELECI	
	)	
	
	SELECT	@INP_SIGLA	,
			FOR_NOME	,
			FOR_SELECI	

	FROM	FORMULARIO_AUX	
	WHERE	FOR_SELECI	=	'X'
	

GOTO	FAZNADA

------------------------------------------------------------------------------------------------------------
EXCLUIR_ACESSO:
------------------------------------------------------------------------------------------------------------

	DELETE	CONTROLE
	WHERE	USU_SIGLA	=	@INP_SIGLA	


	GOTO	FAZNADA

------------------------------------------------------------------------------------------------------------
CONSULTA_ACESSO:
------------------------------------------------------------------------------------------------------------


	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	1
	FROM	CONTROLE	WITH(NOLOCK)
	WHERE	USU_SIGLA	=	@INP_SIGLA	AND
			FOR_NOME	=	@INP_NOME	AND
			CON_SELECI	=	'X'		
	
	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	IF	@V_CONT		=	0
	BEGIN
		SELECT	@OUT_CODERR	=	1	,
			@OUT_MENERR	=	'Operação Cancelada. Usuario Sem Acesso!'

		GOTO	FAZNADA			
	END
	
	GOTO	FAZNADA

------------------------------------------------------------------------------------------------------------
FAZNADA:
------------------------------------------------------------------------------------------------------------

RETURN
