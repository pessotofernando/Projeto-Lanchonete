GO
DROP PROCEDURE USUARIO_SP_MNT
GO
CREATE PROCEDURE USUARIO_SP_MNT
(
@INP_STATUS	VARCHAR(03)	,
@INP_SIGLA	VARCHAR(03)	,
@INP_NOME	VARCHAR(60)	,

@INP_CPF	VARCHAR(18)	,
@INP_RG		VARCHAR(15)	,
@INP_ENDERE	VARCHAR(80)	,
@INP_NUMERO	VARCHAR(08)	,
@INP_CIDADE	VARCHAR(30)	,
@INP_BAIRRO	VARCHAR(30)	,
@INP_CEP	VARCHAR(10)	,
@INP_ESTADO	VARCHAR(02)	,
@INP_TELEFONE	VARCHAR(15)	,
@INP_CELULAR	VARCHAR(15)	,
@INP_DATNAS		VARCHAR(10)	,

@INP_CONTATO	VARCHAR(20)	,
@INP_TELCONTATO	VARCHAR(15)	,
@INP_EMAIL	VARCHAR(50)	,
@INP_SENHA	VARCHAR(15)	,
@INP_NOVASENHA	VARCHAR(15)	,


@OUT_SIGLA	VARCHAR(03)	OUTPUT	,
@OUT_NOME	VARCHAR(60)	OUTPUT	,
@OUT_CPF	VARCHAR(18)	OUTPUT	,
@OUT_RG		VARCHAR(15)	OUTPUT	,
@OUT_ENDERE	VARCHAR(80)	OUTPUT	,
@OUT_NUMERO	VARCHAR(08)	OUTPUT	,
@OUT_CIDADE	VARCHAR(30)	OUTPUT	,
@OUT_BAIRRO	VARCHAR(30)	OUTPUT	,
@OUT_CEP	VARCHAR(10)	OUTPUT	,
@OUT_ESTADO	VARCHAR(02)	OUTPUT	,
@OUT_TELEFONE	VARCHAR(15)	OUTPUT	,
@OUT_CELULAR	VARCHAR(15)	OUTPUT	,
@OUT_DATNAS	VARCHAR(10)	OUTPUT	,

@OUT_CONTATO	VARCHAR(20)	OUTPUT	,
@OUT_TELCONTATO	VARCHAR(15)	OUTPUT	,
@OUT_EMAIL	VARCHAR(50)	OUTPUT	,

@OUT_SENHA	VARCHAR(15)	OUTPUT	,
@OUT_MENERR	VARCHAR(100)	OUTPUT	,
@OUT_CODERR	INTEGER		OUTPUT	
)

WITH ENCRYPTION 
AS

DECLARE
@V_CONT		INTEGER		


	IF	@INP_STATUS	=	'CON'		GOTO	CONSULTA
	IF	@INP_STATUS	=	'MNT'		GOTO	MANUTENCAO
	IF	@INP_STATUS	=	'EXC'		GOTO	EXCLUI

	IF	@INP_STATUS	=	'PRO'		GOTO	PROXIMO
	IF	@INP_STATUS	=	'ANT'		GOTO	ANTERIOR

	IF	@INP_STATUS	=	'VER'		GOTO	VERIFICA_SENHA
	IF	@INP_STATUS	=	'SEN'		GOTO	TROCA_SENHA	

							GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------
CONSULTA:
---------------------------------------------------------------------------------------------------------------------

	SELECT	@V_CONT			=	0	
	SELECT	@OUT_CODERR		=	0

	SELECT	@V_CONT		=	1		,
		@OUT_SIGLA	=	USU_SIGLA	,
		@OUT_NOME	=	USU_NOME	,
		@OUT_CPF	=	USU_CPF		,
		@OUT_RG		=	USU_RG		,
		@OUT_ENDERE	=	USU_ENDERE	,
		@OUT_NUMERO	=	USU_NUMERO	,
		@OUT_CIDADE	=	USU_CIDADE	,
		@OUT_BAIRRO	=	USU_BAIRRO	,
		@OUT_CEP	=	USU_CEP		,
		@OUT_ESTADO	=	USU_ESTADO	,
		@OUT_TELEFONE	=	USU_TELEFONE	,
		@OUT_CELULAR	=	USU_CELULAR	,
		@OUT_DATNAS		=	USU_DATNAS	,
		
		@OUT_CONTATO	=	USU_CONTATO	,
		@OUT_TELCONTATO	=	USU_TELCONTATO	,
		@OUT_EMAIL	=	USU_EMAIL	,
		@OUT_SENHA	=	USU_SENHA

	FROM	USUARIO
	WHERE	USUARIO.USU_SIGLA	=	@INP_SIGLA	


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
	FROM	USUARIO
	WHERE	USUARIO.USU_SIGLA	=	@INP_SIGLA

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0	GOTO	MANUTENCAO_INCLUI
	IF	@V_CONT		=	1	GOTO	MANUTENCAO_ALTERA
						GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_INCLUI:
