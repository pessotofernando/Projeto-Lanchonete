GO
DROP PROCEDURE PEDLANCHE_SP_MNT
GO
CREATE PROCEDURE PEDLANCHE_SP_MNT
(
@INP_STATUS		VARCHAR(3)	,
@INP_PEDIDO		INTEGER		,
@INP_ITEM		INTEGER		,
@INP_LANCHE		INTEGER		
)

WITH ENCRYPTION 
AS
DECLARE

@V_CONT			INTEGER	,
@V_TOTALING		FLOAT	,
@V_TOTALADI		FLOAT


	SELECT	@V_CONT			=	0
	SELECT	@V_TOTALING		=	0
	SELECT	@V_TOTALADI		=	0


	IF	@INP_STATUS	=	'MNT'		GOTO	MANUTENCAO
	IF	@INP_STATUS	=	'EXC'		GOTO	EXCLUI
									GOTO	FAZNADA

-------------------------------------------------------------------------------
MANUTENCAO:
-------------------------------------------------------------------------------

	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	MAX(PED_ITEM)
	FROM	PEDLANCHE
	WHERE	PED_CODIGO	=	@INP_PEDIDO	

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 

	
	INSERT INTO PEDLANCHE
	(
			PED_CODIGO	,
			PED_ITEM	,
			LAN_CODIGO	,
			PED_VALOR
	)
	SELECT	@INP_PEDIDO	,
			@V_CONT		,
			LAN_CODIGO	,
			LAN_VALORTOTAL
	FROM	LANCHES
	WHERE	LAN_CODIGO	=	@INP_LANCHE


----------------------------------------------------------------
-- INCLUSAO DOS INGREDIENTES DO LANCHE - PADRAO
----------------------------------------------------------------
	
	INSERT INTO PEDLANCHEITENS
	(
			PED_CODIGO	,
			PED_ITEM	,	
			ING_CODIGO	,
			ING_ITEM	,
			PED_VALOR
	)
	SELECT	@INP_PEDIDO	,
			@V_CONT		,
			ING_CODIGO	,
			LIN_ITEM	,
			LIN_VALOR
	FROM	LANCHEINGR
	WHERE	LAN_CODIGO	=	@INP_LANCHE



	--------------------------------------------------------------------------------
	-- TOTAL DOS INGREDIENTES
	--------------------------------------------------------------------------------
	
	SELECT	@V_TOTALING	=	ISNULL(SUM(PED_VALOR),0)
	FROM	PEDLANCHEITENS	
	WHERE	PED_CODIGO	=	@INP_PEDIDO

	--------------------------------------------------------------------------------
	-- TOTAL DOS ADICIONAIS
	--------------------------------------------------------------------------------
	SELECT	@V_TOTALADI	=	ISNULL(SUM(PEA_VALOR),0)
	FROM	PEDADICIONAL
	WHERE	PED_CODIGO	=	@INP_PEDIDO


	--------------------------------------------------------------------------------
	-- ATUALIZA O VALOR TOTAL
	--------------------------------------------------------------------------------
	UPDATE	PEDIDO		SET
			PED_VALOR	=	@V_TOTALING	+	@V_TOTALADI
	WHERE	PED_CODIGO	=	@INP_PEDIDO


GOTO FAZNADA

-------------------------------------------------------------------------------
EXCLUI:
-------------------------------------------------------------------------------


	DELETE	PEDLANCHE
	WHERE	PED_CODIGO	=	@INP_PEDIDO	AND
			PED_ITEM	=	@INP_ITEM	


	DELETE	PEDLANCHEITENS
	WHERE	PED_CODIGO	=	@INP_PEDIDO	AND
			PED_ITEM	=	@INP_ITEM		


	--------------------------------------------------------------------------------
	-- TOTAL DOS INGREDIENTES
	--------------------------------------------------------------------------------
	
	SELECT	@V_TOTALING	=	ISNULL(SUM(PED_VALOR),0)
	FROM	PEDLANCHEITENS	
	WHERE	PED_CODIGO	=	@INP_PEDIDO

	--------------------------------------------------------------------------------
	-- TOTAL DOS ADICIONAIS
	--------------------------------------------------------------------------------
	SELECT	@V_TOTALADI	=	ISNULL(SUM(PEA_VALOR),0)
	FROM	PEDADICIONAL
	WHERE	PED_CODIGO	=	@INP_PEDIDO


	--------------------------------------------------------------------------------
	-- ATUALIZA O VALOR TOTAL
	--------------------------------------------------------------------------------
	UPDATE	PEDIDO		SET
			PED_VALOR	=	@V_TOTALING	+	@V_TOTALADI
	WHERE	PED_CODIGO	=	@INP_PEDIDO


GOTO	FAZNADA



-------------------------------------------------------------------------------
FAZNADA:
-------------------------------------------------------------------------------
RETURN
