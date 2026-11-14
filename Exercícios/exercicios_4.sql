-------------------- Exercícios 4 --------------------
-- CTEs (Common Table Expression)

--Engajamento por dia
SELECT DATE(dtcriacao) AS dtDia, COUNT(DISTINCT idcliente) AS qtdeclientes
FROM transacoes
WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
GROUP BY dtdia


-- Como foi a curva de Churn do Curso de SQL?
WITH tb_presentes_prim_dia AS (
	SELECT DISTINCT idcliente AS primIdcliente
	FROM transacoes
	WHERE DATE(dtcriacao) = '2025-08-25'
),
tb_join AS (
	SELECT DATE(t.dtcriacao) AS dtDia,
			COUNT(DISTINCT pprim.primidcliente) AS qtdeClientes,
			ROUND((1. * COUNT(DISTINCT pprim.primidcliente) / (SELECT COUNT(*) FROM tb_presentes_prim_dia )) * 100, 2) AS pct_retencao,
			ROUND((1 - 1. * COUNT(DISTINCT pprim.primidcliente) / (SELECT COUNT(*) FROM tb_presentes_prim_dia )) * 100, 2) AS pct_churn
	FROM tb_presentes_prim_dia AS pprim
	LEFT JOIN transacoes AS t
	ON pprim.primidcliente = t.idcliente
	WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-30' 
	GROUP BY dtDia
)
SELECT *
FROM tb_join

-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?

WITH tb_clientes_janeiro25 AS (
	SELECT DISTINCT idcliente AS idClienteJaneiro
	FROM transacoes
	WHERE dtcriacao >= '2025-01-01' AND dtcriacao < '2025-02-01'
),
tb_clientes_curso AS (
	SELECT DISTINCT idcliente AS idClienteCurso
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
),
tb_join AS (
	SELECT *
	FROM tb_clientes_janeiro25 AS t1
	LEFT JOIN tb_clientes_curso AS t2
	ON t1.idclientejaneiro = t2.idclientecurso
)
SELECT COUNT(idclientejaneiro) AS qtClientesJaneiro, COUNT(idclientecurso) AS qtClientesdeJaneironoCurso
FROM tb_join
