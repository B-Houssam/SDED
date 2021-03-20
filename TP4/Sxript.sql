CREATE TABLE DTemps (
    CodeTemps Number(10) PRIMARY KEY,
    Jour VARCHAR2(15),
    LibJour VARCHAR2(15),
    Mois VARCHAR2(15),
    LibMois VARCHAR2(15),
    Annee VARCHAR2(15)
);

CREATE TABLE DModele
(
	CodeModele Number(5) primary key,
    CodeCons Number(1),
	LibModele varchar2(30),	
    NomConst varchar2(30)
);

CREATE TABLE DCompagnie
(
	CodeComp Number(3) primary key,
    CodeTypeComp Number(1),
	NomComp varchar2(30),	
    TypeComp varchar2(30)	
);


CREATE TABLE DAeroportArr
(
	NumAerA Number(5) primary key,
    CodeVille Number(5),
    CodePays Number(3),
    CodeTypAerA Number(1),
	NomAerA varchar2(30),	
    NomVille varchar2(30),	
    NomPays varchar2(30),
    TypeAerA varchar2(30)    	
);


CREATE TABLE DAeroportDep
(
	NumAerD Number(5) primary key,
    CodeVille Number(5),
    CodePays Number(3),
    CodeTypAerD Number(1),
	NomAerD varchar2(30),	
    NomVille varchar2(30),	
    NomPays varchar2(30),
    TypeAerD varchar2(30)    	
);

CREATE TABLE FTraffic
(
	NumAerD Number(5),
    NumAerA Number(5),    
    CodeModele Number(3),
    CodeComp Number(3),
    CodeTemps Number(10),
	NbVol INTEGER,	
    NbVolRetard INTEGER,	
    CONSTRAINT PK_Person PRIMARY KEY (NumAerD,NumAerA,CodeModele,CodeComp,CodeTemps),
    constraint fk_trf_cmp Foreign key (CodeComp) references DCompagnie(CodeComp),
    constraint fk_trf_aerdep Foreign key (NumAerD) references DAeroportDep(NumAerD),
    constraint fk_trf_aerarr Foreign key (NumAerA) references DAeroportArr(NumAerA),
    constraint fk_trf_mdl Foreign key (CodeModele) references DModele(CodeModele),
    constraint fk_trf_tmp Foreign key (CodeTemps) references DTemps(CodeTemps)
);

begin
  for i in (SELECT unique ar.NumAer as NumAer , ar.CodeVille as CodeVille , ar.NomAer as NomAer
            , ar.CodeTypeAer as CodeTypeAer , v.NomVille as NomVille , p.CodePays as CodePays 
            ,p.NomPays as NomPays , ta.TypeAer as TypeAer
                FROM Master.Vol vl,Master.Aeroport ar , Master.Ville v , Master.Pays p , Master.TypeAeroport ta
                where ar.CodeVille = v.CodeVille
                and ar.CodeTypeAer = ta.CodeTypeAer
                and v.CodePays = p.CodePays
                and vl.NumAerArr = ar.NumAer
                )
    loop
      insert into DAeroportArr
      values (i.NumAer, i.CodeVille, i.CodePays, i.CodeTypeAer, i.NomAer, i.NomVille,
             i.NomPays, i.TypeAer);
    end loop;
commit;      
end;
/

begin
  for i in (SELECT unique ar.NumAer as NumAer , ar.CodeVille as CodeVille , ar.NomAer as NomAer
            , ar.CodeTypeAer as CodeTypeAer , v.NomVille as NomVille , p.CodePays as CodePays 
            ,p.NomPays as NomPays , ta.TypeAer as TypeAer
                FROM Master.Vol vl,Master.Aeroport ar , Master.Ville v , Master.Pays p , Master.TypeAeroport ta
                where ar.CodeVille = v.CodeVille
                and ar.CodeTypeAer = ta.CodeTypeAer
                and v.CodePays = p.CodePays
                and vl.NumAerDep = ar.NumAer
                )
    loop
      insert into DAeroportDep
      values (i.NumAer, i.CodeVille, i.CodePays, i.CodeTypeAer, i.NomAer, i.NomVille,
             i.NomPays, i.TypeAer);
    end loop;
commit;      
end;
/

begin
  for i in (SELECT cmp.CodeComp as CodeComp , cmp.NomCom as NomCom 
            , tc.CodeTypeComp as CodeTypeComp, tc.TypeComp as TypeComp
                FROM Master.Compagnie cmp , Master.TypeCompagnie tc
                where cmp.CodeTypeComp = tc.CodeTypeComp               
                )
    loop
      insert into DCompagnie
      values ( i.CodeComp, i.CodeTypeComp, i.NomCom,  i.TypeComp);
    end loop;
commit;      
end;
/

begin
  for i in (SELECT mdl.CodeMod as CodeComp , mdl.CodeCons as CodeCons 
            , mdl.LibMod as LibMod, cst.NomCons as NomCons
                FROM Master.Modele mdl , Master.Constructeur cst
                where mdl.CodeCons = cst.CodeCons               
                )
    loop
      insert into DModele
      values ( i.CodeComp, i.CodeCons, i.LibMod,  i.NomCons);
    end loop;
commit;      
end;
/

CREATE SEQUENCE seq
MINVALUE 1
MAXVALUE 100000
START WITH 1
INCREMENT BY 1 ;

begin
  for i in (SELECT unique TO_CHAR(DateVol,'DD/MM/YYYY') as Jour,
            TO_CHAR(DateVol,'DAY') as Libjour, TO_CHAR(DateVol,'MM/YYYY') as Mois,
            TO_CHAR(DateVol,'MONTH') as LibMois, TO_CHAR(DateVol,'YYYY') as Annee 
            FROM Master.Vol 
                )
    loop
      insert into DTemps
      values (seq.NEXTVAL, i.Jour, i.Libjour, i.Mois, i.LibMois, i.Annee);
    end loop;
commit;      
end;
/

begin
  for i in (SELECT ar1.NumAerA as NumAerA ,ar2.NumAerD as NumAerD , m.CodeModele as CodeModele ,
            cmp.CodeComp as CodeComp, tmp.CodeTemps as CodeTemps , sum(v.Retard) as NbVolRetard, count(*) as NbVol
            FROM DTemps tmp, DModele m, DCompagnie cmp, DAeroportArr ar1, 
            DAeroportDep ar2, Master.vol v, Master.Avion av
            where v.NumAerDep = ar2.NumAerD
            and v.NumAerArr = ar1.NumAerA 
            and TO_CHAR(v.DateVol,'DD/MM/YYYY') = tmp.Jour 
            and av.NumAv = v.NumAv
            and av.CodeMod = m.CodeModele
            and v.CodeComp = cmp.CodeComp
            group by (ar1.NumAerA,ar2.NumAerD,m.CodeModele,cmp.CodeComp,tmp.CodeTemps)
                )
    loop
      insert into FTraffic
      values (i.NumAerA, i.NumAerD, i.CodeModele, i.CodeComp, i.CodeTemps, i.NbVolRetard, i.NbVol);
    end loop;
commit;      
end;
/