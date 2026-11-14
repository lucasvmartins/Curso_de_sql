-------------------- Exercícios 2 --------------------
-- Group By

-- Quantos clientes tem email cadastrado?
SELECT SUM(flEmail)
FROM clientes


-- Qual cliente juntou mais pontos positivos em 2025-05?
SELECT idcliente,
		SUM(qtdepontos) AS total_de_pontos
FROM transacoes
WHERE dtcriacao >= '2025-05-01' AND dtcriacao < '2025-06-01' AND qtdepontos >= 0
GROUP BY idcliente
ORDER BY total_de_pontos DESC
LIMIT 1


-- Qual cliente fez mais transações no ano de 2024?
SELECT idcliente,
		COUNT(*) AS qtdetransacoes,
		COUNT(DISTINCT idtransacao)
FROM transacoes
WHERE dtcriacao >= '2024-01-01' AND dtcriacao < '2025-01-01'
GROUP BY idcliente	
ORDER BY qtdetransacoes DESC


-- Quantos produtos são de RPG?
SELECT desccategoriaproduto,
		COUNT(DISTINCT idproduto) AS qtdeprodutorpg
FROM produtos
WHERE desccategoriaproduto LIKE '%rpg%'
GROUP BY desccategoriaproduto

/* Agrupando por categoria
SELECT desccategoriaproduto,
		COUNT(desccategoriaproduto)
FROM produtos
GROUP BY desccategoriaproduto
*/


-- Qual o valor médio de pontos positivos por dia?
SELECT SUM(qtdepontos) AS total_de_pontos,
		COUNT(DISTINCT(DATE(dtcriacao))) AS total_de_dias,
		SUM(qtdepontos) / COUNT(DISTINCT(DATE(dtcriacao))) AS media_pontos_pos_por_dia

FROM transacoes
WHERE qtdepontos >= 0

/*
SELECT DATE(dtcriacao) AS dia,
		ROUND(AVG(qtdepontos), 2) AS media_pontos_pos
FROM transacoes
WHERE qtdepontos >= 0
GROUP BY dia
ORDER BY dia
*/


-- Qual dia da semana tem mais pedidos em 2025?
SELECT CASE(EXTRACT(DOW FROM dtcriacao))
			WHEN 0 THEN 'domingo'
			WHEN 1 THEN 'segunda-feira'
			WHEN 2 THEN 'terca-feira'
			WHEN 3 THEN 'quarta-feira'
			WHEN 4 THEN 'quinta-feira'
			WHEN 5 THEN 'sexta-feira'
			WHEN 6 THEN 'sabado'
		END AS dia_semana,
		-- EXTRACT(DOW from dtcriacao) as dia_semana,
		COUNT(*) AS total_transacoes
FROM transacoes
WHERE dtcriacao >= '2025-01-01' AND dtcriacao < '2026-01-01'
GROUP BY dia_semana
ORDER BY total_transacoes DESC


-- Qual o produto mais transacionado?
SELECT idproduto,
		SUM(qtdeproduto) AS total_produto,
		COUNT(*)
FROM transacao_produto
GROUP BY idproduto
ORDER BY total_produto DESC
LIMIT 1


-- Qual o produto com mais pontos transacionados?
SELECT idproduto,
		SUM(vlproduto) AS total_valor_somado
FROM transacao_produto
GROUP BY idproduto
ORDER BY total_valor_somado DESC
