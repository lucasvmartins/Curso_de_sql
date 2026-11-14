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


