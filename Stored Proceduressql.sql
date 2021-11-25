create database Stored_Procedures
go 
use Stored_Procedures


create procedure sp_sayHello
as
begin 
	print 'Hello World!'
end

use procedure sp_sayHello


-- Para executar a Stored Procedure:
exec sp_sayHello

create procedure sp_quad
	@n1 int
as 
begin
	print @n1 * @n1
end

-- Para executar:
exec sp_quad 3

create procedure sp_2num
	@numA int,
	@numB int
as
begin
	if(@numA < @numB)
	begin 
		print @numA	
		print @numB
	end
	else
		print @numB
		print @numA
end

alter procedure sp_sayHello
	@nome varchar(50),
	@sexo varchar(1)
as
begin
	if @sexo = 'F'
		print 'Olá' + @nome + ' seja bem vinda!'	
	else
		if  @sexo = 'M'
			print 'Olá' + @nome + ' seja bem vindo!'
		else
			print 'Opção Inválida'

		end

alter procedure sp_quad
	@n1 int
as
begin print 'O quadrado de ' + 
			cast(@n1 as varchar(10)) + -- Função CAST faz conversão de tipos de dados
			' é: ' +
			cast (@n1*@n1 as varchar(10))
end	

-- Para executar
exec sp_quad 584


create procedure sp_dt
	@idConta int
as
begin
	update contasReceber set dtPagto = getdate() where idConta = @idConta
end

-- P/ executar
exec sp_dt 20

create procedure sp_hora_servidor
as
begin 
	print 'Hora servidor: ' + convert(varchar(20), getdate(), 108)
end

alter procedure sp_hora_servidor
as
begin
	print 'Data atual: ' + convert(varchar(20), getdate(), 100)
end

-- Para executar
exec sp_hora_servidor

create table departamento(
  idDepto int constraint pk_depto primary key identity(1,1),
  depto varchar(40) NOT NULL 
)

create table funcionario(
  idFun int constraint pk_fun primary key identity(1,1),
  nome varchar(50) NOT NULL,
  cpf varchar(20),
  rg varchar(50),
  e_mail varchar(50),
  dt_nasc datetime,
  dt_admissao datetime,
  senhaDesc varchar(20),
  idDepto int constraint fk_fun_depto foreign key references departamento(idDepto)
)

create table salario(
  idSalario int constraint pk_salario primary key identity(1,1),
  valor money constraint chkValor check(valor > 0),
  dtPagto datetime,
  obs varchar(1000),
  idFun int constraint fk_sal_fun foreign key references funcionario(idFun)
)

set dateformat dmy

insert into departamento
values ('LOGISTICA')

insert into funcionario(nome, idDepto)
values ('AUGUSTO', 1)

insert into salario
values
  (2050.49, '25/01/2014', 'Sem faltas no período', 1),
  (2534.00, '15/02/2014', 'Inclui bônus por equipe', 1),
  (1998.40, '18/03/2014', NULL, 1)

select * from departamento
select * from funcionario
select * from salario

-- ## ## ## ## ##

create procedure sp_inseredepto
	@depto varchar(40)
as
begin
	insert into departamento(depto)
		values(@depto)
end

exec sp_inseredepto 'Expedicao'
exec sp_inseredepto 'Compras'
exec sp_inseredepto 'Faturamento'

create procedure inserteFun
	@nome varchar(60),
	@idDep int
as
begin
	insert into funcionario(nome, idDepto)
	values(@nome, @idDep)

	exec sp_hora_servidor @nome
end

exec inserteFun 'Gomes', 1 
exec inserteFun 'Sousa', 2
exec inserteFun 'Fagundes', 3
exec inserteFun 'Cesar', 4

alter procedure inserteFun
	@nome varchar(60), @cpf varchar(20),
	@rg varchar(50), @e_mail varchar(50),
	@dt_nasc datetime, @dt_admissao datetime,
	@senhaDesc varchar(20), @idDep int
as
begin 
	insert into funcionario(nome, cpf, rg, e_mail, dt_nasc, dt_admissao, senhaDesc, idDepto)
	values (@nome, @cpf, @rg, @e_mail, @dt_nasc, @dt_admissao, @senhaDesc, @idDep)
end

set dateformat dmy

exec inserteFun 'Adao', '122.223.334-55', '100.200.300.X', 'adao@paraiso.com'

select * from salario

create procedure sp_darsalario
	@valor money,
	@dtPagto date = null,
	@obs varchar(200) = null,
	@idFun int
as
begin
	insert into salario(valor, dtPagto, obs, idFun)
		values(@valor, @dtPagto, @obs, @idFun)
end

set dateformat dmy

exec sp_darsalario 12500, '10/10/2021', 'queijo', 1

exec sp_darsalario @valor = 11000, @idFun = 2

select * from salario


create table MediaSalarial(
  idVlMedio int 
     constraint pk_mediaSal primary key identity(1,1),
  idFun int 
     constraint fk_mediaSal foreign key 
         references funcionario(idFun),
  VlMedio money
)

create procedure sp_MediaSalarial
	@idFun int
as
begin 
	insert into MediaSalarial(idFun, vlmedio)
		select idFun, round(avg(valor),2)
		from salario
		where idFun = @idFun
		group by idFun
end

exec sp_MediaSalarial 2

select * from MediaSalarial

create procedure sp_MaiorMenorIdade
	@dtNasc datetime
as
begin
	declare @idade int -- Variável Local
	select @idade = year(getdate()) - year(@dtNasc)
	if @idade >= 18
		print 'Já pode Dirigir'
	else
		print 'Espere mais um pouco'
end



