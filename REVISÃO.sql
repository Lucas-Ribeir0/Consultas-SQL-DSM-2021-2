create database Revisao
go
use Revisao

drop database Revisao

create table Cliente(
	CPF int constraint PK_Cliente primary key,
	nome varchar(50),
	RG int,
	DtNasc date
)

drop table Cliente

create table Quarto(
	Nro int constraint PK_Quarto primary key,
	Andar int constraint AndarQrto check(Andar > 0),
	Metragem int constraint MetroQrto default(25)
)

create table Reserva(
	CodReserva int constraint PK_Reserva primary key identity(1,1),
	DtEntrada datetime,
	DtSaida datetime,
	CPF int constraint FK_Cliente foreign key references Cliente(CPF),
	Nro int constraint FK_Quarto foreign key references Quarto(Nro),
	Constraint dtReserva check(DtEntrada < DtSaida)
)

create table Refeicao(
	CodRef int constraint PK_Refeicao primary key identity(100,1) check(CodRef < 999),
	Valor money constraint Valor_Ref NOT NULL check(Valor > 0),
	Descricao varchar(500),
	codReserva int constraint FK_Reserva foreign key references Reserva(CodReserva)
)

create table Pagamentos(
	CodPag int constraint PK_Pagamentos primary key identity(1,1),
	Valor money constraint ValorPag NOT NULL, 
	DtVenc date,
	CodReserva int constraint FK_Reserva_Pag foreign key references Reserva(CodReserva)
)

create table Opcionais(
	CodOpc int constraint PK_Opcionais primary key check(CodOpc between 1000 and 2999),
	Descricao varchar(2000)
)

create table OpcQrto(
	CodOpcQrto int constraint PK_OpcionaisQuarto primary key identity(1,1),
	Nro int constraint FK_Quarto_Opcionais foreign key references Quarto(Nro),
	CodOpc int constraint FK_Opcionais foreign key references Opcionais(CodOpc)
)

set dateformat dmy

insert into Cliente
	values(111, 'LUCAS', 111, '16/09/2003'),
			(222, 'ROGERIO', 222, '14/02/1998'),
			(333, 'PEDRO', 333, '19/08/2001'),
			(444, 'HIGOR', 444, '05/01/1980'),
			(555, 'HELENA', 555, '09/12/1995'),
			(666, 'JULIA', 666, '11/11/1998'),
			(777, 'FRANCISCA', 777, '06/05/2000')

insert into Quarto
	values(215, 2, 32),
			(214, 2, 32),
			(212, 2, 32),
			(200, 2, 40),
			(314, 3, 32)

insert into Quarto(Nro, Andar)
	values(218, 2),
			(311, 3)
			
select * from Quarto

insert into Reserva(DtEntrada, DtSaida, CPF, Nro)
	values('16/09/2015', '21/09/2015', 111, 214),
			('19/09/2015', '21/09/2015', 222, 218),
			('25/02/2015', '09/03/2015', 333, 311),
			('31/12/2014', '05/01/2015', 444, 314),
			('05/05/2015', '15/05/2015', 555, 200),
			('09/08/2015', '25/08/2015', 666, 212),
			('09/10/2015', '22/10/2015', 666, 212)

select * from Reserva

insert into Refeicao(Valor, Descricao, codReserva)
	values('12.95', 'Bolinhos de Chuva', '3'),
			('16.00', 'Bife', '3'),
			('6.00', 'Suco de Laranja', '3'),
			('19.00', 'Lasanha', '4'),
			('4.50', 'Coca-Cola 350ml', '4'),
			('47.00', 'Combo Família', '5'),
			('27.00', 'Especial Casal', '6'),
			('12.00', 'Promoção de Solteiro', '7'),
			('3.00', 'Água 500ml', '8')

select * from Refeicao

insert into Pagamentos(Valor, DtVenc, CodReserva)
	values('870.23', '21/12/2015', '3'), ('649.87', '21/12/2015', '4'),
			('1107.00', '09/06/2015', '5'), ('1764.25', '05/04/2015', '6'),
			('422.26', '15/08/2015', '7'), ('641.11', '25/11/2015', '8')

select * from Pagamentos

insert into Opcionais
	values(1001, 'Toalhas Anti-Alérgicas'),
			(2301, 'Sabonete sem cheiro'),
			(2111, 'Sabonete Natural'),
			(1921, 'Toalhas de Seda'),
			(1111, 'Fronhas Anti-Alérgias'),
			(1512, 'Sem Toalhas'),
			(1999, 'Sem Fronhas'),
			(1612, 'Frigobar Adicional')

insert into OpcQrto(Nro, CodOpc)
	values(200, 1612), (200, 2111), (214, 1111), (218, 2301), (314, 1001), (311, 1999), (311, 2111), (212, 2111)


--2
create view vReservasEmOutubro_Setembro
as
select C.nome as Cliente, R.Nro as numeroQuarto, R.dtEntrada as dataEntrada, R.dtSaida as dataSaida, P.Valor as Valor, P.DtVenc as dataVencimento
	from Cliente C inner join Reserva R on C.CPF = R.CPF
					inner join Pagamentos P on R.CodReserva = P.CodReserva
				where month(R.DtEntrada) = 9 and month(R.DtSaida) = 9

select * from vReservasEmOutubro_Setembro order by numeroQuarto asc

--3

create view "vOpcionais_2ºA"
as
select distinct Q.Nro as Quarto, O.Descricao as "Lista Opcionais"
		from Opcionais O inner join OpcQrto OQ on O.CodOpc = OQ.CodOpc
							inner join Reserva R on R.Nro = OQ.Nro
							left join Quarto Q on R.Nro = Q.Nro
					where Q.Andar = 2

select * from vOpcionais_2ºA

--4
create view vRefeicaoFrigobar
as
select Re.Nro as Quarto, R.Descricao as Refeicao, O.Descricao as Opcional
	from OpcQrto OQ inner join Opcionais O on OQ.CodOpc = O.CodOpc
					inner join Reserva Re on Re.Nro = OQ.Nro
					inner join Refeicao R on R.codReserva = Re.CodReserva
			where O.Descricao = 'Frigobar Adicional'

select * from vRefeicaoFrigobar 

--5
select CodReserva as "Código Reserva", (datediff(day, DtEntrada, DtSaida)) as "Dias de Estádia" from Reserva

--6
select C.Nome as Cliente, Q.Nro as Quartos, O.Descricao as Opcionais
	from OpcQrto OQ inner join Opcionais O on OQ.CodOpc = O.CodOpc
				inner join Quarto Q on OQ.Nro = Q.Nro
				inner join Reserva R on Q.Nro = R.Nro
				inner join Cliente C on R.CPF = C.CPF
			where C.nome = 'LUCAS'

--7
