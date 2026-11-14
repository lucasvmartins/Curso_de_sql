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


