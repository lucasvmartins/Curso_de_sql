-- Primeiros SELECTs
SELECT idcliente, dtcriacao, dtatualizacao
FROM clientes
LIMIT 10


SELECT *
FROM produtos
LIMIT 4


SELECT *
FROM produtos
WHERE desccategoriaproduto != 'rpg'
LIMIT 10


-- Selecione todos os clientes com email cadastrado
SELECT *
FROM clientes
WHERE flemail = '1'


-- Selecione todas transações de 50 pontos (exatos)
SELECT * 
FROM transacoes
WHERE qtdepontos = 50


-- Selecione todos clientes com mais de 500 pontos
SELECT idcliente, qtdepontos, dtcriacao, dtatualizacao
FROM clientes
WHERE qtdepontos >= 500


-- Selecione produtos que contém 'churn' no nome
SELECT *
FROM produtos
WHERE descnomeproduto LIKE '%Churn%'


-- Adicionando nova coluna
SELECT idcliente,
		qtdepontos,
		dtcriacao,
		dtatualizacao,
		qtdepontos + 10 AS QtdePontos_mais_dez
FROM clientes


-- ALIAS (AS)
-- Renomeando colunas
SELECT idcliente,
		qtdepontos,
		qtdepontos + 10 AS QtdePontos_mais_dez,
		qtdepontos * 2 AS QtdePontos_vezes_dois
FROM clientes


-- Função
SELECT idcliente,
		qtdepontos,
		-- qtdepontos + 10 AS QtdePontos_mais_dez,
		-- qtdepontos * 2 AS QtdePontos_vezes_dois,
		CAST(dtcriacao AS TIMESTAMP)
		-- ou dtcriacao::TIMESTAMP
		
		/*
		A conversão de tipo seria necessário caso o tipo de dtcriacao
		estivesse no tipo string, mas ele já se encontra no formato TIMESTAMP
		*/
FROM clientes


-- Os 10 clientes com maior número de pontos ordenado de forma descendente
SELECT idcliente, qtdepontos, dtcriacao, dtatualizacao
FROM clientes
ORDER BY qtdepontos DESC
LIMIT 10


-- Clientes mais antigos com maior quantidade de pontos
SELECT idcliente, qtdepontos, dtcriacao, dtatualizacao
FROM clientes
ORDER BY dtcriacao ASC, qtdepontos DESC
LIMIT 10


-- Clientes mais antigos com maior quantidade de pontos que possuem Twitch
SELECT idcliente, fltwitch, qtdepontos, dtcriacao, dtatualizacao
FROM clientes
WHERE fltwitch = 1
ORDER BY dtcriacao ASC, qtdepontos DESC
LIMIT 10


-- CASE WHEN
/*
Classe baixa x < 2200
Classe média baixa 2200 <= x < 5500
Classe média 5500 <= x < 11000
Classe média alta 11000 <= x < 22000
Classe alta 22000 <= x
*/

SELECT idcliente, qtdepontos,
		CASE
			WHEN qtdepontos < 2200 THEN 'Classe baixa'
			WHEN qtdepontos >= 2200 AND qtdepontos < 5500 THEN 'Classe média baixa'
			WHEN qtdepontos >= 5500 AND qtdepontos < 11000 THEN 'Classe média'
			WHEN qtdepontos >= 11000 AND qtdepontos < 22000 THEN 'Classe média alta'
			ELSE 'Classe alta'
			-- WHEN qtdepontos >= 22000 THEN 'Classe alta'
			END AS "Classe por pontos",
		
		CASE
			WHEN fltwitch = 1 THEN 1
			ELSE 0
			END AS "Twitch"
			
FROM clientes
ORDER BY qtdepontos DESC


-- Agredações
-- COUNT
SELECT COUNT(*)
FROM clientes


SELECT	COUNT(*),
		COUNT(CASE
				WHEN fltwitch = 1 THEN 1
				END)
FROM clientes

-- DISTINCT
SELECT DISTINCT fltwitch
FROM clientes


SELECT DISTINCT flTwitch, flEmail
FROM clientes


SELECT COUNT(DISTINCT idcliente)
FROM clientes


-- Quantas transacoes foram feitas em Julho de 2025
SELECT COUNT(*)
		-- *
FROM transacoes
WHERE dtcriacao >= '2025-07-01' AND dtcriacao < '2025-08-01'
-- ORDER BY dtcriacao


-- Quantas transacoes e quantos clientes fizeram transacoes em Julho de 2025
SELECT 	COUNT(DISTINCT idtransacao),
		COUNT(DISTINCT idcliente)