---------------------------------------------------------------------------------------------------------------------------------------
	
	INSERT INTO USUARIO
	(
		USU_SIGLA	,
		USU_NOME	,
		USU_CPF		,
		USU_RG		,
		USU_ENDERE	,
		USU_NUMERO	,
		USU_CIDADE	,
		USU_BAIRRO	,
		USU_CEP		,
		USU_ESTADO	,
		USU_TELEFONE	,
		USU_CELULAR	,
		USU_DATNAS	,
		
		USU_CONTATO	,
		USU_TELCONTATO	,
		USU_EMAIL	,
		
		USU_SENHA
	)
	
	SELECT	@INP_SIGLA	,
		@INP_NOME	,
		@INP_CPF	,
		@INP_RG		,
		@INP_ENDERE	,
		@INP_NUMERO	,
		@INP_CIDADE	,
		@INP_BAIRRO	,
		@INP_CEP	,
		@INP_ESTADO	,
		@INP_TELEFONE	,
		@INP_CELULAR	,
		@INP_DATNAS	,
		
		@INP_CONTATO	,
		@INP_TELCONTATO	,
		@INP_EMAIL	,

		@INP_SENHA


GOTO	FAZNADA



---------------------------------------------------------------------------------------------------------------------------------------
MANUTENCAO_ALTERA:
---------------------------------------------------------------------------------------------------------------------------------------

	UPDATE	USUARIO	SET

		USU_NOME	=	@INP_NOME	,
		USU_CPF		=	@INP_CPF	,
		USU_RG		=	@INP_RG		,
		USU_ENDERE	=	@INP_ENDERE	,
		USU_NUMERO	=	@INP_NUMERO	,
		USU_CIDADE	=	@INP_CIDADE	,
		USU_BAIRRO	=	@INP_BAIRRO	,
		USU_CEP		=	@INP_CEP	,
		USU_ESTADO	=	@INP_ESTADO	,
		USU_TELEFONE	=	@INP_TELEFONE	,
		USU_CELULAR		=	@INP_CELULAR	,
		USU_DATNAS		=	@INP_DATNAS	,
		
		USU_CONTATO	=	@INP_CONTATO	,
		USU_TELCONTATO	=	@INP_TELCONTATO	,
		USU_EMAIL	=	@INP_EMAIL	

	FROM	USUARIO
	WHERE	USUARIO.USU_SIGLA	=	@INP_SIGLA


GOTO	FAZNADA




---------------------------------------------------------------------------------------------------------------------------------------
EXCLUI:
---------------------------------------------------------------------------------------------------------------------------------------


	DELETE	USUARIO	
	WHERE	USUARIO.USU_SIGLA	=	@INP_SIGLA	
		

GOTO	FAZNADA




-------------------------------------------------------------------------------------------------
VERIFICA_SENHA:
-------------------------------------------------------------------------------------------------
	
	SELECT	@V_CONT			=	0	
	SELECT	@OUT_CODERR		=	0


	SELECT	@V_CONT		=	1	,
			@OUT_NOME	=	USU_NOME	
	FROM	USUARIO
	WHERE	USU_SIGLA	=	@INP_SIGLA	AND
			USU_SENHA	=	@INP_SENHA	


	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0
	BEGIN

		SELECT	@OUT_CODERR	=	1,
				@OUT_MENERR	=	'Operação Cancelada. Usuario/Senha Não Cadastrado'
		GOTO	FAZNADA

	END
				
	GOTO	FAZNADA

---------------------------------------------------------------------------------------------------------------------------------------
TROCA_SENHA:
---------------------------------------------------------------------------------------------------------------------------------------
	
	SELECT	@V_CONT			=	0	
	SELECT	@OUT_CODERR		=	0

	SELECT	@V_CONT		=	1		
	FROM	USUARIO
	WHERE	USU_SIGLA	=	@INP_SIGLA	AND
			USU_SENHA	=	@INP_SENHA	

	IF	@V_CONT		IS	NULL	SELECT	@V_CONT		=	0

	IF	@V_CONT		=	0
	BEGIN

		SELECT	@OUT_CODERR	=	1,
				@OUT_MENERR	=	'Operação Cancelada. Senha Não Corresponde ao Usuario'
		GOTO	FAZNADA

	END

	
	UPDATE 	USUARIO SET
			USU_SENHA	=	@INP_NOVASENHA
	WHERE	USU_SIGLA	=	@INP_SIGLA	AND
		USU_SENHA	=	@INP_SENHA	
	

	GOTO	FAZNADA



---------------------------------------------------------------------------------------------------------------------------------------
PROXIMO:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_SIGLA	=	0	

	SELECT	@OUT_SIGLA	=	MIN(USU_SIGLA)
	FROM	USUARIO
	WHERE	USU_SIGLA	>	@INP_SIGLA

	IF	@OUT_SIGLA	IS	NULL	SELECT	@OUT_SIGLA	=	@INP_SIGLA

	GOTO	FAZNADA
	

---------------------------------------------------------------------------------------------------------------------------------------
ANTERIOR:
---------------------------------------------------------------------------------------------------------------------------------------

	SELECT	@OUT_SIGLA	=	0	

	SELECT	@OUT_SIGLA	=	MAX(USU_SIGLA)
	FROM	USUARIO
	WHERE	USU_SIGLA	<	@INP_SIGLA

	IF	@OUT_SIGLA	IS	NULL	SELECT	@OUT_SIGLA	=	@INP_SIGLA

	GOTO	FAZNADA


---------------------------------------------------------------------------------------------------------------------------------------
FAZNADA:
---------------------------------------------------------------------------------------------------------------------------------------
RETURN
