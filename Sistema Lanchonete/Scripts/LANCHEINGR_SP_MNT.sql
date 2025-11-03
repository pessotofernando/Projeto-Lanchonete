GO
DROP PROCEDURE LANCHEINGR_SP_MNT
GO
CREATE PROCEDURE LANCHEINGR_SP_MNT
(
	@INP_LANCHE		INTEGER,
	@INP_ITEM		INTEGER,
	@INP_CODING		INTEGER,

	@INP_STATUS		VARCHAR(03)

)

WITH ENCRYPTION
AS

DECLARE
@V_CONT		INTEGER		

	SELECT	@V_CONT		=	0	

	IF	@INP_STATUS	=	'MNT'		GOTO	MANUTENCAO
	IF	@INP_STATUS	=	'EXC'		GOTO	EXCLUI
									GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT		=	1
	FROM	LANCHEINGR
	WHERE	LANCHEINGR.LAN_CODIGO	=	@INP_LANCHE	AND
			LANCHEINGR.LIN_ITEM		=	@INP_ITEM	AND
			LANCHEINGR.ING_CODIGO	=	@INP_CODING
			
	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
						GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	
	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	MAX(LIN_ITEM)
	FROM	LANCHEINGR
	WHERE	LANCHEINGR.LAN_CODIGO	=	@INP_LANCHE

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 


	INSERT INTO LANCHEINGR
	(
			LAN_CODIGO	,
			LIN_ITEM	,
			ING_CODIGO	,
			LIN_VALOR	
	)

	SELECT	@INP_LANCHE		,
			@V_CONT			,		
			@INP_CODING		,
			ING_VALOR 	
	FROM INGREDIENTES
	WHERE ING_CODIGO = @INP_CODING
	

	UPDATE	LANCHES SET
			LAN_VALORTOTAL		=	(SELECT isnull(SUM(LIN_VALOR),0) FROM LANCHEINGR WHERE LANCHEINGR.LAN_CODIGO = @INP_LANCHE)
	WHERE	LAN_CODIGO			=	@INP_LANCHE


GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	UPDATE	LANCHEINGR	SET

			LIN_VALOR	= (SELECT ING.ING_VALOR FROM INGREDIENTES ING WHERE ING.ING_CODIGO = @INP_CODING)
	
	WHERE	LANCHEINGR.LAN_CODIGO	=	@INP_LANCHE	AND
			LANCHEINGR.LIN_ITEM		=	@INP_ITEM	AND
			LANCHEINGR.ING_CODIGO	=	@INP_CODING


GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------

	DELETE	
	FROM	LANCHEINGR
	WHERE	LANCHEINGR.LAN_CODIGO	=	@INP_LANCHE	AND
			LANCHEINGR.LIN_ITEM		=	@INP_ITEM	AND
			LANCHEINGR.ING_CODIGO	=	@INP_CODING



	UPDATE	LANCHES SET
			LAN_VALORTOTAL		=	(SELECT isnull(SUM(LIN_VALOR),0) FROM LANCHEINGR WHERE LANCHEINGR.LAN_CODIGO = @INP_LANCHE)
	WHERE	LAN_CODIGO			=	@INP_LANCHE


GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------

RETURN