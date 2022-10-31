create or replace trigger ACCENSIONESPEGNIMENTOTELEFONO
    after insert on STATE_CHANGE
    for each row
    when (new.CHANGETYPE = 'O' OR new.CHANGETYPE = 'F')
declare
    CellaDiAppartenenza NUMBER;

begin
    --Ricavo cella a cui il telefono apparterrà/apparteneva (suppongo che esista e sia unica)
    SELECT CELLID into CellaDiAppartenenza
    FROM CELL
    WHERE X0<=:new.X AND :new.X<X1 AND
          Y0<=:new.Y AND :new.Y<Y1;

    if(:new.CHANGETYPE='O')then
        --Accensione telefono
        INSERT INTO TELEPHONE(PHONENO, X, Y, PHONESTATE)
        VALUES(:new.PHONENO, :new.X, :new.Y, 'On');

        UPDATE CELL
        SET CURRENTPHONE#=CURRENTPHONE#+1
        WHERE CELLID=CellaDiAppartenenza;

    else
        --Spegnimento telefono (:new.CHANGETYPE='F')
        DELETE FROM TELEPHONE
        WHERE PHONENO=:new.PHONENO;

        UPDATE CELL
        SET CURRENTPHONE#=CURRENTPHONE#-1
        WHERE CELLID=CellaDiAppartenenza;

    end if;

end;
/

