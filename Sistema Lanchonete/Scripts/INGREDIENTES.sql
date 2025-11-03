GO
DROP TABLE INGREDIENTES
GO
CREATE TABLE INGREDIENTES
(	ING_CODIGO		INTEGER			NOT NULL	PRIMARY KEY	,
	ING_DESCRICAO	VARCHAR(50)		NOT NULL				,		
	ING_VALOR		DECIMAL(10,2)	NOT NULL	DEFAULT(0)	,
	ING_IMAGEM		VARCHAR(200)	NULL					,
	ING_LANCHE		VARCHAR(01)		NOT	NULL	DEFAULT('X')
)


insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 1,'HAMBURGUER',10.50,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 2,'ALFACE',2,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 3,'QUEIJO',5,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 4,'MOLHO',3,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 5,'PICLES',2.50,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 6,'TOMATE',1.5,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 7,'CEBOLA',1,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 8,'BACON',7.50,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 9,'SALSICHA',8,'X'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 10,'PURE',4.5,'N'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 11,'BATATA FRITA',15,'N'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 12,'REFRIGERANTE COCA COLA',12.5,'N'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 13,'REFRIGERANTE FANTA',12.5,'N'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 14,'SUCO DE UVA',11,'N'
insert into ingredientes (ing_codigo,ing_descricao,ing_valor,ing_lanche) select 15,'MANDIOCA FRITA',15,'N'