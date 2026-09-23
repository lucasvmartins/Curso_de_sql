-------------------- Projeto Final --------------------

/*
Vamos construir uma tabela com o perfil comportamental dos nossos usuários

1. Quantidade de transações históricas (Total, D7, D14, D28, D56) ✓
2. Dias desde a última transação ✓
3. Tempo na base ✓
4. Produto mais usado (Total, D7, D14, D28, D56) ✓
5. Saldo de pontos atual ✓
6. Pontos acumulados positivos (Total, D7, D14, D28, D56) ✓
7. Pontos acumulados negativos (Total, D7, D14, D28, D56) ✓
8. Dias da semana mais ativos (D28) ✓
9. Período do dia mais ativos (D28)
10. Engajamento em D28 x Total
*/

-- Quantidade de transações históricas (vida, D7, D28, D56)
--SELECT idcliente,
--		COUNT(*) AS qtdTransacoes,
--		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 7 THEN idtransacao END) AS transacoes7D,
--		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 28 THEN idtransacao END) AS transacoes28D,
--		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 56 THEN idtransacao END) AS transacoes56D,
--		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 365 THEN idtransacao END) AS transacoes365D
--FROM transacoes
--GROUP BY idcliente
--ORDER BY qtdTransacoes DESC, transacoes7D, transacoes28D, transacoes56D, transacoes365D

-- Versão melhorada (Mais otimizada)

WITH tb_transacoes AS (
	SELECT idcliente, idtransacao, qtdepontos,
			DATE(dtcriacao) AS dtcriacao,
			DATE(CURRENT_DATE) - DATE(dtcriacao) AS diffdate
	FROM transacoes
),
tb_cliente AS (
	SELECT idcliente,
			DATE(CURRENT_DATE) - DATE(dtcriacao) AS tempoNaBase
	FROM clientes
),
tb_sumario_transacoes AS (
	SELECT idcliente,
			COUNT(idtransacao) AS qtdeTransacoes,
			COUNT(CASE WHEN diffdate <= 7 THEN idtransacao END) AS transacoes7D,
			COUNT(CASE WHEN diffdate <= 28 THEN idtransacao END) AS transacoes28D,
			COUNT(CASE WHEN diffdate <= 56 THEN idtransacao END) AS transacoes56D,
			COUNT(CASE WHEN diffdate <= 365 THEN idtransacao END) AS transacoes365D,
			MIN(diffdate) AS diasUltimaTransacao,
			SUM(qtdepontos) saldoPontos,
			SUM(CASE WHEN qtdepontos > 0 THEN qtdePontos ELSE 0 END) AS somaTotalPontosPos,
			SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 7 THEN qtdepontos ELSE 0 END) AS somaPontosPos7,
			SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 14 THEN qtdepontos ELSE 0 END) AS somaPontosPos14,
			SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 28 THEN qtdepontos ELSE 0 END) AS somaPontosPos28,
			SUM(CASE WHEN qtdepontos > 0 AND diffdate <= 56 THEN qtdepontos ELSE 0 END) AS somaPontosPos56,
			SUM(CASE WHEN qtdepontos < 0 THEN qtdePontos ELSE 0 END) AS somaTotalPontosNeg,
			SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 7 THEN qtdepontos ELSE 0 END) AS somaPontosNeg7,
			SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 14 THEN qtdepontos ELSE 0 END) AS somaPontosNeg14,
			SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 28 THEN qtdepontos ELSE 0 END) AS somaPontosNeg28,
			SUM(CASE WHEN qtdepontos < 0 AND diffdate <= 56 THEN qtdepontos ELSE 0 END) AS somaPontosNeg56
	FROM tb_transacoes
	GROUP BY idcliente
	ORDER BY qtdetransacoes DESC, transacoes365d
),
tb_transacao_produto AS (
	SELECT t1.*,
			p.descnomeproduto, p.desccategoriaproduto
	FROM tb_transacoes AS t1
	LEFT JOIN transacao_produto AS tp
	ON t1.idtransacao = tp.idtransacao
	LEFT JOIN produtos AS p
	ON tp.idproduto = p.idproduto
),
tb_cliente_produto AS (
	SELECT idcliente, descnomeproduto,
			COUNT(*) AS produtoMaisUsadoTotal,
			COUNT(CASE WHEN diffdate <= 7 THEN idtransacao END) AS produtoMaisUsadod7,
			COUNT(CASE WHEN diffdate <= 14 THEN idtransacao END) AS produtoMaisUsadod14,
			COUNT(CASE WHEN diffdate <= 28 THEN idtransacao END) AS produtoMaisUsadod28,
			COUNT(CASE WHEN diffdate <= 56 THEN idtransacao END) AS produtoMaisUsadod56
	FROM tb_transacao_produto 
	GROUP BY idcliente, descnomeproduto
),
tb_cliente_produto_rn AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY produtoMaisUsadoTotal DESC) AS rnTotal,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY produtoMaisUsadod7 DESC) AS rnD7,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY produtoMaisUsadod14 DESC) AS rnd14,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY produtoMaisUsadod28 DESC) AS rnD28,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY produtoMaisUsadod56 DESC) AS rnD56
	FROM tb_cliente_produto 
),
tb_cliente_dia AS (
	SELECT idcliente,
			EXTRACT(DOW FROM dtcriacao) AS dtDia,
			COUNT(*) AS qtdeTransacoes
	FROM tb_transacoes
	WHERE diffdate <= 365
	GROUP BY idcliente, dtDia
),
tb_cliente_dia_rn AS (
	SELECT *,
			ROW_NUMBER() OVER (PARTITION BY idcliente ORDER BY qtdeTransacoes DESC) AS rnDia
	FROM tb_cliente_dia
),
tb_join AS (
	SELECT t1.*,
			t2.temponabase,
			t3.descnomeproduto AS produtoMaisUsadoTotal,
			t4.descnomeproduto AS produtomaisusadod7,
			t5.descnomeproduto AS produtomaisusadod14,
			t6.descnomeproduto AS produtomaisusadod28,
			t7.descnomeproduto AS produtomaisusadod56,
			COALESCE(t8.dtDia, -1) AS dtDia
	FROM tb_sumario_transacoes AS t1
	LEFT JOIN tb_cliente AS t2
	ON t1.idcliente = t2.idcliente
	LEFT JOIN tb_cliente_produto_rn AS t3
	ON t1.idcliente = t3.idcliente AND t3.rntotal = 1
	LEFT JOIN tb_cliente_produto_rn AS t4
	ON t1.idcliente = t4.idcliente AND t4.rnd7 = 1
	LEFT JOIN tb_cliente_produto_rn AS t5
	ON t1.idcliente = t5.idcliente AND t5.rnd14 = 1
	LEFT JOIN tb_cliente_produto_rn AS t6
	ON t1.idcliente = t6.idcliente AND t6.rnd28 = 1
	LEFT JOIN tb_cliente_produto_rn AS t7
	ON t1.idcliente = t7.idcliente AND t7.rnd56 = 1
	LEFT JOIN tb_cliente_dia_rn AS t8
	ON t1.idcliente = t8.idcliente AND t8.rnDia = 1
)
SELECT *
FROM tb_join











