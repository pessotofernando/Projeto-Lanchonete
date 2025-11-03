GO
DROP PROCEDURE PEDIDO_SP_MNT
GO
CREATE PROCEDURE PEDIDO_SP_MNT
(
@INP_STATUS		VARCHAR(03)	,
@INP_CODIGO		INTEGER		,
@INP_CODCLI		INTEGER		,

@OUT_CODIGO		INTEGER			OUTPUT	,
@OUT_CODCLI		INTEGER			OUTPUT	,
@OUT_DATA		VARCHAR(15)		OUTPUT	,
@OUT_VALORTOT	FLOAT			OUTPUT	,
@OUT_DESCONTO	FLOAT			OUTPUT	,

@OUT_CODERR		INTEGER			OUTPUT	,
@OUT_MENERR		VARCHAR(200)	OUTPUT	
)

WITH ENCRYPTION 
AS

DECLARE
@V_CONT			INTEGER	,
@V_TOTALPED		FLOAT	,
@V_TOTALDES		FLOAT	,
@V_TOTALING		FLOAT	,	
@V_TOTALADI		FLOAT	,
@V_CLIENTE		INTEGER	,
@V_DATA			DATE	,
@V_DATAREF		DATE


	SELECT	@V_CONT		=	0	,
			@OUT_CODERR	=	0	,
			@V_TOTALING	=	0	,
			@V_TOTALADI	=	0	


	IF	@INP_STATUS	=	'CON'		GOTO	CONSULTA
	IF	@INP_STATUS	=	'MNT'		GOTO	MANUTENCAO
	IF	@INP_STATUS	=	'EXC'		GOTO	EXCLUI

	IF	@INP_STATUS	=	'DES'		GOTO	DESCONTO
	IF	@INP_STATUS	=	'REF'		GOTO	REFRIGERANTE_GRATIS

	IF	@INP_STATUS	=	'PRO'		GOTO	PROXIMO
	IF	@INP_STATUS	=	'ANT'		GOTO	ANTERIOR

							GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
CONSULTA:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT			=	1			,
			@OUT_CODIGO		=	PED_CODIGO	,
			@OUT_CODCLI		=	CLI_CODIGO	,
			@OUT_DATA		=	PED_DATA	,
			@OUT_VALORTOT	=	PED_VALOR	,
			@OUT_DESCONTO	=	PED_DESCONTO

	FROM	PEDIDO
	WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO	


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
	FROM	PEDIDO
	WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO	

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
							GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	
	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	MAX(PED_CODIGO)
	FROM	PEDIDO

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	

	SELECT	@V_CONT		=	@V_CONT + 1 


	INSERT INTO PEDIDO
	(
		PED_CODIGO		,
		CLI_CODIGO		,
		PED_DATA		
	)
	
	SELECT	@V_CONT		,		
			@INP_CODCLI	,
			SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),1,10)
	
	
	SELECT	@OUT_CODIGO	=	@V_CONT
	SELECT  @OUT_DATA   =	SUBSTRING(CONVERT(VARCHAR,GETDATE(),103),1,10)

GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- TOTAL DOS INGREDIENTES
	--------------------------------------------------------------------------------
	
	SELECT	@V_TOTALING	=	ISNULL(SUM(PED_VALOR),0)
	FROM	PEDLANCHEITENS	
	WHERE	PED_CODIGO	=	@INP_CODIGO

	--------------------------------------------------------------------------------
	-- TOTAL DOS ADICIONAIS
	--------------------------------------------------------------------------------
	SELECT	@V_TOTALADI	=	ISNULL(SUM(PEA_VALOR),0)
	FROM	PEDADICIONAL
	WHERE	PED_CODIGO	=	@INP_CODIGO


	--------------------------------------------------------------------------------
	-- ATUALIZA O VALOR TOTAL
	--------------------------------------------------------------------------------
	UPDATE	PEDIDO		SET
			PED_VALOR	=	@V_TOTALING	+	@V_TOTALADI
	WHERE	PED_CODIGO	=	@INP_CODIGO



GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------

	DELETE	PEDIDO	
	WHERE	PEDIDO.PED_CODIGO			=	@INP_CODIGO	

	DELETE	PEDLANCHE
	WHERE	PEDLANCHE.PED_CODIGO		=	@INP_CODIGO		

	DELETE	PEDLANCHEITENS
	WHERE	PEDLANCHEITENS.PED_CODIGO 	=	@INP_CODIGO	

	DELETE	PEDADICIONAL
	WHERE	PED_CODIGO					=	@INP_CODIGO


GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
PROXIMO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MIN(PED_CODIGO)
	FROM	PEDIDO
	WHERE	PEDIDO.PED_CODIGO	>	@INP_CODIGO	

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA
	

---------------------------------------------------------------------------------------------------------------------------------------
ANTERIOR:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_CODIGO	=	0	

	SELECT	@OUT_CODIGO	=	MAX(PED_CODIGO)
	FROM	PEDIDO
	WHERE	PEDIDO.PED_CODIGO	<	@INP_CODIGO	

	IF	@OUT_CODIGO	IS	NULL	SELECT	@OUT_CODIGO	=	@INP_CODIGO

	GOTO	FAZNADA



