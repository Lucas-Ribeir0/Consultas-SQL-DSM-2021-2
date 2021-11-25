create database Prova_1_1
go
use Prova_1_1

-- 1. A, C e E - NÃO

create table Mesa(
	codMesa int constraint PK_Mesa primary key,
	Setor varchar(50),
	Capacidade int,
	Situacao varchar(80)
)

create table Pagamento(
	codPagamento int constraint PK_Pagamento primary key,
	vlPago money
)

alter table Mesa add constraint CHK_setor
	check(setor in('Palco', 'Piso Superior', 'Balcão', 'Lounge'))

alter table Mesa add constraint CHK_setor
	check(setor in('Palco', 'Piso Superior' OR 'Balcão' OR 'Lounge'))

alter table Pagamento
add constraint CHK_valorPgto check(vlPago > 0)

alter table Pagamento add constraint check2 check(vlPago >= 0)


insert into Mesa(codMesa, Setor)
	values(1, 'Palco')

insert into Pagamento(codPagamento, vlPago)
	values(1, '1,')

alter table Pagamento
add constraint valid check(setor IN('Palco', 'Piso Superior', 'Balcão', 'Lounge') check(vlPago >0)


-- 2. A,  B, C

create table Garcom(
	codGarcom int constraint PK_Garcom primary key,
	Nome varchar(200),
	CalcularComissao char(1)
)

--alter table Garcom
--add constraint _cmss check(calcularComissao in('S','N')) default('N')


--alter table Garcom add constraint _cmss
--check(calcularComissao in ('S','N'), _cmsd default('N') for CalcularComissao, add constraint _ nome unique(nome)

alter table Garcom add constraint _nome unique(nome)

alter table Garcom add 
constraint _cmss check(CalcularComissao in ('S', 'N')), constraint _cmsd default('N') for calcularComissao

INSERT INTO Garcom(codGarcom, Nome, CalcularComissao) values(1, 'Julio', 'S'), (2, 'Julia', 'S')
INSERT INTO Garcom(codGarcom, Nome) values(5, 'Jeca'), (6, 'Juca')

select * from Garcom

alter table Garcom add constraint _nome_ unique(nome)

--3 A, C, D, E
--alter table mesa add
	--constraint _nro check(nroMesa >= 1000 and <= 1050)

alter table Mesa add
constraint _nro_ check(codMesa between 1000 and 1050), constraint _setor check((setor = 'Lounge' and capacidade = 4) or (setor <> 'Lounge'))

insert into Mesa(codMesa, Capacidade, Situacao, Setor)
	values(1002, 4, 'Vazia', 'Balcão'), (1000, 40, 'Vazia', 'Balcão')


alter table Mesa add constraint _setor_ check(setor = 'Lounge' and check(capacidade = 4) or (setor <> 'Lounge'))


alter table Mesa add constraint _setor__ check ((setor <> 'Lounge') AND (setor = 'Lounge' and capacidade = 4))

drop table Mesa


create table Mesa(
	NroMesa int constraint PK_Mesa primary key,
	Setor varchar(200),
	capacidade int,
	situacao varchar(100)
)

insert into Mesa values(1, 'Lounge', '4', 'Vazia'), (2, 'Balcão', '6', 'Cheia'), (3, 'Rua', '8', 'Meia')
 
create table Garcom(
	codGarcom int constraint PK_Garcom primary key,
	Nome varchar(200),
	CalcularComissao char(1)
)

insert into Garcom values(1, 'Juca', 'S'), ('2', 'Peddro', 'N')

create table Categoria(
	CodCategoria int constraint PK_Categoria primary key,
	Nome varchar(100),
	Ativo varchar(3)
)

create table Produto(
	codPro int constraint PK_Produto primary key,
	descricao varchar(200),
	preco money,
	codCategoria int constraint FK_Categoria foreign key references Categoria(CodCategoria)
)

create table Atendimento(
	CodAtendimento int constraint PK_Atendimento primary key,
	Situacao varchaR(200),
	DtHrChegada datetime,
	NroPessoas int,
	NroMesa int constraint FK_Mesa foreign key references Mesa(NroMesa),
	CodGarcom int constraint FK_Garcom foreign key references Garcom(CodGarcom)
)
set dateformat dmy

insert into Atendimento
	values(5, 'Em Atendimento', getdate(), 2, 1, 1), (2, 'Finalizada', '16/03/2016', 4, 2, 2), (3, 'Em Atendimento', '16/03/2016', 5, 1, 2),
			(4, 'Finalizada', getdate(), 3, 3, 2)


create table Pagamento(
	CodPagamento int constraint PK_Pagamento primary key,
	VlPago money,
	codAtendimento int constraint FK_Atendimento_Pagt foreign key references Atendimento(CodAtendimento)
)
select * from Pagamento

alter table Pagamento

insert into Pagamento
	values(1, '100', '1'), (2, '200', 2), (3, '300', 3), (4, '400', 4)

create table Consumo(
	CodConsumo int constraint PK_Consumo primary key,
	Qtde int,
	VlUnit money,
	CodAtendimento int constraint FK_Consu_Atend foreign key references Atendimento(CodAtendimento),
	CodPro int constraint FK_Consu_Pro foreign key references Produto(CodPro)
)


select * from Pagamento

select * from Atendimento


--4. C, D
select pgto.*, atend.codAtendimento, situacao, dtHrChegada, nroPessoas, nroMesa, CodGarcom
	from Pagamento pgto	inner join Atendimento atend on atend.CodAtendimento = pgto.codAtendimento
	where atend.Situacao = 'Finalizada' and day(atend.DtHrChegada) = day(getdate()) and month(atend.dtHrChegada) = month(getdate())

select codPagamento, VlPago, a.codAtendimento, situacao, dtHrChegada, nroPessoas, nroMesa, codGarcom
	from Pagamento a inner join Atendimento b on a.codAtendimento = b.CodAtendimento
		where '04/10/2021 20:11:55.133' = DtHrChegada


select atend.codAtendimento, situacao, dtHrChegada, nroPessoas, nroMesa, CodGarcom
from Pagamento pgto inner join Atendimento atend on atend.CodAtendimento = pgto.codAtendimento
where atend.Situacao = 'Finalizada' and atend.DtHrChegada >= '04/10/2021 20:11:55.133' and atend.Situacao <= '04/10/2021 20:11:55.133' -1

select 

--6	 B, C, D



--7 B, C, E, 

insert into Categoria
	values(2, 'Bebidas', 'S'), (3, 'Complementos', 'S'), (4, 'Doces', 'S')

select * from Categoria

select * from Produto

insert into Produto
	values(2, 'Suco', '10', '2'), (3, 'Sal', '2', '3'), (4, 'Cereja', '10', '4'), (5, 'Suquin', '10', '2'), (6, 'Pimenta', '1', '3'),
			(7, 'Bala', '10', '4')

select * from Consumo

insert into Consumo
	values(1, '5', '1', '1', '2'), (2, '6', '1', '1', '3')


-- Digite o comando SQL completo para criar uma view neste BD que liste os nomes das categorias, as descrições dos produtos e seus preços.


create view "vCategorias Produtos e Precos"
as
select C.Nome as Categoria, P.Descricao as Produto, P.preco as PrecoProduto
	from Categoria C inner join Produto P on C.CodCategoria = P.codCategoria

select * from [vCategorias Produtos e Precos]


-- B, D, A,  E
select a.situacao as situacao, b.nome as NomeGarcom, a.nroMesa as Mesa, a.nroPessoas as NroPessoas, ((a.nropessoas*100)/ c.capacidade)
from Atendimento A inner join Garcom B inner join Mesa C on B.codGarcom = a.codGarcom on C.NroMesa = A.nroMesa where a.situacao = 'Em Atendimento'