 set autotrace on ;
 set timing on ;

Update DAeroportArr 
Set NomPays = 'Portugal'
where codePays = 10;

Update DAeroportDep 
Set NomPays = 'Portugal'
where codePays = 10;

select a1.CodePays,a1.NomPays, sum(v.NbVolRetard)
from FTraffic v , DAeroportDep a1  
where v.NumAerD = a1.NumAerD
and a1.NomPays = 'Portugal'
and v.NbVolRetard > 0
group by (a1.CodePays, a1.NomPays);

CREATE MATERIALIZED VIEW VMWilaya
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
    select a1.CodePays,a1.NomPays, sum(v.NbVolRetard)
    from FTraffic v , DAeroportDep a1  
    where v.NumAerD = a1.NumAerD
    and v.NbVolRetard > 0
    group by (a1.CodePays, a1.NomPays);

alter system flush shared_pool;
alter system flush buffer_cache;

CREATE MATERIALIZED VIEW VMNBVolMensuel 
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
select tmp.Mois , sum(v.NbVol)
from FTraffic v , DTemps tmp
where tmp.CodeTemps = v.CodeTemps
group by  Mois;

from FTraffic v , DTemps tmp
where tmp.CodeTemps = v.CodeTemps
group by  Annee;

CREATE DIMENSION DimTemps 
LEVEL LJour IS (DTemps.Jour)
LEVEL LMois IS (DTemps.Mois)
LEVEL LAnnee IS (DTemps.Annee)
HIERARCHY H_J_M_A ( LJour CHILD OF LMois CHILD OF LAnnee)
ATTRIBUTE LJour DETERMINES (DTemps.LibJour , DTemps.Jour ) 
ATTRIBUTE LMois DETERMINES (DTemps.LibMois , DTemps.Mois ); 

CREATE DIMENSION DimModel 
LEVEL LModel IS (DModele.CodeModele)
LEVEL LConstructeur IS (DModele.CodeCons)
HIERARCHY H_MOD_CSTR ( LModel CHILD OF LConstructeur)
ATTRIBUTE LModel DETERMINES (DModele.CodeModele, DModele.NomConst ) 
ATTRIBUTE LConstructeur DETERMINES (DModele.CodeModele , DModele.LibModele ); 

CREATE DIMENSION DimCompagnie 
LEVEL LCompagnie IS (DCompagnie.CodeComp)
LEVEL LTypeCompagnie IS (DCompagnie.CodeTypeComp)
HIERARCHY H_COMP_TCOMP ( LCompagnie CHILD OF LTypeCompagnie)
ATTRIBUTE LCompagnie DETERMINES (DCompagnie.CodeComp , DCompagnie.NomComp ) 
ATTRIBUTE LTypeCompagnie DETERMINES (DCompagnie.CodeTypeComp , DCompagnie.TypeComp ); 

CREATE DIMENSION DimAeroportArr 
LEVEL LAeroportArr IS (DAeroportArr.NumAerA)
LEVEL LVille IS (DAeroportArr.CodeVille)
LEVEL LPays IS (DAeroportArr.CodePays)
LEVEL LTypAerA IS (DAeroportArr.CodeTypAerA)
HIERARCHY H_COMP_TCOMP ( LAeroportArr CHILD OF LVille CHILD OF LPays)
HIERARCHY H_COMP_TCOMP ( LAeroportArr CHILD OF LTypAerA)
ATTRIBUTE LAeroportArr DETERMINES (DAeroportArr.NumAerA , DAeroportArr.NomAerA )
ATTRIBUTE LVille DETERMINES (DAeroportArr.CodeVille , DAeroportArr.NomVille )
ATTRIBUTE LPays DETERMINES (DAeroportArr.CodePays , DAeroportArr.NomPays )
ATTRIBUTE LTypAerA DETERMINES (DAeroportArr.CodeTypAerA , DAeroportArr.TypeAerA );

CREATE DIMENSION DimAeroportDep 
LEVEL LAeroportDep IS (DAeroportDep.NumAerA)
LEVEL LVille IS (DAeroportDep.CodeVille)
LEVEL LPays IS (DAeroportDep.CodePays)
LEVEL LTypAerD IS (DAeroportDep.CodeTypAerA)
HIERARCHY H_COMP_TCOMP ( LAeroportDep CHILD OF LVille CHILD OF LPays)
HIERARCHY H_COMP_TCOMP ( LAeroportDep CHILD OF LTypAerA)
ATTRIBUTE LAeroportDep DETERMINES (DAeroportDep.NumAerDep , DAeroportDep.NomAerD )
ATTRIBUTE LVille DETERMINES (DAeroportDep.CodeVille , DAeroportDep.NomVille )
ATTRIBUTE LPays DETERMINES (DAeroportDep.CodePays , DAeroportDep.NomPays )
ATTRIBUTE LTypAerD DETERMINES (DAeroportDep.CodeTypAerA , DAeroportDep.TypeAerA );

Alter session set query_rewrite_integrity=trusted

CREATE MATERIALIZED VIEW VMNBVolVille 
BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND
ENABLE QUERY REWRITE AS
select ar.CodeVille, ar.NomVille, sum(v.NbVol) as MV
from DAeroportDep ar , FTraffic v
where ar.NumAerD = v.NumAerD
group by  (ar.CodeVille, ar.NomVille);

select ar.CodeVille, ar.NomVille, sum(v.NbVol) as MV
from DAeroportDep ar , FTraffic v
where ar.NumAerD = v.NumAerD
group by  (ar.CodeVille, ar.NomVille);

drop dimension DimAeroportDep;