FROM transacoes
WHERE dtcriacao >= '2025-07-01' AND dtcriacao < '2025-08-01'


-- Quantos pontos foram ganhos no total em Julho
SELECT SUM(qtdepontos)
FROM transacoes
WHERE dtcriacao >= '2025-07-01' AND dtcriacao < '2025-08-01' AND qtdepontos > 0


-- Quantos pontos foram creditados e debitados no total em Julho
SELECT  SUM(qtdepontos),

		SUM(CASE 
			WHEN qtdepontos > 0 THEN qtdepontos
			END) AS pontos_creditados,

		SUM(CASE 
			WHEN qtdepontos < 0 THEN qtdepontos
			END) AS pontos_debitados
		
FROM transacoes
WHERE dtcriacao >= '2025-07-01' AND dtcriacao < '2025-08-01'


-- Média do saldo em conta dos clientes
SELECT COUNT(*) AS total_de_clientes,
		ROUND(AVG(qtdepontos), 2) AS media_de_pontos,	-- ROUND arredonda o número
		MIN(qtdepontos) AS carteira_com_valor_minimo,	-- Canteira com o valor mínimo de pontos
		MAX(qtdepontos) AS carteira_com_valor_maximo,	-- Carteira com o valor máximo de pontos
		SUM(fltwitch) AS total_pessoas_twitch,			-- Total de pessoas que tem twitch
		SUM(flemail) AS total_pessoas_email				-- Total de pessoas que tem email cadastrado
FROM clientes


-- GROUP BY
SELECT idproduto,
		COUNT(*)
FROM transacao_produto
GROUP BY idproduto


-- Clientes que mais juntaram pontos no mes de julho
SELECT idcliente, SUM(qtdepontos) AS qtdepontos, COUNT(qtdepontos) AS qtdetransacoes
FROM transacoes
WHERE dtcriacao >= '2025-07-01' AND dtcriacao < '2025-08-01'
GROUP BY idcliente
ORDER BY qtdepontos DESC
-- LIMIT 10		-- TOP 10 clientes que mais juntaram pontos no mes de julho


-- HAVING
-- Clientes que mais juntaram pontos no mes de julho contendo mais de 4000 pontos
SELECT idcliente, SUM(qtdepontos) AS qtdepontos, COUNT(qtdepontos) AS qtdetransacoes
FROM transacoes
WHERE dtcriacao >= '2025-07-01' AND dtcriacao < '2025-08-01'
GROUP BY idcliente
HAVING SUM(qtdepontos) >= 4000
ORDER BY qtdepontos DESC


-- JOINS
SELECT *
FROM transacao_produto AS tp
LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto
LIMIT 100


-- Selecionando todas as colunas da primeira tabela + algumas da segunda tabela
SELECT tp.*, p.descnomeproduto, p.desccategoriaproduto
FROM transacao_produto AS tp
LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto


-- SubQueries
-- Lista de transações com o produto "Resgatar Ponei"
SELECT tp.*
FROM transacao_produto AS tp
WHERE tp.idproduto = (
	SELECT p.idproduto
	FROM produtos AS p
	WHERE p.descnomeproduto = 'Resgatar Ponei'
)


-- Dos clientes que começaram SQL, quantos chegaram ao quinto dia de curso?
SELECT COUNT(DISTINCT t.idcliente)
FROM transacoes AS t
WHERE t.idcliente IN (
	SELECT DISTINCT(t.idcliente)
	FROM transacoes AS t
	WHERE t.dtcriacao >= '2025-08-25'
)
AND t.dtcriacao < '2025-08-30';

-- Começaram o curso
SELECT count(DISTINCT idcliente)
FROM transacoes AS t
WHERE t.dtcriacao >= '2025-08-25'

/* Esta maneira de fazer SubQuery é ruim pois faz duas consultas em duas tabelas
 bem grandes, cada consulta em uma tabela.*/


-- Melhorando a consulta, filtrando os dados antes de
-- consultá-los para otimizar e diminuir o custo computacional
SELECT *
FROM (
	SELECT *
	FROM transacoes
	WHERE dtcriacao >= '2025-01-01'
) AS t
WHERE dtcriacao < '2025-07-02'


-- CTE (Common Table Expression)
WITH tb_cliente_primeiro_dia AS (
	SELECT DISTINCT (t.idcliente)
	FROM transacoes AS t
	WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-26'
),
tb_cliente_ultimo_dia AS (
	SELECT DISTINCT (t.idcliente)
	FROM transacoes AS t
	WHERE t.dtcriacao >= '2025-08-29' AND t.dtcriacao < '2025-08-30'
),
tb_join AS (
	SELECT t1.idcliente AS cliente_pri_dia,
			t2.idcliente AS cliente_ult_dia
	FROM tb_cliente_primeiro_dia AS t1
	LEFT JOIN tb_cliente_ultimo_dia AS t2
	ON t1.idcliente = t2.idcliente
)
SELECT COUNT(cliente_pri_dia),
		COUNT(cliente_ult_dia)
