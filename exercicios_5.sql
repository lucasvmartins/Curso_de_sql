-------------------- Exercícios 5 --------------------
-- Window Function

-- Quantidade de transações acumuladas ao longo do tempo (diário)
WITH tb_transacoes_pDia AS (
	SELECT DATE(dtcriacao) AS dtDIa,
			COUNT(idtransacao) AS total_dia
	FROM transacoes
	GROUP BY dtdia
	ORDER BY dtdia
),
tb_acumulado_pDia AS (
	SELECT *,
			SUM(total_dia) OVER (ORDER BY dtdia) AS acumulado_transacoes_pDia
	FROM tb_transacoes_pDia
)
SELECT *
FROM tb_acumulado_pDia


-- Quantidade de usuários cadastrados (absoluto e acumulado) ao longo do tempo
WITH tb_criacao_pDia AS (
	SELECT DATE(dtcriacao) AS dia,
	COUNT(DISTINCT idcliente) AS qtcadastros_cliente_pdia
	FROM clientes
	GROUP BY dia
),
tb_criacao_agregado AS (
	SELECT *,
			SUM(qtcadastros_cliente_pdia) OVER (ORDER BY dia) AS agregado_pDia
	FROM tb_criacao_pDia
	ORDER BY dia
)
SELECT *
FROM tb_criacao_agregado


-- Qual o dia da semana mais ativo de cada usuário
WITH tb_dia_semana AS (
	SELECT idcliente,
			CASE EXTRACT(DOW FROM dtcriacao)
	           WHEN 0 THEN 'Domingo'
	           WHEN 1 THEN 'Segunda-feira'
	           WHEN 2 THEN 'Terça-feira'
	           WHEN 3 THEN 'Quarta-feira'
	           WHEN 4 THEN 'Quinta-feira'
	           WHEN 5 THEN 'Sexta-feira'
	           WHEN 6 THEN 'Sábado'
	       END AS dia_semana
	FROM transacoes
),
tb_qtde_transacoes AS (
	SELECT *,
			COUNT(dia_semana) AS qt_de_transacoes
	FROM tb_dia_semana
	GROUP BY idcliente, dia_semana
),
tb_dia_mais_ativo AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qt_de_transacoes DESC) AS posicao
	FROM tb_qtde_transacoes
)
SELECT idcliente, dia_semana, qt_de_transacoes
FROM tb_dia_mais_ativo
WHERE posicao = 1
ORDER BY qt_de_transacoes DESC


-- Saldo de pontos acumulado de cada usuário
WITH tb_soma_ponto_clientes AS (
	SELECT idcliente, DATE(dtcriacao) AS data_soma, SUM(qtdepontos) AS soma_pontos
	FROM transacoes
	GROUP BY idcliente, data_soma
)
SELECT *,
		SUM(soma_pontos) OVER (PARTITION BY idcliente ORDER BY data_soma) AS acumulado_pontos
FROM tb_soma_ponto_clientes


-- Versão alternativa otimizada
SELECT
    idcliente,
    DATE(dtcriacao)  AS data_soma,
    SUM(qtdepontos)  AS soma_pontos,
    SUM(SUM(qtdepontos)) OVER (
        PARTITION BY idcliente
        ORDER BY DATE(dtcriacao)
    )                AS acumulado_pontos
FROM transacoes
GROUP BY
    idcliente,
    DATE(dtcriacao)
ORDER BY
    idcliente,
    DATE(dtcriacao)
