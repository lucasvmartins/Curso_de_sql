-- JOINS
SELECT *
FROM transacao_produto AS tp
LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto
LIMIT 100


-- Selecionando todas as colunas da primeira tabela + algumas da segunda tabela
SELECT tp.*, p.descnomeproduto, p.desccategoriaproduto
FROM transacao_produto AS tp
LEFT JOIN produtos AS p
ON tp.idproduto = p.idproduto


