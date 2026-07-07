-------------------- Exercícios 3 --------------------
-- CTEs (Common Table Expression)

--Engajamento por dia
--SELECT DATE(dtcriacao) AS dtDia, COUNT(DISTINCT idcliente) AS qtdeclientes
--FROM transacoes
--WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
--GROUP BY dtdia


-- Como foi a curva de Churn do Curso de SQL?
WITH tb_presentes_prim_dia AS (
	SELECT DISTINCT idcliente AS primIdcliente
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-26'
)
SELECT DATE(t.dtcriacao) AS dtDia,
		COUNT(DISTINCT pprim.primidcliente) AS qtdeClientes,
		ROUND((1. * COUNT(DISTINCT pprim.primidcliente) / (SELECT COUNT(*) FROM tb_presentes_prim_dia )) * 100, 2) AS pct_retencao,
		ROUND((1 - 1. * COUNT(DISTINCT pprim.primidcliente) / (SELECT COUNT(*) FROM tb_presentes_prim_dia )) * 100, 2) AS pct_churn
FROM tb_presentes_prim_dia AS pprim
LEFT JOIN transacoes AS t
ON pprim.primidcliente = t.idcliente
WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-30' 
GROUP BY dtDia








