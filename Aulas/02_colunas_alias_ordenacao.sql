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


