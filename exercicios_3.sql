-------------------- Exercícios 3 --------------------
-- JOINS


-- Qual categoria tem mais produtos vendidos?
SELECT p.desccategoriaproduto AS categoria_produto,
		COUNT(tp.qtdeproduto) AS total_vendido--,
		-- SUM(tp.qtdeproduto) AS total_vendido2
		
FROM transacao_produto AS tp

LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto

GROUP BY categoria_produto
ORDER BY total_vendido DESC
LIMIT 100


-- Em 2024, quantas transações de Lovers tivemos?
SELECT COUNT(*) 
FROM transacoes AS t

LEFT JOIN transacao_produto AS tp
ON t.idtransacao = tp.idtransacao

LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto

WHERE dtcriacao >= '2024-01-01' AND dtcriacao < '2025-01-01'
AND p.desccategoriaproduto LIKE '%lover%'


-- Qual mês tivemos mais lista de presença assinada?
SELECT TO_CHAR(dtcriacao, 'YYYY-MM') AS ano_mes,
		COUNT(*) AS total_presencas
		
FROM transacoes AS t

LEFT JOIN transacao_produto AS tp
ON t.idtransacao = tp.idtransacao

LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto

WHERE p.descnomeproduto = 'Lista de presença'

GROUP BY ano_mes
ORDER BY total_presencas DESC


-- Quais cliente mais perderam pontos por Lover?
SELECT t.idcliente, SUM(t.qtdepontos) AS total_gasto
FROM transacoes AS t

INNER JOIN transacao_produto AS tp
ON t.idtransacao = tp.idtransacao

INNER JOIN produtos AS p
ON tp.idproduto = p.idproduto

WHERE p.desccategoriaproduto LIKE '%lover%' AND t.qtdepontos < 0

GROUP BY t.idcliente
ORDER BY total_gasto
LIMIT 10


-- Quais clientes assinaram a lista de presença no dia 2025-08-25?
SELECT DISTINCT(t.idcliente), t.dtcriacao, t.descsistemaorigem, p.descnomeproduto
FROM transacoes AS t

LEFT JOIN transacao_produto AS tp
ON t.idtransacao = tp.idtransacao

LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto

WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-26'
AND p.descnomeproduto = 'Lista de presença'

ORDER BY t.dtcriacao


-- Do início ao fim do curso (2025-08-25 a 2025-08-29),
-- quantos clientes assinaram a lista de presença?
SELECT COUNT(DISTINCT t.idcliente)
FROM transacoes AS t

LEFT JOIN transacao_produto AS tp
ON t.idtransacao = tp.idtransacao

LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto

WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-30'
AND p.descnomeproduto = 'Lista de presença'


-- Clientes mais antigos têm mais frequência de transação?
SELECT c.idcliente, (CURRENT_DATE - c.dtcriacao) AS tempo_de_criacao, COUNT(t.idtransacao) AS qtdTransacoes
FROM clientes AS c

LEFT JOIN transacoes AS t
ON t.idcliente = c.idcliente

GROUP BY c.idcliente, tempo_de_criacao
ORDER BY tempo_de_criacao DESC


-- 







