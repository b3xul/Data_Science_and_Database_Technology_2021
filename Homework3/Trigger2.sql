create or replace trigger InizioTelefonata
    after insert on STATE_CHANGE
    for each row
    when (new.CHANGETYPE = 'C')
declare
    CellaDiAppartenenza NUMBER;
    X0Cella NUMBER;
    X1Cella NUMBER;
    Y0Cella NUMBER;
    Y1Cella NUMBER;
    ChiamateGestibili NUMBER;
    ChiamateInCorso NUMBER;
    HighestExId NUMBER;

begin
    --Ricavo cella a cui il telefono appartiene (suppongo che esista e sia unica) e numero massimo di chiamate gestibili da quella cella
    SELECT CELLID, X0, X1, Y0, Y1, MAXCALLS into CellaDiAppartenenza, X0Cella, X1Cella, Y0Cella, Y1Cella, ChiamateGestibili
    FROM CELL
    WHERE X0<=:new.X AND :new.X<X1 AND
          Y0<=:new.Y AND :new.Y<Y1;

    --Ricavo numero di chiamate in corso su quella cella
    SELECT COUNT(*) into ChiamateInCorso
    FROM TELEPHONE
    WHERE PHONESTATE='Active' AND
          X0Cella<=X AND X<X1Cella AND
          Y0Cella<=Y AND Y<Y1Cella;

    if(ChiamateGestibili>ChiamateInCorso)then
        --Effettuo chiamata cambiando stato del telefono e diminuendo MaxCalls nella cella di appartenenza
        UPDATE TELEPHONE
        SET PHONESTATE='Active'
        WHERE PHONENO=:new.PHONENO;


    else
        --Numero massimo di chiamate raggiunto: inserisco nuova eccezione trovando l'exid successivo per la cella di appartenenza
        SELECT MAX(EXID) into HighestExId
        FROM EXCEPTION_LOG
        WHERE CELLID=CellaDiAppartenenza;

        if(HighestExId IS NULL)then
            --Non è ancora presente nessuna eccezione per la cella di appartenenza
            HighestExId:=0;
        end if;

        INSERT INTO EXCEPTION_LOG(EXID, CELLID, EXCEPTIONTYPE)
        VALUES(HighestExId+1, CellaDiAppartenenza, 'M');

    end if;

end;
/

