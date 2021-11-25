create database Views_2
go
use Views_2

drop database Views_2

create table Carro(
	codCar int constraint PK_Car primary key identity(1,1),
	modelo varchar(100) constraint modeloCar not null,
	placa varchar(10),
	cor varchar(30),
	ano int constraint Ano_Car check(ano > 0)
)

drop table Seguro

create table Seguro(
	codSeg int constraint PK_Seg primary key identity(1,1),
	NroApolice int constraint ApoliceSeg check(NroApolice > 1000) not null,
	DtValidade date,
	codCar int constraint FK_Car foreign key references Carro(codCar)
)

create table Roubo(
	CodRob int constraint PK_roubo primary key identity(1,1),
	dtRoubo datetime constraint def_dtRob default(getdate()),
	LocalRou varchar(50),
	Cidade varchar(40),
	CodCar int constraint FK_RobCar foreign key references Carro(codCar)
)

create table Recuperacao(
	codRec int constraint PK_Rec primary key identity(1,1),
	DtRec date constraint dt_rec default(getdate()),
	Responsavel varchar(50),
	Obs varchar(2000),
	CodRob int constraint FK_RecRob foreign key references Roubo(codRob)
)


select * from Carro

insert into Carro
	values('Celta', '1111111', 'Amarelo', '2009'),
			('Golf', '2222222', 'Preto', '2005'),
			('Jetta', '4444444', 'Cinza', '2002'),
			('Parati', '3333333', 'Branca', '2009'),
			('Gol', '5555555', 'Verde', '2000'),
			('Escort', '6666666', 'Vermelho', '2004'),
			('Bettle', '7777777', 'Amarelo-Escuro', '2012'),
			('EcoSport', '8888888', 'Grafite', '2015')

select * from Seguro

insert into Seguro(NroApolice, codCar)
	values('1001', '3'), ('1004', '6'), ('1005', '7'), ('1020', '1')


select * from Roubo

insert into Roubo(LocalRou, Cidade, codCar)
	values('R. Joaozin', 'Franca', '3'),
			('R. Pedroca', 'Rio de Janeiro', '2'),
			('Av. Mão de Vaca', 'Ribeirão Preto', '7'),
			('Av. Pedrin', 'Franca', '4'),
			('R. Kabrito Alves', 'Franca', '8')

select * from Recuperacao

insert into Recuperacao(Responsavel, Obs, CodRob)
	values--('Juca', 'Carro encontrado com parachoque dianteiro danificado', 1),
		('Roberto', 'Carro encontrado com faróis danificados', 9)
		--	('Mario', 'Carro encontrado sem o radiador'),
			--('Paulin', 'Carro encontrado na Av. Paulo Sexto, possivel Perda Total'),
			--('Paulin', 'Carro encontrado na Av. Paulo Sexto, possivel Perda Total')

create view ModelCheck
as
select C.modelo, C.Cor, C.Placa, S.NroApolice, S.DtValidade from 
	Carro C inner join Seguro S on C.codCar = S.codCar
		where C.ano between 2000 and 2010

select * from ModelCheck


-- 4.
create view vNoSegRob
as
select C.modelo, S.NroApolice from
	Carro C left join Seguro S on C.codCar = S.codCar
			inner join Roubo R on R.codCar = C.codCar
		where S.codCar is null

select * from vNoSegRob



-- 5.
create view ModCityObs
as
select C.modelo, R.Cidade, Re.Obs from
	Carro C inner join Roubo R on C.codCar = R.CodCar
			inner join Recuperacao Re on Re.CodRob = R.CodRob
		where R.Cidade = 'Franca'

select * from ModCityObs

--6. 

create view NoRobInfoSeg
as
select C.modelo, S.NroApolice, R.CodRob from
	Carro C left join Seguro S on C.codCar = S.codCar
			left join Roubo R on R.CodCar = S.codCar
		where CodRob is null

select * from NoRobInfoSeg


/*select R.Cidade, C.ano count(*) as Roubos from
	Roubo R inner join Carro C on C.codCar = R.CodCar
group by R.Cidade*/

select Cidade,year(DtOcorrencia) as Ano,count(*) as Roubos 
	from Roubo group by Cidade, year(DtOcorrencia)



