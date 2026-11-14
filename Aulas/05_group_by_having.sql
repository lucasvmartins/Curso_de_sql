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


