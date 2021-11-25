-- ######################################			1			##################################################
create database StoredProcedures2
go
use StoredProcedures2

create table Cliente (
	CodCli int constraint PK_Cli primary key identity(1,1),
	Nome varchar(200) constraint Nome_Cli NOT NULL,
	Classificacao char(1) constraint Class_Cli NOT NULL,
	LimiteCredito money constraint MaxCred_Cli NOT NULL,
	Cidade varchar(100),
	UF char(2)
)

create table Pedido (
	CodPed int constraint PK_Ped primary key identity(1,1),
	Data datetime constraint DataPed_Def default(getdate()),
	VlTotal money constraint VlTotalPed_CHK check(VlTotal > 0),
	VlDesconto money constraint VlDescPed_Def default(0),
	CodCli int constraint FK_Cli foreign key references Cliente(CodCli)	
)

create table Financeiro (
	CodFin int constraint PK_Fin primary key identity(1,1),
	DtVencto date constraint DtVenc_Fin default(DATEADD(DAY, +30, getdate())), -- Deixa default como 30 dias/1 mês a partir da data de pagamento
	NumParcela int constraint NmParc_Fin NOT NULL check(NumParcela > 0),
	Valor money,
	CodPed int constraint FK_Ped foreign key references Pedido(CodPed)
)

create table Item (
	CodItem int constraint PK_Itm primary key identity(1,1),
	Qtde int constraint Qtd_Itm NOT NULL,
	VlUnit money constraint VlUnit_Itm check(VlUnit > 0) NOT NULL,
	CodPed int constraint FK_Ped_Itm foreign key references Pedido(CodPed)
)

create table Produto(
	CodPro int constraint PK_Pro primary key identity(1,1),
	Descricao varchar(600) constraint Desc_Pro NOT NULL,
)

alter table Item
	add CodProd int constraint FK_Pro foreign key references Produto(CodPro)


insert into Cliente(Nome, Classificacao, LimiteCredito, Cidade, UF) values
	('Jorge Santos', 'A', 300, 'Franca', 'SP'),
	('Paulo José', 'B', 1500, 'Uberaba', 'SP'),
	('Lucas Silva', 'C', 900, 'Ribeirão Preto', 'SP'),
	('Johnny Reis', 'D', 6500, 'São Paulo', 'SP'),
	('Maycon Torres', 'E', 2200, 'Brasília', 'DF'),
	('Mike Neves', 'F', 1000, 'Fortaleza', 'CE'),
	('João Paulo', 'A', 12000, 'Ibiraci', 'MG'),
	('Maria Joana', 'B', 8000, 'Passa Tempo', 'MG'),
	('Julia', 'C', 15000, 'Ampére', 'PR'),
	('Roberta Imaculada', 'D', 1000, 'Flor do Sertão', 'SC')

select * from Cliente

set dateformat dmy


insert into Produto(Descricao) values
	('Coca-Cola'), ('Fanta'), ('Cookies'), ('Bolacha'),
	('Ruffles'), ('Cheetos'), ('Brownies'), ('Waffer'),
	('Queijo'), ('Danone'), ('Leite')

select * from Pedido

insert into Pedido(VlTotal, CodCli) values
	(200.50, 1), (80, 1),
	(600, 2), (180, 2),
	(300, 3), (300, 3),
	(125, 4), (20, 4),
	(150, 5), (180, 5),
	(190, 6), (450, 6),
	(300, 7), (600, 7),
	(900, 8), (25, 8)

update Pedido set Data = GETDATE() where CodPed = 10

select * from Item

insert into Item(Qtde, VlUnit, CodPed, CodProd) values
	(100, 2.50, 1, 1), (4, 20, 2, 2),
	(20, 30, 3, 3), (6, 40, 4, 4),
	(30, 10, 5, 5), (3, 100, 6, 6),
	(25, 5, 7, 7), (5, 4, 8, 8),
	(50, 3, 9, 9), (30, 6, 10, 10),
	(19, 10, 11, 11), (90, 5, 12, 1),
	(300, 1, 13, 2), (300, 2, 14, 3),
	(150, 6, 15, 4), (5, 5, 16, 5)

insert into Item(Qtde, VlUnit, CodPed, CodProd) values
	(100, 1.50, 1, 3), (200, 2.20, 1, 5),
	(300, 4, 2, 7), (20, 40, 2, 1),
	(10, 10, 3, 4), (150, 0.50, 3, 11)


-- ######################################			2			##################################################
create procedure spDescontoUltimoPed
	@CodCli int,
	@Percent money
as
begin
	declare @UltimoPedido int
	set @UltimoPedido = (select max(codPed) from Pedido where CodCli = @CodCli) -- Porque isso funciona? Não sei, deve ser o modo mais incorreto possível e preciso de esclarecimentos.
	update Pedido set VlDesconto = (VlTotal * (@Percent / 100)) where codPed = @UltimoPedido
end

select * from Pedido

drop procedure spDescontoUltimoPed

exec spDescontoUltimoPed 8, 50


-- ######################################			3			##################################################

create procedure spDUPLimitado
	@CodCli int,
	@Percent money 
as
begin
	declare @UltimoPedido int
	set @UltimoPedido = (select max(codPed) from Pedido where CodCli = @CodCli)

	declare @ValorTotal money
	set @ValorTotal = (select VlTotal from Pedido where CodPed = @UltimoPedido)

	declare @LimiteCredito money
	set @LimiteCredito = (select LimiteCredito from Cliente where CodCli = @CodCli)

	if @LimiteCredito * 0.10 > @ValorTotal
		update Pedido set VlDesconto = (VlTotal * (@Percent / 100)) where codPed = @UltimoPedido
end

drop procedure spDUPLimitado

exec spDUPLimitado 1, 100

select * from Cliente
select * from Pedido
-- ######################################			4			##################################################
create procedure spSetVlrTotal
	@CodPed int
as
begin
	declare @valorItens money
	set @valorItens = (select (sum(VlUnit * Qtde)) from Item where CodPed = @CodPed)

	update Pedido set VlTotal = @valorItens where CodPed = @CodPed
end

drop procedure spSetVlrTotal

exec spSetVlrTotal 1

select * from Pedido
	
select * from Item order by CodPed

-- ######################################			5			##################################################
create procedure MaisLimiteCred
	@AumentoCred money
as
begin
	update Cliente set LimiteCredito += @AumentoCred where Classificacao = 'A' or Classificacao = 'D' or Classificacao = 'F'
end

select * from Cliente order by Classificacao

exec MaisLimiteCred 10


-- ######################################			FIM			##################################################
drop database StoredProcedures2
