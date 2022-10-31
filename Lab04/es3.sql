CREATE OR REPLACE TRIGGER AggiornamentoSummary
AFTER INSERT OR UPDATE OF JOB ON IMP
FOR EACH ROW
DECLARE
flagLavoroEsistente NUMBER;
BEGIN
    --Tecnica con il before non funziona perchè dovrei andare a leggere dalla tabella mutante
    --SELECT COUNT(*) into flagUpdate
    --FROM IMP
    --WHERE EMPNO=:new.EMPNO;

    --1. Verifico se si tratta di un inserimento o di un aggiornamento
    if(:old.JOB IS NOT NULL)then
        --Aggiornamento
        UPDATE SUMMARY
        SET NUM=NUM-1
        WHERE JOB=:old.JOB;

        --(opzionale: elimino dalla tabella summary se raggiungo lo 0)
        DELETE SUMMARY
        WHERE JOB=:old.JOB AND NUM=0;
    end if;

    --Da fare sia in caso di aggiornamento che di inserimento
    --Verifico se il nuovo lavoro era già presente nel DB
    SELECT COUNT(*) into flagLavoroEsistente
    FROM SUMMARY
    WHERE JOB=:new.JOB;

    if(flagLavoroEsistente<>0)then
        --Lavoro già presente
        UPDATE SUMMARY
        SET NUM=NUM+1
        WHERE JOB=:new.JOB;

    else
        --Nuovo lavoro
        INSERT INTO SUMMARY(JOB, NUM)
        VALUES(:new.JOB, 1);

    end if;


END;