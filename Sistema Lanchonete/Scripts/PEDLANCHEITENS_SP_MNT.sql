GO
DROP PROCEDURE PEDLANCHEITENS_SP_MNT
GO
CREATE PROCEDURE PEDLANCHEITENS_SP_MNT
(
@INP_STATUS		VARCHAR(3)	,
@INP_PEDIDO		INTEGER		,
@INP_ITEM		INTEGER		,
@INP_INGITEM	INTEGER		,
@INP_INGCOD		INTEGER		
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

	SELECT	@V_CONT		=	MAX(ING_ITEM)
	FROM	PEDLANCHEITENS PEI
	WHERE	PEI.PED_CODIGO	=	@INP_PEDIDO		AND
			PEI.PED_ITEM	=	@INP_ITEM		

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 

	
	INSERT INTO PEDLANCHEITENS
	(
			PED_CODIGO	,
			PED_ITEM	,
			ING_ITEM	,
			ING_CODIGO	,
			PED_VALOR	

	)
	SELECT	@INP_PEDIDO	,
			@INP_ITEM	,
			@V_CONT		,
			ING_CODIGO	,
			ING_VALOR
	FROM	INGREDIENTES
	WHERE	ING_CODIGO	=	@INP_INGCOD


	--------------------------------------------------------------------------------
	-- TOTAL DOS INGREDIENTES
	--------------------------------------------------------------------------------
	
	SELECT	@V_TOTALING	=	ISNULL(SUM(PED_VALOR),0)
	FROM	PEDLANCHEITENS	
	WHERE	PED_CODIGO	=	@INP_PEDIDO	and
			PED_ITEM	=	@INP_ITEM	
			
	
	--------------------------------------------------------------------------------
	-- ATUALIZA O VALOR DO LANCHE
	--------------------------------------------------------------------------------
	UPDATE	PEDLANCHE	SET
			PED_VALOR	=	@V_TOTALING
	WHERE	PED_CODIGO	=	@INP_PEDIDO	and
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


GOTO FAZNADA

-------------------------------------------------------------------------------
EXCLUI:
-------------------------------------------------------------------------------


	DELETE	PEDLANCHEITENS 
	WHERE	PED_CODIGO	=	@INP_PEDIDO		AND
			PED_ITEM	=	@INP_ITEM		AND
			ING_CODIGO	=	@INP_INGCOD		AND
			ING_ITEM	=	@INP_INGITEM

	
	--------------------------------------------------------------------------------
	-- TOTAL DOS INGREDIENTES
	--------------------------------------------------------------------------------
	
	SELECT	@V_TOTALING	=	ISNULL(SUM(PED_VALOR),0)
	FROM	PEDLANCHEITENS	
	WHERE	PED_CODIGO	=	@INP_PEDIDO	and
			PED_ITEM	=	@INP_ITEM	
			
	
	--------------------------------------------------------------------------------
	-- ATUALIZA O VALOR DO LANCHE
	--------------------------------------------------------------------------------
	UPDATE	PEDLANCHE	SET
			PED_VALOR	=	@V_TOTALING
	WHERE	PED_CODIGO	=	@INP_PEDIDO	and
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
