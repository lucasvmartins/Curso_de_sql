-- CTE (Common Table Expression)
WITH tb_cliente_primeiro_dia AS (
	SELECT DISTINCT (t.idcliente)
	FROM transacoes AS t
	WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-26'
),
tb_cliente_ultimo_dia AS (
	SELECT DISTINCT (t.idcliente)
	FROM transacoes AS t
	WHERE t.dtcriacao >= '2025-08-29' AND t.dtcriacao < '2025-08-30'
),
tb_join AS (
	SELECT t1.idcliente AS cliente_pri_dia,
			t2.idcliente AS cliente_ult_dia
	FROM tb_cliente_primeiro_dia AS t1
	LEFT JOIN tb_cliente_ultimo_dia AS t2
	ON t1.idcliente = t2.idcliente
)
SELECT COUNT(cliente_pri_dia),
		COUNT(cliente_ult_dia)
FROM tb_join


-- Quem iniciou o curso no primeiro dia,
-- em média, assistiu quantas aulas?
WITH tb_prim_dia AS (					-- Quem participou da primeira aula				
	SELECT DISTINCT idcliente
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-26'
),
tb_dias_curso AS (						-- Quem participou do curso inteiro
	SELECT DISTINCT idcliente, date(dtcriacao) AS presenca_aula
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
	ORDER BY idcliente, presenca_aula
),
tb_clientes_dias AS (					-- Quantas vezes quem participou do primeiro dia voltou
	SELECT t1.idcliente,
			COUNT(DISTINCT t2.presenca_aula) AS qtDias
	FROM tb_prim_dia AS t1
	LEFT JOIN tb_dias_curso AS t2
	ON t1.idcliente = t2.idcliente
	GROUP BY t1.idcliente
)
										-- Média de dias 
SELECT ROUND(AVG(qtdias), 2) AS media_de_dias
FROM tb_clientes_dias


