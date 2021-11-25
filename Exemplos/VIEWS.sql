create database Views_1
go
use Views_1

drop database Views_1
create table Fabricante(
	CodFabr int constraint PK_Fab primary key identity(1,1),
	razaoSocial varchar(100) constraint razaoSocFab NOT NULL,
	cidadeFab varchar(100) constraint cityFabr default('FRANCA'),
	UF_Fab char(2) constraint UFFAB check(UF_Fab in('SP', 'MG', 'RJ'))
)

create table Categoria(
	codCat int constraint PK_Cat primary key identity(100,1),
	descCat varchar(2000) constraint descCatg NOT NULL,
	status varchar(20) constraint statusCat check(status in('Ativo', 'Inativo')),
	constraint LimiteCat check(codCat <= 999)
)

drop table Produto

create table Produto(
	codPro int constraint PK_Prod primary key identity(1,1),
	descProd varchar(2000) constraint descProd NOT NULL,
	precoProd money constraint precoProd check(precoprod > 0),
	estqProd int constraint estqProd check(estqProd >= 0),
	codFab int constraint FK_codFab foreign key references Fabricante(codFabr),
	codCat int constraint FK_codCat foreign key references Categoria(codCat),
	codMarca int constraint FK_Marca foreign key references Marcas(CodMarca)
)

select * from Produto

insert into Fabricante
	values('P&G', 'SAO PAULO', 'SP'),
			('UNILEVER', 'CAMPINAS', 'SP'),
			('JUSSARA', 'FRANCO DA ROCHA', 'SP'),
			('NESTLE','BELO HORIZONTE','MG'),
			('PARMALAT','RIO DE JANEIRO','RJ')	

insert into Categoria
	values
	('HIGIENE', 'ATIVO'),
	('LIMPEZA', 'INATIVO'),
	('FRIOS', 'INATIVO'),
	('BEBIDAS', 'ATIVO')

insert into Produto
values
('KAYSER', 15.00, 50, 1, 103, 5001),
('DESODORANTE ', 11, 15, 1, 101, 5001),
('BANANA', 8.30, 15, 2, 102, 5002),
('BANANA', 8.30, 20, 2, 102)
(1.50, 'SABAO EM PÓ', 3, 104),
(2.25, 'LAVA LOUÇAS', 5, 100),
(2.2, 'SORVETE NAPOLITANO', 4, 100),
(1.80, 'ARROZ BRANCO', 1, 101),
(10.5, 'CHOCOLATE PRESTÍGIO', 3, 102),
(11.5, 'SKOL LATA', 2, 100),
(18.5, 'PATO', 1, 103)

select * from Produto

select * from Categoria

create view vProFabCat
as
select CodPro, p.descProd as NomePro, precoProd,
c.descCat as NomeCat,
f.RazaoSocial as NomeFabricante, f.cidadeFab as CidadeFabricante
from produto P inner join Fabricante F on P.codFab = F.CodFabr
inner join Categoria as C on P.codCat = C.codCat

select * from vProFabCat

create view	vQtde
as
select M.nomeMarca as Marca, count(*) as qtde
from Produto as	P inner join Marcas as M
					ON P.codMarca = M.codMarca
group by M.nomeMarca 

drop view vQtde

select * from Marcas

select * from vQtde order by qtde desc


create view CatSPInativas
as
	select distinct C.descCat
	from Produto P Inner join Fabricante F on P.codFab = F.CodFabr
					inner join Categoria C on P.codCat = C.codCat
	where UF_Fab = 'SP' AND status = 'INATIVO'

select * from CatSPInativas


select * from Produto

/*create view EstoqueSP
as
	select p.Descricao as Produto, c.Descricao,
		(estoque * preco) as ValorEstoque
		from produto P inner join */

create table Marcas(
	codMarca int constraint PK_Marca primary key identity(5000, 1),
	nomeMarca varchar(200) constraint nomeMarca NOT NULL,
)

alter table Produto
drop column codMarca


drop table Marcas

insert into Marcas
values('DOVE'), ('LUCASA'), ('SMARTTV'), ('PANTENE'), ('LG')

select * from Marcas

select * from Produto

select * from vMarca1

alter table Produto
NOCHECK CONSTRAINT FK_Marca

create view vMarca1
as
select M.nomeMarca as 'Nome Marca', P.estqProd as 'Estoque Produto'
		from Produto as P inner join Marcas as M on M.codMarca = P.codMarca


create view MarFabrInativas
as
select F.razaosocial, M.nomeMarca --C.status
	from Categoria C inner join Produto P on C.codCat = P.codCat
						inner join Fabricante F on F.CodFabr = P.codFab
						inner join Marcas M on M.codMarca = P.codMarca
		where status = 'INATIVO'

select * from vMarca1 order by [Estoque Produto] desc

select * from MarFabrInativas



create view DescProd
as
select P.descProd as Prod, P.precoProd, M.nomeMarca
	from Produto P inner join Marcas M on P.codMarca = M.codMarca

	drop view DescProd


select * from DescProd order by Produto

