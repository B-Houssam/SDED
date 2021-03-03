-- TP2

--  Remplir la table typeAeroport
    insert into TypeAeroport values(1,'Nationale');
    insert into TypeAeroport values(2,'Internationale');

--  Remplir la table TypeCompagnie
    insert into TypeCompagnie values(1,'Etatique');
    insert into TypeCompagnie values(2,'Privée');

--  on remplit le reste en utilisant un code PL/SQL 
--  Remplir la table TypeCompagnie
    DECLARE
         v char(10);
         i number;
    begin
        for i in 1..194 loop
            Select dbms_random.string('U', 8) into v from dual;
            insert into Pays values(i,v);
        end loop;
        commit;
    end;
    /
    
--  Remplir la table Pilote
    DECLARE
         v char(10);
         w char(10);
         i number;
    begin
        for i in 1..9314 loop
            Select dbms_random.string('U', 8) into v from dual;
            Select dbms_random.string('U', 8) into w from dual;        
            insert into Pilote values(i,CONCAT(CONCAT(v, ' '),w));
        end loop;
        commit;
    end;
    /

--  Remplir la table Constructeur
    DECLARE
         v char(10);
         i number;
    begin
        for i in 1..5 loop
            Select dbms_random.string('U', 8) into v from dual;      
            insert into Constructeur values(i,v);
        end loop;
        commit;
    end;
    /

--  Remplir la table Ville
    DECLARE
         v char(10);
         w number;
         i number;
    begin
        for i in 1..12000 loop
            Select dbms_random.string('U', 8) into v from dual;      
            Select floor(dbms_random.value(1, 194.9)) into w from dual;
            insert into Ville values(i,w,v);
        end loop;
        commit;
    end;
    /

--  Remplir la table Modele
    DECLARE
         v char(10);
         w number;
         i number;
    begin
        for i in 1..120 loop
            Select dbms_random.string('U', 8) into v from dual;      
            Select floor(dbms_random.value(1, 5.9)) into w from dual;
            insert into Modele values(i,w,v);
        end loop;
        commit;
    end;
    /

--  Remplir la table Avion
    DECLARE
         w number;
         i number;
    begin
        for i in 1..8600 loop        
            Select floor(dbms_random.value(1, 120.9)) into w from dual;
            insert into Avion values(i,w);
        end loop;
        commit;
    end;
    /

--  Remplir la table Compagnie
    DECLARE
         v char(10);
         w number;
         x number;
         i number;
    begin
        for i in 1..200 loop        
            Select floor(dbms_random.value(1, 194.9)) into w from dual;
            Select floor(dbms_random.value(1, 1.9)) into x from dual;
            Select dbms_random.string('U', 8) into v from dual;   
            insert into Compagnie values(i,w,x,v);
        end loop;
        commit;
    end;
    /

--  Remplir la table Aeroport
    DECLARE
         v char(10);
         w number;
         x number;
         i number;
    begin
        for i in 1..17600 loop        
            Select floor(dbms_random.value(1, 12000.9)) into w from dual;
            Select floor(dbms_random.value(1, 1.9)) into x from dual;
            Select dbms_random.string('U', 8) into v from dual;   
            insert into Aeroport values(i,w,x,v);
        end loop;
        commit;
    end;
    /

--  Remplir la table vol
    DECLARE
        dr int;
        tp int;
        rt int;
        i int;
        Cmp int;
        P int;
        Av int;
        Aer1 int;
        Aer2 int;
        dt Date;
    begin
        for i in 1..865300 loop                
            SELECT TO_DATE( 
                TRUNC( DBMS_RANDOM.VALUE(TO_CHAR(DATE '2016-01-01','J')
                ,TO_CHAR(DATE '2020-12-31','J') ))
                ,'J') into dt FROM DUAL;
            Select floor(dbms_random.value(0, 1.9)) into tp from dual;
            Select floor(dbms_random.value(900, 32400)/30) into dr from dual;
            Select floor(dbms_random.value(1, 17600.9)) into Aer1 from dual;
            Select floor(dbms_random.value(1, 17600.9)) into Aer2 from dual;
            Select floor(dbms_random.value(0, 1.9)) into rt from dual;
            Select floor(dbms_random.value(1, 8600.9) ) into Av FROM DUAL;
            Select floor(dbms_random.value(1, 9314.9) ) into P FROM DUAL;
            Select floor(dbms_random.value(1, 200.9) ) into Cmp FROM DUAL;
            IF Aer1=Aer2 THEN
               Select floor(dbms_random.value(0, 17600.9)) into Aer2 from dual;
            END IF;
            insert into Vol values(i,tp,rt,dt,dr,Cmp,Aer1,Aer2,P,Av);
        end loop;
        commit;
    end;
    /