create database TesteTransacao
go
use TesteTransacao
CREATE TABLE teste (
ID INT PRIMARY KEY,
campoA VARCHAR(50) NOT NULL,
campoB VARCHAR(50) NULL
)
-- Transações de autoconfirmação (executadas uma a uma):
Begin Transaction testeTran
	Begin Try
		INSERT INTO teste VALUES (1, 'Um texto qualquer', 'Outro texto')
		INSERT INTO teste VALUES (2, 'BBBBB', 'Novo texto')
		INSERT INTO teste VALUES (3, 'Terceiro texto', 'Nova tentativa')

		Commit Transaction testeTran
	End Try
	Begin Catch
		Rollback Transaction testeTran
	End Catch


select * from teste

delete teste

-- "Try" - Fazer algo

-- "Catch" - Quando algo deu errado

PRINT @@TRANCOUNT
BEGIN TRAN
	PRINT @@TRANCOUNT
	BEGIN TRAN
		PRINT @@TRANCOUNT
	COMMIT
	PRINT @@TRANCOUNT
COMMIT 
PRINT @@TRANCOUNT

SET IMPLICIT_TRANSACTIONS ON
SELECT @@TRANCOUNT

CREATE TABLE NovoTeste (
	ID INT PRIMARY KEY,
	NOME VARCHAR(50),
	SEXO VARCHAR(1))

SELECT @@TRANCOUNT
INSERT INTO NovoTeste VALUES (501, 'MACHADO DE ASSIS', 'M')
SELECT * FROM NovoTeste
SELECT @@TRANCOUNT

Rollback

drop table NovoTeste