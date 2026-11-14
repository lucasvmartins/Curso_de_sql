-- Enumerando Linhas (row_number)
-- Qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 1?
WITH tb_alunos_dia1 AS (
	SELECT DISTINCT idcliente
	FROM transacoes
	WHERE DATE(dtcriacao) = '2025-08-25' 
),
tb_cliente_engajamento AS (
	SELECT ad1.idcliente AS cliente, DATE(t.dtcriacao) AS dia, COUNT(*) AS qtdeEngajamento
	FROM tb_alunos_dia1 AS ad1
	LEFT JOIN transacoes AS t
	ON ad1.idcliente = t.idcliente
	WHERE t.dtcriacao >= '2025-08-25' AND t.dtcriacao < '2025-08-30'
	GROUP BY cliente, dia
	ORDER BY cliente, dia
),
tb_join AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY cliente ORDER BY qtdeengajamento DESC, dia) AS ordem_engajamento
	FROM tb_cliente_engajamento
)
SELECT cliente, dia, qtdeengajamento
FROM tb_join
WHERE ordem_engajamento = 1


-- Window Function
-- Soma acumulada dos dias de curso
WITH tb_soma_tdias AS (	
	SELECT DATE(dtcriacao) AS dtDia, COUNT(DISTINCT idtransacao) AS qtdetransacoes
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
	GROUP BY dtdia 
)
SELECT *,
		SUM(qtdetransacoes) OVER (PARTITION BY 1 ORDER BY dtdia) AS qtdeTransacoesAcumuladas
		-- Não necessita colocar o PARTITION BY, apenas o OVER e (ORDER BY) 
FROM tb_soma_tdias


-- Acumulado de transações dos clientes durante os dias de curso
WITH tb_cliente_dia AS (	
	SELECT idcliente, DATE(dtcriacao) AS dtDia, COUNT(DISTINCT idtransacao) AS qtdetransacoes
	FROM transacoes
	WHERE dtcriacao >= '2025-08-25' AND dtcriacao < '2025-08-30'
	GROUP BY idcliente, dtdia
),
tb_lag_transacao AS (
	SELECT *,
			SUM(qtdetransacoes) OVER (PARTITION BY idcliente ORDER BY dtdia) AS acumuladoDia,
			LAG(qtdetransacoes) OVER (PARTITION BY idcliente ORDER BY dtdia) AS lagtransacao
	FROM tb_cliente_dia AS t1
)
SELECT *,
		1. * qtdetransacoes / lagtransacao 
FROM tb_lag_transacao 


-- De quanto em quanto tempo as pessoas voltam a assistir aulas?
WITH tb_cliente_dia AS (
	SELECT DISTINCT idcliente,
			DATE(dtcriacao) AS dataAula
	FROM transacoes
	WHERE EXTRACT(YEAR FROM dtcriacao) = '2025'
	ORDER BY idcliente, dataaula
),
tb_lag_dia AS (
	SELECT *,
			LAG(dataAula) OVER (PARTITION BY idcliente) AS lag_dia
	FROM tb_cliente_dia
),
tb_diff_dt AS (
	SELECT *,
			dataaula - lag_dia AS diffData
	FROM tb_lag_dia
),
tb_media_clientes AS (
	SELECT idcliente,
			avg(diffdata) AS mediaDias
	FROM tb_diff_dt
	GROUP BY idcliente
	HAVING avg(diffdata) IS NOT NULL
)
SELECT ROUND(AVG(mediadias), 2) AS "Média de dias em que as pessoas voltam"
FROM tb_media_clientes


