create or replace trigger DiminuzioneMaxCalls
    before update of MAXCALLS ON CELL
    for each row
    when (new.MAXCALLS < old.MAXCALLS)
declare
    ChiamateInCorso NUMBER;

begin
    --Ricavo numero di chiamate in corso sulla cella che si vuole modificare
    SELECT COUNT(*) into ChiamateInCorso
    FROM TELEPHONE
    WHERE PHONESTATE='Active' AND
          :old.X0<=X AND X<:old.X1 AND
          :old.Y0<=Y AND Y<:old.Y1;

    if(:new.MAXCALLS<ChiamateInCorso)then
        --Ci sono più chiamate in corso rispetto a quanto si vorrebbe mettere come capacità massima
        :new.MAXCALLS := ChiamateInCorso;
    end if;

end;
/

