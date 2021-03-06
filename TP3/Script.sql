set autotrace on;

set timing on;

 connect SYS AS SYSDBA
 @?/sqlplus/admin/plustrce.sql
 grant plustrace to public

Update pays 
Set NomPays = 'Algerie'
where codePays = 100;

Update pays 
Set NomPays = 'Suede'
where codePays = 50;

select unique v.NumVol, v.datevol
from Vol v , Aeroport a1 , Aeroport a2 , Ville vl1 , Ville vl2 , Pays p1 , Pays p2
where v.NumAerDep = a1.NumAer 
and a1.CodeVille = vl1.CodeVille
and vl1.CodePays = p1.CodePays
and (p1.NomPays = 'Algerie' or p1.NomPays = 'Suede')
and  v.NumAerArr = a2.NumAer 
and a2.CodeVille = vl2.CodeVille
and vl2.CodePays = p2.CodePays
and (p2.NomPays = 'Algerie' or p2.NomPays = 'Suede');


CREATE MATERIALIZED VIEW VM1
    BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
    ENABLE QUERY REWRITE
    AS select v.NumVol, v.datevol , v.NumAerDep , a1.CodeVille as CodeVilleA , vl1.CodePays as CodePaysA , v.NumAerArr , a2.CodeVille as CodeVilleD ,vl2.CodePays  as CodePaysD
    from Vol v , Aeroport a1 , Aeroport a2 , Ville vl1 , Ville vl2 , Pays p1 , Pays p2
    where v.NumAerDep = a1.NumAer 
    and a1.CodeVille = vl1.CodeVille
    and vl1.CodePays = p1.CodePays
    and  v.NumAerArr = a2.NumAer 
    and a2.CodeVille = vl2.CodeVille
    and vl2.CodePays = p2.CodePays;

alter system flush shared_pool;
alter system flush buffer_cache;

set autotrace on ;
set timing on ;
select count(*) as NBVol, to_char(DateVol,'YYYY')
from vol
group by  to_char(DateVol,'YYYY')
order by  to_char(DateVol,'YYYY');

alter system flush shared_pool;
alter system flush buffer_cache;

CREATE MATERIALIZED VIEW VM2 
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
select count(*) as NBVol, to_char(DateVol,'YYYY')
from vol
group by  to_char(DateVol,'YYYY')
order by  to_char(DateVol,'YYYY');


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
        for i in 865300..1200000 loop                
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

drop materialized view vm2;

CREATE MATERIALIZED VIEW VM2 
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
select count(*) as NBVol, to_char(DateVol,'YYYY')
from vol
group by  to_char(DateVol,'YYYY')
order by  to_char(DateVol,'YYYY');

execute DBMS_MVIEW.REFRESH('VM2');

alter system flush shared_pool;
alter system flush buffer_cache;

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
        for i in 1200001..2000000 loop                
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

drop materialized view vm2;

CREATE MATERIALIZED VIEW VM2 
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
select count(*) as NBVol, to_char(DateVol,'YYYY')
from vol
group by  to_char(DateVol,'YYYY')
order by  to_char(DateVol,'YYYY');

execute DBMS_MVIEW.REFRESH('VM2');

alter system flush shared_pool;
alter system flush buffer_cache;