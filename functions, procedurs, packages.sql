CREATE OR REPLACE FUNCTION SUMA_CEN

(P_ID_GAT IN NUMBER) RETURN NUMBER IS V_SUMA_CEN NUMBER(4,0);

BEGIN

    SELECT SUM(CENA) INTO V_SUMA_CEN

    FROM KSIAZKA 

    WHERE ID_GAT = p_id_gat;

    RETURN v_suma_cen;

END SUMA_CEN;



create or replace FUNCTION CENA_NETTO

(P_ID_KS IN NUMBER) RETURN NUMBER IS 

V_CENA_NETTO NUMBER(5,2);

BEGIN

    SELECT (CENA*0.92) INTO V_CENA_NETTO 

    FROM KSIAZKA

    WHERE ID_KS = P_ID_KS;

    RETURN V_CENA_NETTO;

EXCEPTION

WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('Niepoprawne ID ksiazki');

WHEN TOO_MANY_ROWS THEN

    dbms_output.put_line('Ta ksiazka ma więcej niz jednego autora');

END CENA_NETTO;



create or replace PROCEDURE ZMIEN_CENE

(P_ID_KS NUMBER) IS

V_CENA KSIAZKA.CENA%TYPE;

BEGIN

    SELECT CENA INTO V_CENA FROM KSIAZKA WHERE ID_KS = P_ID_KS;

    IF V_CENA >= 25 THEN

        V_CENA := V_CENA * 1.1;

    ELSE

        V_CENA := V_CENA * 1.15;

    END IF;

    DBMS_OUTPUT.PUT_LINE('Nowa cena wybranej ksiazki to: ' ||V_CENA);

END ZMIEN_CENE;





create or replace PROCEDURE SPRAWDZ_WYDAWNICTWO IS

V_W_NAZWA WYDAWNICTWO.W_NAZWA%TYPE;

V_TYTUL KSIAZKA.TYTUL%TYPE;

V_AUTOR AUTOR.NAZWISKO%TYPE;

BEGIN

    SELECT W.W_NAZWA, K.TYTUL, A.NAZWISKO 

    INTO V_W_NAZWA, V_TYTUL, V_AUTOR 

    FROM WYDAWNICTWO W, KSIAZKA K, AUTOR A, AUTOR_TYTUL AT

    WHERE W.ID_WYD = K.ID_WYD AND K.ID_KS = AT.ID_KS AND AT.ID_AUT = A.ID_AUT  AND K.DATA_WYD = (

    SELECT MIN(DATA_WYD) FROM KSIAZKA);

    DBMS_OUTPUT.PUT_LINE(V_W_NAZWA||' '||V_TYTUL||' '||V_AUTOR);

EXCEPTION

    WHEN TOO_MANY_ROWS THEN

    RAISE_APPLICATION_ERROR (-2001, 'Istnieje więcej niż jedno takie wydawnictwo');

END SPRAWDZ_WYDAWNICTWO;






create or replace PACKAGE PIERWSZY IS

FUNCTION FORMATY (P_NAZWISKO IN VARCHAR2, P_IMIE IN VARCHAR2) RETURN NUMBER;

PROCEDURE MALE_WYDAWNICTWO;

END PIERWSZY;


create or replace PACKAGE BODY PIERWSZY IS

FUNCTION FORMATY (P_NAZWISKO IN VARCHAR2, P_IMIE IN VARCHAR2) RETURN NUMBER IS V_LICZBA_FORMATOW NUMBER(5);

BEGIN

    SELECT COUNT(DISTINCT K.ID_FOR) INTO V_LICZBA_FORMATOW 

    FROM KSIAZKA K, AUTOR A, AUTOR_TYTUL AT

    WHERE A.NAZWISKO = P_NAZWISKO AND A.IMIE = P_IMIE AND A.ID_AUT = AT.ID_AUT AND AT.ID_KS = K.ID_KS;

    RETURN V_LICZBA_FORMATOW;

END FORMATY;



PROCEDURE MALE_WYDAWNICTWO IS

CURSOR WYP IS SELECT DISTINCT K.TYTUL, C.NAZWISKO

FROM WYDAWNICTWO WYD, KSIAZKA K, WYPOZYCZENIA WYP, CZYTELNIK C

WHERE WYD.ID_WYD = K.ID_WYD

AND K.ID_KS = WYP.ID_KS

AND WYP.ID_CZYT = C.ID_CZYT

AND WYD.ID_WYD = (

SELECT WYD.ID_WYD

FROM WYDAWNICTWO WYD, KSIAZKA K

WHERE WYD.ID_WYD = K.ID_WYD

GROUP BY WYD.ID_WYD

HAVING COUNT(K.ID_KS) = (

SELECT MIN(KS_COUNT)

FROM (

SELECT COUNT(K.ID_KS) AS KS_COUNT

FROM WYDAWNICTWO WYD, KSIAZKA K

WHERE WYD.ID_WYD = K.ID_WYD

GROUP BY WYD.ID_WYD

)

)

);





BEGIN

FOR I IN WYP LOOP

DBMS_OUTPUT.PUT_LINE(I.NAZWISKO||' '||I.TYTUL);

END LOOP;

END MALE_WYDAWNICTWO;

END PIERWSZY;