FROM tb_join


-- Quem iniciou o curso no primeiro dia,
-- em média, assistiu quantas aulas?
WITH tb_prim_dia AS (					-- Quem participou da primeira aula				
	SELECT DISTINCT idcliente
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-26'
),
tb_dias_curso AS (						-- Quem participou do curso inteiro
	SELECT DISTINCT idcliente, date(dtcriacao) AS presenca_aula
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
	ORDER BY idcliente, presenca_aula
),
tb_clientes_dias AS (					-- Quantas vezes quem participou do primeiro dia voltou
	SELECT t1.idcliente,
			COUNT(DISTINCT t2.presenca_aula) AS qtDias
	FROM tb_prim_dia AS t1
	LEFT JOIN tb_dias_curso AS t2
	ON t1.idcliente = t2.idcliente
	GROUP BY t1.idcliente
)
										-- Média de dias 
SELECT ROUND(AVG(qtdias), 2) AS media_de_dias
FROM tb_clientes_dias


-- Enumerando Linhas (row_number)
-- Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 1?
WITH tb_alunos_dia1 AS (
	SELECT DISTINCT idcliente
	FROM transacoes
	WHERE DATE(dtcriacao) = '2025-08-25' 
),
tb_cliente_engajamento AS (
	SELECT ad1.idcliente AS cliente, DATE(t.dtcriacao) AS dia, COUNT(*) AS qtdeEngajamento
	FROM tb_alunos_dia1 AS ad1
	LEFT JOIN transacoes AS t
	ON ad1.idcliente = t.idcliente
	WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-30'
	GROUP BY cliente, dia
	ORDER BY cliente, dia
),
tb_join AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cliente ORDER BY qtdeengajamento DESC, dia) AS ordem_engajamento
	FROM tb_cliente_engajamento
)
SELECT cliente, dia, qtdeengajamento
FROM tb_join
WHERE ordem_engajamento = 1


-- Window Function
-- Soma acumulada dos dias de curso
WITH tb_soma_tdias AS (	
	SELECT DATE(dtcriacao) AS dtDia, COUNT(DISTINCT idtransacao) AS qtdetransacoes
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
	GROUP BY dtdia 
)
SELECT *,
		SUM(qtdetransacoes) OVER (PARTITION BY 1 ORDER BY dtdia) AS qtdeTransacoesAcumuladas
		-- Não necessita colocar o PARTITION BY, apenas o OVER e (ORDER BY) 
FROM tb_soma_tdias


-- Acumulado de transações dos clientes durante os dias de curso
WITH tb_cliente_dia AS (	
	SELECT idcliente, DATE(dtcriacao) AS dtDia, COUNT(DISTINCT idtransacao) AS qtdetransacoes
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
	GROUP BY idcliente, dtdia
),
tb_lag_transacao AS (
	SELECT *,
			SUM(qtdetransacoes) OVER (PARTITION BY idcliente ORDER BY dtdia) AS acumuladoDia,
			LAG(qtdetransacoes) OVER (PARTITION BY idcliente ORDER BY dtdia) AS lagtransacao
	FROM tb_cliente_dia AS t1
)
SELECT *,
		1. * qtdetransacoes / lagtransacao 
FROM tb_lag_transacao 


-- De quanto em quanto tempo as pessoas voltam a assistir aulas?
WITH tb_cliente_dia AS (
	SELECT DISTINCT idcliente,
			DATE(dtcriacao) AS dataAula
	FROM transacoes
	WHERE EXTRACT(YEAR FROM dtcriacao) = '2025'
	ORDER BY idcliente, dataaula
),
tb_lag_dia AS (
	SELECT *,
			LAG(dataAula) OVER (PARTITION BY idcliente) AS lag_dia
	FROM tb_cliente_dia
),
tb_diff_dt AS (
	SELECT *,
			dataaula - lag_dia AS diffData
	FROM tb_lag_dia
),
tb_media_clientes AS (
	SELECT idcliente,
			avg(diffdata) AS mediaDias
	FROM tb_diff_dt
	GROUP BY idcliente
	HAVING avg(diffdata) IS NOT NULL
)
SELECT ROUND(AVG(mediadias), 2) AS "Média de dias em que as pessoas voltam"
FROM tb_media_clientes


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






