Create User Master  Identified by psw;

GRANT ALL privileges to Master ;

Connect Master/psw;

CREATE TABLE TypeAeroport
(
	CodeTypeAer Number(1) primary key,
	TypeAer varchar2(30)	
);

CREATE TABLE Pays
(
	CodePays Number(3) primary key,
	NomPays varchar2(30)	
);

CREATE TABLE TypeCompagnie
(
	CodeTypeComp Number(1) primary key,
	TypeComp varchar2(30)	
);

CREATE TABLE Pilote
(
	CodeP Number(5) primary key,
	NomP varchar2(30)	
);

CREATE TABLE Constructeur
(
	CodeCons Number(1) primary key,
	NomCons varchar2(30)	
);

CREATE TABLE Ville
(
	CodeVille Number(5) primary key,
    CodePays Number(3),
	NomVille varchar2(30),	
    constraint fk_vil_pay Foreign key (CodePays) references Pays(CodePays)
);

CREATE TABLE Modele
(
	CodeMod Number(3) primary key,
    CodeCons Number(1),
	LibMod varchar2(30),	
    constraint fk_mod_cstr Foreign key (CodeCons) references Constructeur(CodeCons)
);

CREATE TABLE Avion
(
	NumAv Number(4) primary key,
    CodeMod Number(3),
    constraint fk_avn_mod Foreign key (CodeMod) references Modele(CodeMod)
);

CREATE TABLE Compagnie
(
	CodeComp Number(3) primary key,
    CodePays Number(3),
    CodeTypeComp Number(1),
	NomCom varchar2(30),	
    constraint fk_cmp_pay Foreign key (CodePays) references Pays(CodePays),
    constraint fk_cmp_tpcmp Foreign key (CodeTypeComp) references TypeCompagnie(CodeTypeComp)
);

CREATE TABLE Aeroport
(
	NumAer Number(5) primary key,
    CodeVille Number(5),
    CodeTypeAer Number(1),
	NomAer varchar2(30),	
    constraint fk_aer_vil Foreign key (CodeVille) references Ville(CodeVille),
    constraint fk_aer_tpaer Foreign key (CodeTypeAer) references TypeAeroport(CodeTypeAer)
);

CREATE TABLE Vol
(
	NumVol Number(7) primary key,
	TypeVol NUMBER(1),
    Retard NUMBER(1),
    DateVol Date,    
    Duree_theorique int,
    CodeComp Number(3),
    NumAerDep Number(5),
    NumAerArr Number(5),
    CodeP Number(5),
    NumAv Number(4),
    constraint fk_vol_cmp Foreign key (CodeComp) references Compagnie(CodeComp),
    constraint fk_vol_aerdep Foreign key (NumAerDep) references Aeroport(NumAer),
    constraint fk_vol_aerarr Foreign key (NumAerArr) references Aeroport(NumAer),
    constraint fk_vol_plt Foreign key (CodeP) references Pilote(CodeP),
    constraint fk_vol_avn Foreign key (NumAv) references Avion(NumAv)
);
