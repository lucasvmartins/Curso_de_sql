-------------------- Projeto Final --------------------
-- Vamos construir uma tabela com o perfil comportamental dos nossos usuários


-- Quantidade de transações históricas (vida, D7, D28, D56)
SELECT idcliente,
		COUNT(*) AS qtdTransacoes,
		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 7 THEN idtransacao END) AS transacoes7D,
		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 28 THEN idtransacao END) AS transacoes28D,
		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 56 THEN idtransacao END) AS transacoes56D,
		COUNT(CASE WHEN CURRENT_DATE - DATE(dtcriacao) <= 365 THEN idtransacao END) AS transacoes365D
FROM transacoes
GROUP BY idcliente
ORDER BY qtdTransacoes DESC, transacoes7D, transacoes28D, transacoes56D, transacoes365D

-- Versão melhorada (Mais otimizada)
WITH tb_transacoes AS (
	SELECT idcliente, idtransacao, qtdepontos,
			DATE(dtcriacao) AS dtcriacao,
			DATE(CURRENT_DATE) - DATE(dtcriacao) AS diffdate,
		    MAX(DATE(dtcriacao)) AS ultima_transacao
	FROM transacoes
	GROUP BY idcliente, idtransacao, qtdepontos, dtcriacao
)
SELECT idcliente,
		COUNT(idtransacao) AS qtdeTransacoes,
		COUNT(CASE WHEN diffdate <= 7 THEN idtransacao END) AS transacoes7D,
		COUNT(CASE WHEN diffdate <= 28 THEN idtransacao END) AS transacoes28D,
		COUNT(CASE WHEN diffdate <= 56 THEN idtransacao END) AS transacoes56D,
		COUNT(CASE WHEN diffdate <= 365 THEN idtransacao END) AS transacoes365D
FROM tb_transacoes
GROUP BY idcliente
ORDER BY qtdetransacoes DESC, transacoes365d;
SELECT *,
		AGE(CURRENT_DATE, ultima_transacao)
FROM tb_transacoes;



-- Dia desde a última transação
WITH tb_transacoes AS (
	SELECT idcliente,
	    MAX(DATE(dtcriacao)) AS ultima_transacao
	FROM transacoes
	GROUP BY idcliente
	ORDER BY idcliente
)
SELECT *,
		AGE(CURRENT_DATE, ultima_transacao)
FROM tb_transacoes


-- Idade na base (Quanto tempo de cliente)
SELECT idcliente, DATE(dtcriacao),
		AGE(CURRENT_DATE, dtcriacao) AS tempodecliente
FROM clientes
ORDER BY tempodecliente DESC






