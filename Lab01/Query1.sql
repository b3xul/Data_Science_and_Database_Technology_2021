/*Usando cube*/
SELECT TIPO_TARIFFA, ANNO, SUM(PREZZO) AS IMPORTO
FROM TARIFFA TAR, TEMPO T, FATTI F
WHERE TAR.ID_TAR=F.ID_TAR AND T.ID_TEMPO=F.ID_TEMPO
GROUP BY CUBE(TIPO_TARIFFA, ANNO);
/*Senza usare cube*/
SELECT TIPO_TARIFFA, ANNO,  SUM(SUM(PREZZO)) OVER () AS TOTALE_COMPLESSIVO,
                            SUM(PREZZO) AS TOTALE_PER_TARIFFA_E_ANNO,
                            SUM(SUM(PREZZO)) OVER (PARTITION BY TIPO_TARIFFA) AS TOTALE_PER_TARIFFA,
                            SUM(SUM(PREZZO)) OVER (PARTITION BY ANNO) AS TOTALE_PER_ANNO
FROM TARIFFA TAR, TEMPO T, FATTI F
WHERE TAR.ID_TAR=F.ID_TAR AND T.ID_TEMPO=F.ID_TEMPO
GROUP BY TIPO_TARIFFA, ANNO;