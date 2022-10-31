SELECT Edizione, Città, SUM(SUM(Incasso)) OVER (PARTITION BY Città
                                                ORDER BY Edizione
                                                ROWS UNBOUNDED PRECEDING),
                        100*SUM(Incasso)/SUM(SUM(Incasso)) OVER (PARTITION BY Edizione),
                        SUM(Incasso)/(  SELECT COUNT(DISTINCT Data)
                                        FROM TEMPO T2
                                        WHERE T1.Edizione=T2.Edizione )
FROM LUOGO L, TEMPO T1, TELESPETTATORE TE, VOTO V
WHERE L.CodL=TE.CodL AND TE.CodT=V.CodT AND T.CodTempo=V.CodTempo AND Codm='Instagram'
GROUP BY Edizione,Città;

--giusta:
SELECT Edizione, Città, SUM(SUM(Incasso)) OVER (PARTITION BY Città
                                                ORDER BY Edizione
                                                ROWS UNBOUNDED PRECEDING),
                        100*SUM(Incasso)/SUM(SUM(Incasso)) OVER (PARTITION BY Edizione),
                        SUM(Incasso)/COUNT(DISTINCT Data)
FROM LUOGO L, TEMPO T1, TELESPETTATORE TE, VOTO V
WHERE L.CodL=TE.CodL AND TE.CodT=V.CodT AND T.CodTempo=V.CodTempo AND Codm='Instagram'
GROUP BY Edizione,Città