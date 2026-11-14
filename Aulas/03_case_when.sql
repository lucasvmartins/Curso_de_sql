-- CASE WHEN
/*
Classe baixa x < 2200
Classe média baixa 2200 <= x < 5500
Classe média 5500 <= x < 11000
Classe média alta 11000 <= x < 22000
Classe alta 22000 <= x
*/

SELECT idcliente, qtdepontos,
		CASE
			WHEN qtdepontos < 2200 THEN 'Classe baixa'
			WHEN qtdepontos >= 2200 AND qtdepontos < 5500 THEN 'Classe média baixa'
			WHEN qtdepontos >= 5500 AND qtdepontos < 11000 THEN 'Classe média'
			WHEN qtdepontos >= 11000 AND qtdepontos < 22000 THEN 'Classe média alta'
			ELSE 'Classe alta'
			-- WHEN qtdepontos >= 22000 THEN 'Classe alta'
			END AS "Classe por pontos",
		
		CASE
			WHEN fltwitch = 1 THEN 1
			ELSE 0
			END AS "Twitch"
			
FROM clientes
ORDER BY qtdepontos DESC


