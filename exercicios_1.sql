-------------------- Exercícios 1 --------------------

-- Lista de transações com apenas 1 ponto
SELECT *
FROM transacoes
WHERE qtdepontos = 1


-- Lista de pedidos realizados no fim de semana
SELECT *,
		CASE EXTRACT(DOW FROM dtcriacao)
			WHEN 0 THEN 'Domingo'
			WHEN 6 THEN 'Sábado'
		END AS dia_semana
FROM transacoes
WHERE EXTRACT(DOW FROM dtcriacao) IN (0, 6)


-- Lista de clientes com 0 pontos
SELECT idcliente,
		qtdepontos,
		dtcriacao,
		dtatualizacao
FROM clientes
WHERE qtdepontos = 0


-- Lista de clientes com 100 a 200 pontos
SELECT idcliente,
		qtdepontos,
		dtcriacao,
		dtatualizacao
FROM clientes
WHERE qtdepontos BETWEEN 100 AND 200
--WHERE qtdepontos >= 100 AND qtdepontos <= 200


-- Lista de produtos com nome que começa com "Venda de"
SELECT *
FROM produtos
WHERE descnomeproduto LIKE 'Venda de%'


-- Lista de produtos com nome que termina com "Lover"
SELECT *
FROM produtos
WHERE descnomeproduto LIKE '%Lover'


-- Lista de produtos que são "chapéu"
SELECT *
FROM produtos
WHERE descnomeproduto LIKE '%Chapéu%'


-- Lista de transações com o produto "Resgatar Ponei"
SELECT *
FROM transacao_produto
WHERE idproduto = '15'


/* Listar todas as transações adicionando uma coluna nova sinalizando
"alto", "médio" e "baixo" para o valor dos pontos [< 10, < 500, >= 500] */
SELECT *,
		CASE
			WHEN qtdepontos < 10 THEN 'Baixo'
			WHEN qtdepontos < 500 THEN 'Médio'
			ELSE 'Alto'
			END AS "nivel_da_trn"
FROM transacoes
ORDER BY qtdepontos DESC
