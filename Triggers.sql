create database TriggersExemplos
go
use TriggersExemplos

create table carro(
	idCarro int constraint pkCarro primary key identity(1,1),
	Modelo varchar(30),
	Ano int
	)
-------------------------------------------------
CREATE TRIGGER trgAlerta
	ON carro 
	FOR INSERT 
AS      
	PRINT 'Um registro foi inserido'

-- COMANDOS QUE FARÃO A TRIGGER EXECUTAR
insert into carro values ('GOL', 1985)
insert into carro values ('CORSA', 2002)
insert into carro values ('FIESTA', 2010)
-- COMANDOS QUE NÃO ACIONARÃO ESTA TRIGGER
update carro set modelo = 'BRASILIA' where idCarro = 1
select * from carro where idCarro = 3
delete carro where idCarro = 2


create table Cliente (
	codCli int primary key identity(1,1),
	nome varchar(50),
	saldo money
)

create table Movimentacao(
	codMov int primary key identity(1,1),
	codCli int foreign key references cliente(codCli),
	dt_mov datetime,
	vl_total money,
	vl_imposto money
)

insert into Cliente
	values('Joao', 0),
			('Jose', 0),
			('Ana', 0)


create trigger trgIns
	on Movimentacao
	For insert
as
	declare	@id int
	declare @valor money

	select @id = codCli, @valor = vl_total - vl_imposto from inserted

	update Cliente
	set saldo = saldo + @valor
	where codCli = @id

insert into Movimentacao
values (1, '15/10/2015', 100.00, 15.00)
select * from Cliente

insert into Movimentacao
values (2, '07/02/2015', 455.90, 23.49)

insert into Movimentacao
values (1, '18/03/2015', 118.00, 9.50)

create trigger trgDe1
	On Movimentacao
	for delete
as
	declare @ClienteMov int, @totalmov money
	select @ClienteMov = CodCli, @totalmov = vl_total - vl_imposto from deleted

	update Cliente set saldo = saldo - @totalmov
	where codCli = @ClienteMov

delete movimentacao where codMov = 5
select * from Movimentacao
select * from Cliente


create trigger trgAtualizaSaldo
	ON movimentacao
	for update
as 
	update cliente
	set saldo = saldo
	- (select vl_total - vl_imposto from deleted) + (select vl_total - vl_imposto from inserted)
	where codCli = (select codCli from deleted)

select * from Movimentacao
select * from Cliente

update Movimentacao set vl_imposto = 3 where codMov = 6


create table produto(
	codPro int primary key identity(1,1),
	descricao varchar(70),
	qtdEstoque int
)

create table itensMovimentacao (
	codItem int primary key identity(1,1),
	codMov int foreign key references Movimentacao(CodMov),
	codPro int foreign key references produto(codPro),
	qtde int,
	vlUnit money,
	tpMov varchar(1)
)

insert into produto
	values('Toddy', 0),
			('Nescau', 0),
			('Ovo Maltine', 0),
			('Ovo', 0)

select * from produto
select * from itensMovimentacao
select * from Movimentacao


insert into itensMovimentacao(codPro, qtde, vlUnit, tpMov)
	values(1, 10, 10, 'E')

insert into itensMovimentacao(codPro, qtde, vlUnit, tpMov)
	values(1, 2, 10, 'S')

insert into itensMovimentacao(codMov, codPro, qtde, vlUnit, tpMov)
	values(6, 1, 5, 10, 'E')


create trigger trgMovsItens
on itensMovimentacao
for insert 
as
	declare @tp varchar(1)
	declare @qtd int
	declare @codPro int

	set @tp = (select tpMov from inserted)
	set @qtd = (select qtde from inserted)
	set @codPro = (select codPro from inserted)
		
		if @tp = 'E' update produto set qtdEstoque = qtdEstoque + @qtd where codPro = @codPro
		else
			if @tp = 'S' update produto set qtdEstoque = qtdEstoque - @qtd where codPro = @codPro
	


create table Pessoa (
	codPes int primary key identity(1,1),
	nome varchar(20),
	cpf int,
)

create table Dep (
	codDep int primary key identity(1,1),
	depNome varchar(20),
	CodChefe int foreign key references Pessoa(codPes)
)

insert into Pessoa
	values('Junin', 1111), ('Pedroca', 2222), ('Jonas', 3333), ('Fabricio', 4444)

insert into Dep
	values('Faturamento', 1), ('RH', 3)

select * from Pessoa P inner join Dep D on P.codPes = D.CodChefe
select * from Dep
select * from Pessoa

create trigger trgExcludeChefe
on Pessoa
instead of delete
as
	declare @codPes int
	declare @codD int

	set @codPes = (select codPes from deleted)
	set @codD = (select CodChefe from Dep where @codPes = CodChefe)
	
	if  @codD = @codPes
		update Dep set CodChefe = NULL where codChefe = @codPes 
		delete from Pessoa where codPes = @CodPes

drop trigger trgExcludeChefe

delete from Pessoa where codPes = 2

update Dep set CodChefe = 1 where codDep = 1


create table Produtos(
	idPro int primary key identity(1,1),
	descricao varchar(100),
	valor money,
	qtdeEstoque int,
	statusPro char(1),
	proFalta varchar(3),
)






	


