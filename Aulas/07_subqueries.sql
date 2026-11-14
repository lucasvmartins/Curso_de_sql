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


