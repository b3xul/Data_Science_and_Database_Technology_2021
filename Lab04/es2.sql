CREATE OR REPLACE TRIGGER AggiornaENotifica
AFTER INSERT ON TICKETS
FOR EACH ROW
WHEN (new.CARDNO IS NOT NULL)
DECLARE
OldMiles number;
MilesToAdd number;
NewMiles number;
MaxNotifyNo number;
BEGIN
    --0.Trovare miglia iniziali del cliente
    SELECT SUM(MILES) into OldMiles
    FROM CREDITS
    WHERE CREDITS.CARDNO=:new.CARDNO;
    -- GROUP BY CREDITS.CARDNO non serve perchè basta selezionare le tuple da considerare con la where
    -- Inoltre causa un errore perchè facendo group by e sum su un insieme vuoto si genera un'eccezione,
    -- che non si avrebbe se si rimuove la group by!
    if(OldMiles IS NULL)then
        OldMiles:=0;
    end if;

    --1.Trovare miglia da aggiungere ai crediti dell'acquirente
    SELECT MILES into MilesToAdd
    FROM FLIGHTS
    WHERE FLIGHTID=:new.FLIGHTID;

    --2. Aggiornare crediti legati alla tessera acquirente
    INSERT INTO CREDITS(TICKETID, CARDNO, MILES)
    VALUES(:new.TICKETID, :new.CARDNO, MilesToAdd);

    --3. Valutare se acquirente ha cambiato stato
    NewMiles:=OldMiles+MilesToAdd;
    if(OldMiles<30000 AND NewMiles>=30000) then
        UPDATE CARDS
        SET STATUS='GOLD'
        WHERE CARDNO=:new.CARDNO;

        --4.Se stato è cambiato trovare MaxNotifyNo e inserire informazioni in NOTIFY
        SELECT MAX(NOTIFYNO) into MaxNotifyNo
        FROM NOTIFY;
        if(MaxNotifyNo IS NULL) then
            MaxNotifyNo:=0;
        end if;

        INSERT INTO NOTIFY(CARDNO, NOTIFYNO, NOTIFYDATE, OLDSTATUS, NEWSTATUS, TOTALMILES)
        VALUES(:new.CARDNO, MaxNotifyNo+1, SYSDATE, 'SILVER', 'GOLD', NewMiles);

    else
	if(OldMiles<50000 AND NewMiles>=50000) then
        UPDATE CARDS
        SET STATUS='PREMIUM'
        WHERE CARDNO=:new.CARDNO;

        --4.Se stato è cambiato trovare MaxNotifyNo e inserire informazioni in NOTIFY
        SELECT MAX(NOTIFYNO) into MaxNotifyNo
        FROM NOTIFY;
        if(MaxNotifyNo IS NULL) then
            MaxNotifyNo:=0;
        end if;

        INSERT INTO NOTIFY(CARDNO, NOTIFYNO, NOTIFYDATE, OLDSTATUS, NEWSTATUS, TOTALMILES)
        VALUES(:new.CARDNO, MaxNotifyNo+1, SYSDATE, 'GOLD', 'PREMIUM', NewMiles);

    end if;

END;