exec sp_MaiorMenorIdade '20/12/2003'


exec sp_inseredepto 'Financeiro' exec sp_inseredepto'Auditoria' exec sp_inseredepto'TI' exec sp_inseredepto 'Judiciario'

exec inserteFun 'Jão', '444.222', '222.444', 'jao@gmail.com', '16/09/2002', '01/05/2020', 'jaozin114', '7'
exec inserteFun 'Pão', '333.555', '555.333', 'pao@gmail.com', '16/09/2002', '01/09/2021', 'paodebatata', '4'
exec inserteFun 'Mantley', '111.333', '333.111', 'pombo@gmail.com', '11/11/1995', '12/12/2017', 'a12b', '3'

exec sp_darsalario 1251, '06/11/2020', 'Ops', '6' exec sp_darsalario 2311, '07/12/2020', 'Hora Extra', '6' exec sp_darsalario 1500, '06/01/2021', 'Faltas Acumuladas', '6' exec sp_darsalario 2100, '06/02/2021', 'Jupiter', '6'
exec sp_darsalario 1251, '06/11/2020', 'Ops', '7' exec sp_darsalario 2311, '07/12/2020', 'Hora Extra', '7' exec sp_darsalario 1500, '06/01/2021', 'Faltas Acumuladas', '7' exec sp_darsalario 2100, '06/02/2021', 'Jupiter', '7'
exec sp_darsalario 1251, '06/11/2020', 'Ops', '8' exec sp_darsalario 2311, '07/12/2020', 'Hora Extra', '8' exec sp_darsalario 1500, '06/01/2021', 'Faltas Acumuladas', '8' exec sp_darsalario 2100, '06/02/2021', 'Jupiter', '8'

select * from funcionario

select * from sys.objects
where type_desc = 'SQL_STORED_PROCEDURE'

create procedure sp_removesalario
	@cpf varchar(20),
	@dtPagto date
as
begin
	declare @id int
	select @id = idFun from funcionario where cpf = @cpf
	delete salario
	where idFun = @id and dtPagto = @dtPagto
end

select * from salario
select * from funcionario

exec sp_removesalario 333.555, '2020/12/07'

create procedure sp_alteraFun
	@idFun int,
	@nome varchar(50) = null,
	@cpf varchar(50) = null,
	@rg varchar(50) = null,
	@e_mail  varchar(50) = null,
	@dt_nasc datetime = null,
	@dt_admissao datetime = null,
	@senhaDesc varchar(20) = null,
	@idDepto int = null
as
begin
	update funcionario
	set
		nome = isnull(@nome, nome)
		cpf = @cpf,
		rg = @rg,
		e_mail = @e_mail,
		dt_nasc = @dt_nasc,
		dt_admissao = @dt_admissao,
		senhaDesc = @senhaDesc,
		idDepto = @idDepto
	where idFun = @idFun
end


create procedure sp_DelFunc_A
	@cpf varchar(40)
as
begin
	delete salario where idFun = (select idFun from funcionario where cpf = @cpf)
	-- e se der um ERRO aqui???	
	delete funcionario where cpf = @cpf
end

exec sp_DelFunc_A '333.555'

drop procedure sp_DelFunc_A


create procedure sp_DelFunc_C
	@cpf varchar(50)
as
begin
	declare @id int
	select @id = idFun from funcionario where cpf = @cpf
	begin transaction tExcFun
		begin try
			delete salario where idFun = @id
			delete funcionario where idFun = @id
			Commit Transaction tExcFun
		end try
		begin catch
			print 'Não foi possível excluir o funcionário'
			Rollback Transaction tExcFun
		end catch
end

create procedure sp_nomeMedia
	@cpf varchar(50)
as
begin
	select nome, avg(valor) as mediaSalarial
		from funcionario F inner join salario S
		on F.idFun = S.idFun
	group by nome
end

select D.depto, avg(valor) as somaSalarioDepto
		from funcionario f inner join salario s ON f.idFun = s.idFun
							inner join departamento d on d.idDepto = f.idDepto
group by D.depto, YEAR(s.dtPagto), MONTH(s.dtPagto)
end


create procedure sp_SomaSalMes
	@nomeDepartamento varchar(30)
as
begin
	select d.depto,
		YEAR(s.dtPagto) as Ano,
		MONTH(s.dtPagto) as Mes,
		SUM(s.valor) as SomaSal
	from 
		funcionario f inner join departamento d ON f.idDepto = d.idDepto
						inner join salario s on f.idFun = s.idFun
		where d.depto = @nomeDepartamento
		group by d.depto, YEAR(s.dtPagto), MONTH(s.dtPagto)
end

exec sp_SomaSalMes 'Expedicao'

select * from departamento

/*create procedure sp_execercicio2
	@idDepto int = null,
	@depto varchar(200) = null
as
begin
	declare*/
	

select * from funcionario

create procedure sp_updtcadastro
	@idFun int,
	@nome varchar(50) = null,
	@cpf varchar(20) = null,
	@rg varchar(50) = null,
	@e_mail varchar(50)	= null,
	@dt_nasc date = null,
	@dt_admissao date = null,
	@senhaDesc varchar(20) = null,
	@idDepto int = null
as
begin
	declare @script varchar(3000)
	set @script = 'update funcionario set '

	if ISNULL(@nome, '') != ''
		set @script = @script + 'nome = ' + @nome
		print @script
	
	if ISNULL(@idFun, '') != ''
		set @script = @script + ' where idFun = ' + cast(@idfun as varchar(1))
		print @script

	return @script
end

drop procedure sp_updtcadastro

exec sp_updtcadastro 1, 'Paulo'

select * from funcionario