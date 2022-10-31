/*Per verificare execution time*/
SELECT CPU_TIME, EXECUTIONS 
  FROM V$SQLAREA
 WHERE UPPER (SQL_TEXT) LIKE 'SELECT TIPO_TARIFFA, ANNO, SUM(PREZZO) AS IMPORTO%';
 
/*Query1*/
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

/*Query2*/
SELECT MESE, SUM(CHIAMATE) AS CHIAMATE_TOTALI, SUM(PREZZO) AS INCASSO_TOTALE, RANK() OVER (ORDER BY SUM(PREZZO) DESC)
FROM TEMPO T, FATTI F
WHERE T.ID_TEMPO=F.ID_TEMPO
GROUP BY MESE;

SELECT MESE, CHIAMATE_MENSILI, INCASSO_MENSILE RANK() OVER (ORDER BY INCASSO_MENSILE DESC)
FROM CHIAMATE_INCASSI_MESE

/*Query3*/
SELECT MESE, SUM(CHIAMATE) AS CHIAMATE_TOTALI, RANK() OVER (ORDER BY SUM(CHIAMATE) DESC)
FROM TEMPO T, FATTI F
WHERE T.ID_TEMPO=F.ID_TEMPO AND ANNO=2003
GROUP BY MESE;

SELECT MESE, CHIAMATE_MENSILI, RANK() OVER (ORDER BY CHIAMATE_MENSILI DESC)
FROM CHIAMATE_INCASSI_MESE
WHERE EXTRACT(YEAR FROM MESE)=2003;
(funzionerebbe se mese fosse nel formato corretto mm-yyyy, che non sembra ottenibile in oracle!
soluzione: 2 diversi campi con mese e anno)

/*Query4*/
SELECT DATA, SUM(PREZZO) AS INCASSO_GIORNALIERO, AVG(SUM(PREZZO)) OVER ( ORDER BY DATA
                                                                         RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW) AS MediaMobile3Giorni
FROM TEMPO T, FATTI F
WHERE   T.ID_TEMPO=F.ID_TEMPO
        AND EXTRACT(MONTH FROM T.DATA)=7 AND ANNO=2003
GROUP BY DATA
ORDER BY DATA;

/*Query5*/
SELECT MESE, SUM(PREZZO) AS INCASSO_MENSILE, SUM(SUM(PREZZO)) OVER (PARTITION BY EXTRACT(YEAR FROM MESE)
                                                                    ORDER BY MESE
                                                                    ROWS UNBOUNDED PRECEDING) AS INCASSO_CUMULATIVO
FROM TEMPO T, FATTI F
WHERE T.ID_TEMPO=F.ID_TEMPO
GROUP BY MESE
ORDER BY MESE;

SELECT MESE, INCASSO_MENSILE, SUM(SUM(PREZZO)) OVER (PARTITION BY EXTRACT(YEAR FROM MESE)
                                                     ORDER BY MESE
                                                     ROWS UNBOUNDED PRECEDING) AS INCASSO_CUMULATIVO
FROM CHIAMATE_INCASSI_MESE

/*MaterializedView*/
DROP MATERIALIZED VIEW CHIAMATE_INCASSI_MESE;

CREATE MATERIALIZED VIEW CHIAMATE_INCASSI_MESE
BUILD IMMEDIATE
REFRESH FORCE ON COMMIT
ENABLE QUERY REWRITE
AS
SELECT MESE, SUM(CHIAMATE) AS CHIAMATE_MENSILI, SUM(PREZZO) AS INCASSO_MENSILE
FROM TEMPO T, FATTI F
WHERE T.ID_TEMPO=F.ID_TEMPO
GROUP BY MESE;