QUERY a
SELECT Edizione, Città, SUM(SUM(Incasso)) OVER (PARTITION BY Città
                                                ORDER BY Edizione
                                                ROWS UNBOUNDED PRECEDING),
                        100*SUM(Incasso)/SUM(SUM(Incasso)) OVER (PARTITION BY Edizione),
                        SUM(Incasso)/(  SELECT COUNT(DISTINCT Data)
                                        FROM TEMPO T2
                                        WHERE T1.Edizione=T2.Edizione )
FROM LUOGO L, TEMPO T1, TELESPETTATORE TE, VOTO V
WHERE L.CodL=TE.CodL AND TE.CodT=V.CodT AND T.CodTempo=V.CodTempo AND Codm='Instagram'
GROUP BY Edizione,Città

QUERY b
SELECT Edizione, CodP,  SUM(SUM(Numero)) OVER (PARTITION BY Edizione),
                        100*SUM(Numero)/SUM(SUM(Numero)) OVER (PARTITION BY Edizione),
                        RANK() OVER (   PARTITION BY Edizione
                                        ORDER BY SUM(Valore)/SUM(Numero) DESC )
FROM TEMPO T, VOTO V
WHERE T.CodTempo=V.CodTempo AND Edizione>=2000 AND Edizione<=2010
GROUP BY Edizione, CodP