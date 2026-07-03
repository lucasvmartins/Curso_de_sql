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
)
WHERE dtcriacao < '2025-07-02'




