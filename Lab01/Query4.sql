SELECT DATA, SUM(PREZZO) AS INCASSO_GIORNALIERO, AVG(SUM(PREZZO)) OVER ( ORDER BY DATA
                                                                         RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW) AS MediaMobile3Giorni
FROM TARIFFA TAR, TEMPO T, FATTI F
WHERE   TAR.ID_TAR=F.ID_TAR AND T.ID_TEMPO=F.ID_TEMPO
        AND EXTRACT(MONTH FROM T.DATA)=7 AND ANNO=2003
GROUP BY DATA
ORDER BY DATA;