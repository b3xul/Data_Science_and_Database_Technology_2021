create or replace trigger GaranziaServizio
    after update of MAXCALLS on CELL
    --statement
declare
    MaxCallsTot NUMBER;

begin
    --MaxCallsTot non sarà NULL perchè il trigger si attiva solo in risposta ad un update, quindi CELL non può essere vuota
    SELECT SUM(MAXCALLS) into MaxCallsTot
    FROM CELL;

    if(MaxCallsTot < 30) then
        RAISE_APPLICATION_ERROR(-20000, 'Garanzia di Servizio non rispettata');
    end if;
end;
/