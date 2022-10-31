SELECT Edizione, CodP,  SUM(SUM(Numero)) OVER (PARTITION BY Edizione),
                        100*SUM(Numero)/SUM(SUM(Numero)) OVER (PARTITION BY Edizione),
                        RANK() OVER (   PARTITION BY Edizione
                                        ORDER BY SUM(Valore)/SUM(Numero) DESC )
FROM TEMPO T, VOTO V
WHERE T.CodTempo=V.CodTempo AND Edizione>=2000 AND Edizione<=2010
GROUP BY Edizione, CodP