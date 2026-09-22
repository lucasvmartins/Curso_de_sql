-------------------- Projeto Final --------------------
-- Vamos construir uma tabela com o perfil comportamental dos nossos usuários


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
)
SELECT t1.*,
		t2.temponabase
FROM tb_sumario_transacoes AS t1
LEFT JOIN tb_cliente AS t2
ON t1.idcliente = t2.idcliente