---------------------------------------------------------------------------------------------------------------------------------------
DESCONTO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@V_TOTALPED			=	0

	---------------------------------------------------------------------------------------
	--	ZERA O DESCONTO ANTES DE VERIFICAR SE O VALOR E MAIOR OU IGUAL A 50
	---------------------------------------------------------------------------------------
	UPDATE	PEDIDO	SET
			PED_DESCONTO		=	0					
	WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO	


	SELECT	@V_TOTALPED			=	ISNULL(SUM(PED_VALOR),0)
	FROM	PEDIDO
	WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO	


	IF		@V_TOTALPED			>=	50
	BEGIN
			
			SELECT	@V_TOTALDES		=	0

			SELECT	@V_TOTALDES		=	ROUND(((@V_TOTALPED * 3) / 100),2)
			
			UPDATE	PEDIDO	SET
					PED_DESCONTO		=	PED_DESCONTO	+	@V_TOTALDES	,
					PED_VALOR			=	PED_VALOR		-	@V_TOTALDES
			WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO	

			-------------------------------------------------------------------------------------
			--	VERIFICA SE O CLIENTE ESTA CADASTRADO A MAIS DE 6 MESES SE ESTIVER IRA 
			--  SER CONSEDIDO 5% DE DESCONTO
			-------------------------------------------------------------------------------------
			SELECT	@V_CLIENTE			=	CLI_CODIGO	
			FROM	PEDIDO
			WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO		

			------------------------------------------------------------------------------------
			-- BUSCA A DATA DE CRIAÇÃO DO CLIENTE 
			------------------------------------------------------------------------------------
			SELECT	@V_DATA		=	CONVERT(DATE,CLI_DATA, 103),
					@V_DATAREF	=	DATEADD(MONTH, -6, GETDATE())
			FROM	CLIENTE	
			WHERE	CLI_CODIGO	=	@V_CLIENTE

	
			SELECT	@V_CONT		=	0	

			SELECT	@V_CONT		=	1
			WHERE	@V_DATA		<=	@V_DATAREF

			IF		@V_CONT		IS	NULL	SELECT	@V_CONT	=	0

			IF	@V_CONT			>=	1
			BEGIN
				SELECT	@V_TOTALDES		=	ROUND(((@V_TOTALPED * 5) / 100),2)

				UPDATE	PEDIDO	SET
						PED_DESCONTO		=	PED_DESCONTO	+	@V_TOTALDES	,
						PED_VALOR			=	PED_VALOR		-	@V_TOTALDES
				WHERE	PEDIDO.PED_CODIGO	=	@INP_CODIGO	
		
			END
	END

	GOTO FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
REFRIGERANTE_GRATIS:
---------------------------------------------------------------------------------------------------------------------------------------
		
		----------------------------------------------------------------------------------------
		-- SEMPRE DELETAR ANTES DE FAZER A VERIFICAÇÃO NOVAMENTE POIS PODE ACONTECER DE FAZER A
		-- SOLICITAÇÃO MAS DEPOIS RECUSAR COM ISTO PRECISA SER RETIRADO DO PEDIDO
		----------------------------------------------------------------------------------------
		DELETE	PEDADICIONAL
		WHERE	PED_CODIGO		=	@INP_CODIGO
		  AND	PEA_ITEM		=	9999

		----------------------------------------------------
		-- VERIFICAR SE EXISTE NO PEDIDO UM ITEM DE 
		-- X SALADA E BATATA FRITA CASO TENHA 
		-- CRIAR UM ADICIONAL DE REFRIGERANTE COM VALOR ZERADO
		----------------------------------------------------
		SELECT	@V_CONT		=	0	
		
		SELECT	@V_CONT		=	1
		FROM	PEDIDO PED ,PEDLANCHE PEL,LANCHES LAN
		WHERE	PED.PED_CODIGO		=	@INP_CODIGO
		  AND	PED.PED_CODIGO		=	PEL.PED_CODIGO
		  AND	PEL.LAN_CODIGO		=	LAN.LAN_CODIGO		  
		  AND	LAN.LAN_DESCRICAO	LIKE('%SALADA%')
		
		IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0	
		
		IF	@V_CONT		=	1
		BEGIN
			
			SELECT	@V_CONT		=	0	

			SELECT	@V_CONT		=	1
			FROM	PEDIDO PED ,PEDADICIONAL PAD,INGREDIENTES ING
			WHERE	PED.PED_CODIGO		=	@INP_CODIGO
			  AND	PED.PED_CODIGO		=	PAD.PED_CODIGO
			  AND	PAD.ING_CODIGO		=	ING.ING_CODIGO
			  AND	ING.ING_DESCRICAO	LIKE ('%BATATA%FRITA')
			
			IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

			IF	@V_CONT		=	1
			BEGIN
				--------------------------------------------------------------
				--	INCLUIR UM ADICIONAL DE REFRIGENTE GRATIS
				--------------------------------------------------------------	
				INSERT INTO PEDADICIONAL
				(
					PED_CODIGO	,
					PEA_ITEM	,
					ING_CODIGO	,
					PEA_VALOR
				)
				SELECT	TOP 1
						@INP_CODIGO	,
						9999		,
						ING.ING_CODIGO	,
						0
				FROM	INGREDIENTES ING
				WHERE	ING.ING_DESCRICAO	LIKE ('%REFRIGERANTE%')

			END
		END

---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------

RETURN