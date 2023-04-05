SELECT C.IMIE ||' '|| C.NAZWISKO AS "DANE CZYTELNIKA", COUNT(DISTINCT K.ID_GAT) AS "LICZBA GATUNKOW" FROM CZYTELNIK C, KSIAZKA K, WYPOZYCZENIA W

WHERE c.id_czyt = w.id_czyt AND w.id_ks = k.id_ks

GROUP BY C.IMIE ||' '|| C.NAZWISKO

ORDER BY "LICZBA GATUNKOW" DESC;


SELECT COUNT(K.ID_KS)

FROM KSIAZKA K

WHERE id_wyd = 

(SELECT K.id_wyd FROM KSIAZKA K WHERE data_wyd=

(SELECT MIN(K.data_wyd) FROM ksiazka K));


SELECT F.F_NAZWA AS "NAJCZESCIEJ POZYCZANY FORMAT"
FROM FORMAT F
JOIN KSIAZKA K ON K.ID_FOR = F.ID_FOR
JOIN WYPOZYCZENIA W ON W.ID_KS = K.ID_KS
WHERE W.DATA_WYP >= ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'), -3)
GROUP BY F.F_NAZWA
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROW ONLY;



SELECT F.F_NAZWA AS "RODZAJ", COUNT(*) AS "LICZBA KSIAZEK", SUM(K.CENA) AS "ŁĄCZNA CENA"
FROM KSIAZKA K
JOIN FORMAT F ON K.ID_FOR = F.ID_FOR
GROUP BY F.F_NAZWA;



SELECT G.G_NAZWA AS "NAZWA GATUNKU", COUNT(*) AS "LICZBA WYPOZYCZEN"
FROM GATUNEK G
JOIN KSIAZKA K ON G.ID_GAT = K.ID_GAT
JOIN WYPOZYCZENIA W ON K.ID_KS = W.ID_KS
WHERE G.ID_GAT IN (
    SELECT ID_GAT
    FROM KSIAZKA K
    GROUP BY ID_GAT
    HAVING COUNT(*) > (
        SELECT AVG(cnt)
        FROM (
            SELECT COUNT(*) as cnt
            FROM KSIAZKA K
            JOIN WYPOZYCZENIA W ON K.ID_KS = W.ID_KS
            GROUP BY K.ID_GAT
        )
    )
)
GROUP BY G.G_NAZWA;






SELECT *
FROM AUTOR A
WHERE A.ID_AUT IN (SELECT AT.ID_AUT
                  FROM AUTOR_TYTUL AT
                  WHERE AT.ID_KS IN (SELECT K.ID_KS
                                    FROM KSIAZKA K
                                    WHERE K.ID_GAT = (SELECT K.ID_GAT
                                                      FROM KSIAZKA K
                                                      WHERE K.L_STRON = (SELECT MIN(K.L_STRON)
                                                                         FROM KSIAZKA K))));





SET SERVEROUTPUT ON
DECLARE
    v_n NUMBER:= 3;
    factorial NUMBER :=1;
    BEGIN
    IF v_n<0 THEN
        DBMS_OUTPUT.PUT_LINE('Wprowadzona liczba musi byc wieksza od 0');
    ELSIF v_n=0 THEN
        DBMS_OUTPUT.PUT_LINE('Silnia wynosi: '||factorial);
    ELSE
        FOR i in 1.. v_n loop
            factorial:=factorial*i;
        end loop;
        DBMS_OUTPUT.PUT_LINE('Silnia z ' ||v_n || 'wynosi ' || factorial);
    end if;
end;





DECLARE
    TYPE r_student IS RECORD
    (
        v_id NUMBER(10),
        v_lastname VARCHAR(30),
        v_city VARCHAR(30),
        v_phone NUMBER(30)
    );
    vr_student r_student;
BEGIN
    vr_student.v_id:=1;
    vr_student.v_lastname := 'Dziuba';
    vr_student.v_city := 'Kraków';
    vr_student.v_phone := 123456789;

    DBMS_OUTPUT.PUT_LINE(vr_student.v_id);
    DBMS_OUTPUT.PUT_LINE(vr_student.v_lastname);
    DBMS_OUTPUT.PUT_LINE(vr_student.v_city);
    DBMS_OUTPUT.PUT_LINE(vr_student.v_phone);

end;




DECLARE
    a NUMBER := 50;
    b NUMBER := 35;
    c NUMBER := a;
    d NUMBER := b;
    nwd NUMBER;
BEGIN
  WHILE d != 0 LOOP
    nwd := MOD(c,d);
    c := d;
    d := nwd;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('NWD('||a ||', ' || b ||') = ' || c);
END;


