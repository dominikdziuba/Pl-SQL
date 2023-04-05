SET SERVEROUTPUT ON

DECLARE

V_IMIE CZYTELNIK.IMIE%TYPE;

V_NAZWISKO CZYTELNIK.NAZWISKO%TYPE;

BEGIN

SELECT CZ.NAZWISKO, CZ.IMIE  INTO V_NAZWISKO, V_IMIE FROM CZYTELNIK CZ, WYPOZYCZENIA W WHERE CZ.ID_CZYT = W.ID_CZYT

GROUP BY CZ.NAZWISKO, CZ.IMIE 

HAVING COUNT(W.ID_CZYT) = (SELECT MIN(COUNT(W.ID_CZYT)) FROM WYPOZYCZENIA W GROUP BY W.ID_CZYT);

DBMS_OUTPUT.put_line(V_IMIE||' '||V_NAZWISKO);



EXCEPTION 

WHEN TOO_MANY_ROWS THEN 

DBMS_OUTPUT.put_line('WIĘCEJ NIŻ JEDEN CZYTELNIK');



END;



SET SERVEROUTPUT ON

DECLARE

V_GATUNEK GATUNEK.G_NAZWA%TYPE;

V_TYTUL KSIAZKA.TYTUL%TYPE;

V_CENA KSIAZKA.CENA%TYPE;



BEGIN

SELECT G.G_NAZWA, K.TYTUL, K.CENA INTO V_GATUNEK, V_TYTUL, V_CENA

FROM KSIAZKA K, GATUNEK G 

WHERE K.ID_GAT = G.ID_GAT AND K.CENA = (

SELECT MAX(CENA) FROM KSIAZKA);

DBMS_OUTPUT.PUT_LINE(V_TYTUL||' '||V_GATUNEK||' '||V_CENA);

EXCEPTION



WHEN TOO_MANY_ROWS THEN 

DBMS_OUTPUT.put_line('WIĘCEJ NIŻ JEDNA KSIAZKA');



END;





CREATE TABLE AUTOR_LOG(

     ID_AUT_LOG   NUMBER(4)   CONSTRAINT PK_ID_AUT_LOG PRIMARY KEY,

     NAZWISKO     VARCHAR2(30),

     IMIE	  VARCHAR2(30),

     KRAJ VARCHAR2(30),

     LOG_OPERATION VARCHAR2(30)

     );

CREATE OR REPLACE TRIGGER OPERACJA

AFTER INSERT OR UPDATE OR DELETE ON AUTOR

FOR EACH ROW

BEGIN

IF INSERTING THEN

    INSERT INTO autor_log

    VALUES(:NEW.ID_AUT, :NEW.NAZWISKO, :NEW.IMIE, :NEW.KRAJ, 'INSERT');

ELSIF UPDATING  THEN

    INSERT INTO autor_log

    VALUES(:NEW.ID_AUT, :NEW.NAZWISKO, :NEW.IMIE, :NEW.KRAJ, 'UPDATE');

ELSIF DELETING THEN

    INSERT INTO autor_log

    VALUES(:OLD.ID_AUT, :OLD.NAZWISKO, :OLD.IMIE, :OLD.KRAJ, 'DELETE');

END IF;

END;




CREATE OR REPLACE TRIGGER DORIAN

BEFORE INSERT ON AUTOR

FOR EACH ROW

BEGIN

    IF :NEW.NAZWISKO = 'Dorian' THEN

        RAISE_APPLICATION_ERROR(-20123, 'Nie można dodać autora o nazwisku Dorian');

    END IF;

    END;






DECLARE

    CURSOR PODWYZKA IS SELECT * FROM KSIAZKA ORDER BY CENA FOR UPDATE;

BEGIN



    FOR I IN PODWYZKA LOOP

        IF I.CENA <= 300 AND I.CENA >= 0 THEN

            UPDATE KSIAZKA SET CENA = CENA *1.05 WHERE CURRENT OF PODWYZKA;

        ELSE

            RAISE_APPLICATION_ERROR(-20123, 'Cena książki nieprawidłowa;');

        END IF;

    END LOOP;

END;