create database TestandoConstraints
use TestandoConstraints
drop database TestandoConstraints

create table Funcionários(
	CodFun int primary key identity(1,1),
	nomeF varchar(80)  constraint nome_FUN NOT NULL,
	CPF varchar(20) NOT NULL constraint CPF_FUN UNIQUE,
	RG varchar(20) NOT NULL constraint RG_FUN UNIQUE,
	sexo char(1) NOT NULL constraint SEXO_FUN check(sexo in('M','F')),
	categoria varchar(20) NOT NULL constraint CATEG_FUN check(categoria in('Auxiliar', 'Supervisor', 'Terceirizado', 'Contratado', 'Coordendor')),
	idade int NOT NULL constraint IDADE_FUN check(idade between 16 and 65),
	CodDep int
)

create table Departamentos(
	CodDep int primary key identity(1,1),
	nomeDep varchar(80)constraint nome_DEP NOT NULL,
	descDep varchar(300) constraint Desc_DEP NOT NULL,
	codGer int constraint FK_Ger references Funcionários(CodFun)
)

create table Projetos(
	codProj int constraint PK_Proj primary key identity(100,1),
	nomeProj varchar(80) constraint nome_PROJ NOT NULL,
	descProj varchar(500) constraint desc_PROJ NOT NULL
)

create table ParticipacaoFuncionarios(
	codFunc int constraint codFuncProj foreign key references Funcionários(CodFun) NOT NULL,
	codProj int constraint codProjFunc foreign key references Projetos(codProj) NOT NULL,
	dataIni date,
	dataFim date
)

alter table ParticipacaoFuncionarios
add
 constraint TempoPROJ check
 (
	(dataIni < dataFim)
	and
	(dataFim > dataIni)
 )

alter table Funcionários
add
CodDep int constraint FK_Dep foreign key references Departamentos(CodDep)
  
alter table funcionários drop column CodDep

alter table ParticipacaoFuncionarios
add
constraint PK_ProjFunc_Participacao primary key(codFunc, codProj)


select * from ParticipacaoFuncionarios

alter table ParticipacaoFuncionarios drop column codFunc, codProj

insert into Departamentos(nomeDep, descDep)
values('CONTAS A PAGAR', 'Departamento de contas a pagar'),
		('CONTAS A RECEBER', 'Departamento de recebimento de contas'),
		('FATURAMENTO', 'Departamento de Faturamento'),
		('VENDAS', 'Departamento de vendas'),
		('Compras', 'Departamento de compras')

insert into Projetos(nomeProj, descProj)
values('Melhoria 1', 'Melhorar a situação pela 1° vez'),
		('Melhoria 2', 'Melhorar a situação pela 2° vez'),
	   ('Melhoria 3', 'Melhorar a situação pela 3° vez'),
	   ('Melhoria 4', 'Melhorar a situação pela 4° vez'),
	   ('Melhoria 5', 'Melhorar a situação pela 5° vez')

insert into Funcionários(nomeF, CPF, RG, sexo, categoria, idade, CodDep)
values('Junin', '111111', '111111', 'M', 'Auxiliar','44', '1'),
		('Julio', '222222', '222222', 'M', 'Coordendor', '32', '2'),
		('Paula', '333333', '333333', 'F', 'Coordendor', '37', '3'),
		('Jéssica', '444444', '444444', 'F', 'Supervisor', '28', '4'),
		('Bruno', '555555','555555', 'M', 'Supervisor', '29', '5'),
		('Henrique', '666666', '666666', 'M', 'Contratado', '32', '2'),
		('Kyle', '777777', '777777', 'M', 'Coordendor', '48', '1'),
		('Geraldo', '888888', '888888', 'M', 'Contratado', '53', '3'),
		('Tiago', '999999', '999999', 'M', 'Contratado', '22', '4'),
		('Geralda', '101010', '101010', 'F', 'Terceirizado', '18', '5')

select * from Funcionários

alter table projeto
	add constraint DF_Desc default('XXXX') for DescProj

insert into ParticipacaoFuncionarios(dataIni, dataFim, codFunc, codProj)
values('2016/08/08', '2016/12/01', '1', '100'), ('2017/02/12', '2017/12/11', '2', '102'), ('2018/02/05', '2019/01/01', '3', '103')

drop table Departamentos
alter table departamentos
add
codGer int constraint codGerente_Dep foreign key references Funcionários(CodFun)

select * from Departamentos

values('2'), ('4'), ('7')

alter table Funcionários
add
CidadeFun varchar(80) constraint CK_CityFUN default('Franca')

select * from Funcionários
insert into Funcionários(nomeF, CPF, RG, sexo, categoria, idade, CodDep)
values('Pedro', '202020', '202020', 'M', 'Terceirizado', '54', '1')

select * from Departamentos
select * from ParticipacaoFuncionarios
select * from Funcionários

insert into Projetos(nomeProj, descProj)
values ('Melhoria  6', 'Melhorar a situação pela 6° vez')

insert into ParticipacaoFuncionarios(dataIni, dataFim, codFunc, codProj)
values ('2016-07-08', '2016-12-09', '1', '101'),
		('2016-09-21', '2016-12-09', '2', '102'),
		('2016-06-15', '2016-12-09', '3', '103'),
		('2016-11-09', '2016-12-09', '4', '104'),
		('2016-12-01', '2016-12-09', '5', '105')

select * from Funcionários

drop table Funcionários

select * from ParticipacaoFuncionarios