-- DML e DDL

-- CREATE TABLE (Criar tabelas)
CREATE TABLE IF NOT EXISTS relatorio_diario AS 
	WITH tb_soma_ponto_clientes AS (
		SELECT idcliente, DATE(dtcriacao) AS data_soma, SUM(qtdepontos) AS soma_pontos
		FROM transacoes
		GROUP BY idcliente, data_soma
	)
	SELECT *,
			SUM(soma_pontos) OVER (PARTITION BY idcliente ORDER BY data_soma) AS acumulado_pontos
	FROM tb_soma_ponto_clientes


SELECT *
FROM relatorio_diario


-- DROP TABLE (Apagar tabelas)
DROP TABLE IF EXISTS relatorio_diario


-- TRUNCATE TABLE (Apagar os dados da tabela)
TRUNCATE TABLE relatorio_diario 

-- ou DELETE TABLE
DELETE FROM relatorio_diario


-- INSERT INTO (Inserir dados na tabela)
-- Caso a tabela esteja vazia (após um TRUNCATE/DELETE FROM),
-- essa é a forma de preenchela com dados com o INSERT INTO
WITH tb_soma_ponto_clientes AS (
	SELECT idcliente, DATE(dtcriacao) AS data_soma, SUM(qtdepontos) AS soma_pontos
	FROM transacoes
	GROUP BY idcliente, data_soma
)
INSERT INTO relatorio_diario
SELECT *,
		SUM(soma_pontos) OVER (PARTITION BY idcliente ORDER BY data_soma) AS acumulado_pontos
FROM tb_soma_ponto_clientes

-- Só rodar o INSERT INTO pode fazer a tabela ter dados duplicados
-- a melhor maneira de usá-lo é apagar a tabela, e após usar o INSERT INTO


-- UPDATE TABLE 

-- Exemplo
-- Excluímos os domingos da tabela
DELETE FROM relatorio_diario
WHERE EXTRACT(DOW FROM data_soma) = 0

-- Não existem mais resultados na tabela de dias de domingo
SELECT *
FROM relatorio_diario AS rd
WHERE DATE(rd.data_soma) = '2024-02-11'


-- Como ficaria com o UPDATE
UPDATE relatorio_diario
SET soma_pontos = 1000
WHERE data_soma >= '2025-08-25'

SELECT *
FROM relatorio_diario AS rd
WHERE rd.data_soma >= '2025-08-20'




-- CREATE do Zero

-- Criando uma tabela de clientes do último mês
DROP TABLE IF EXISTS cliente_365

CREATE TABLE IF NOT EXISTS cliente_365(
	idCliente Varchar(250) PRIMARY KEY,
	qtDeTransacoes Integer
)

TRUNCATE TABLE cliente_365

INSERT INTO cliente_365
SELECT idcliente,
		COUNT(DISTINCT idtransacao) AS qtdetransacao
FROM transacoes
WHERE CURRENT_DATE - date(dtcriacao) <= 365
GROUP BY idcliente

SELECT * FROM cliente_365
