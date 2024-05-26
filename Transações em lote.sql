-----------------------------------------------------------------------
-------- Titulo : Uso do Batch insert----------------------------------
------------Nome: Tiago Mabango----------------------------------------
------------Data: 26/05/2024-------------------------------------------

CREATE DATABASE Escola;

CREATE TABLE Alunos (
    Id INT IDENTITY(1,1) PRIMARY KEY,        -- Identificador único para cada aluno
    Nome NVARCHAR(100) NOT NULL,             -- Nome do aluno
    DataNascimento DATE NOT NULL,            -- Data de nascimento do aluno
    Genero CHAR(1) CHECK (Genero IN ('M', 'F', 'O')),  -- Gênero do aluno (M: Masculino, F: Feminino, O: Outro)
    Endereco NVARCHAR(200),                  -- Endereço do aluno
    Cidade NVARCHAR(100),                    -- Cidade do aluno
    Estado NVARCHAR(50),                     -- Estado do aluno
    Telefone NVARCHAR(15),                   -- Telefone do aluno
    Email NVARCHAR(100),                     -- Email do aluno
    DataMatricula DATE DEFAULT GETDATE()     -- Data de matrícula do aluno, padrão para a data atual
);
GO


SELECT * FROM Alunos WITH (NOLOCK)

--Issert com Batch insert


-- Variáveis para controle do loop

DECLARE @BatchSize INT = 1000;  -- Tamanho de cada batch de inserção
DECLARE @TotalRows INT = 300000; -- Número total de linhas a serem inseridas
DECLARE @CurrentRow INT = 0;     -- Contador de linhas inseridas
DECLARE @Nome NVARCHAR(100);
DECLARE @DataNascimento DATE;
DECLARE @Genero CHAR(1);
DECLARE @Endereco NVARCHAR(200);
DECLARE @Cidade NVARCHAR(100);
DECLARE @Estado NVARCHAR(50);
DECLARE @Telefone NVARCHAR(15);
DECLARE @Email NVARCHAR(100);

WHILE @CurrentRow < @TotalRows
BEGIN
    BEGIN TRANSACTION;

    DECLARE @BatchEnd INT = @CurrentRow + @BatchSize;
    IF @BatchEnd > @TotalRows
        SET @BatchEnd = @TotalRows;

    WHILE @CurrentRow < @BatchEnd
    BEGIN
        -- Geração de dados de exemplo
        SET @Nome = 'Aluno ' + CAST(@CurrentRow + 1 AS NVARCHAR(10));
        SET @DataNascimento = DATEADD(DAY, -((@CurrentRow % 10000) + 1), GETDATE());
        SET @Genero = CASE WHEN @CurrentRow % 3 = 0 THEN 'M' WHEN @CurrentRow % 3 = 1 THEN 'F' ELSE 'O' END;
        SET @Endereco = 'Endereço ' + CAST(@CurrentRow + 1 AS NVARCHAR(10));
        SET @Cidade = 'Cidade ' + CAST((@CurrentRow % 100) + 1 AS NVARCHAR(10));
        SET @Estado = 'Estado ' + CAST((@CurrentRow % 50) + 1 AS NVARCHAR(10));
        SET @Telefone = '123456789' + CAST((@CurrentRow % 10) + 1 AS NVARCHAR(10));
        SET @Email = 'aluno' + CAST(@CurrentRow + 1 AS NVARCHAR(10)) + '@exemplo.com';

        -- Inserção de dados
        INSERT INTO Alunos (Nome, DataNascimento, Genero, Endereco, Cidade, Estado, Telefone, Email)
        VALUES (@Nome, @DataNascimento, @Genero, @Endereco, @Cidade, @Estado, @Telefone, @Email);

        -- Incrementa o contador de linhas
        SET @CurrentRow = @CurrentRow + 1;
    END

    COMMIT TRANSACTION;

    -- Espera para não sobrecarregar o servidor (opcional)
    -- WAITFOR DELAY '00:00:01';
END
GO


-------------------------------------------------------
-------------------------------------------------------

---- Insert sem Batch insert


-- Variáveis para controle do loop
DECLARE @TotalRows INT = 300000; -- Número total de linhas a serem inseridas
DECLARE @CurrentRow INT = 0;     -- Contador de linhas inseridas
DECLARE @Nome NVARCHAR(100);
DECLARE @DataNascimento DATE;
DECLARE @Genero CHAR(1);
DECLARE @Endereco NVARCHAR(200);
DECLARE @Cidade NVARCHAR(100);
DECLARE @Estado NVARCHAR(50);
DECLARE @Telefone NVARCHAR(15);
DECLARE @Email NVARCHAR(100);

WHILE @CurrentRow < @TotalRows
BEGIN
    -- Geração de dados de exemplo
    SET @Nome = 'Aluno ' + CAST(@CurrentRow + 1 AS NVARCHAR(10));
    SET @DataNascimento = DATEADD(DAY, -((@CurrentRow % 10000) + 1), GETDATE());
    SET @Genero = CASE WHEN @CurrentRow % 3 = 0 THEN 'M' WHEN @CurrentRow % 3 = 1 THEN 'F' ELSE 'O' END;
    SET @Endereco = 'Endereço ' + CAST(@CurrentRow + 1 AS NVARCHAR(10));
    SET @Cidade = 'Cidade ' + CAST((@CurrentRow % 100) + 1 AS NVARCHAR(10));
    SET @Estado = 'Estado ' + CAST((@CurrentRow % 50) + 1 AS NVARCHAR(10));
    SET @Telefone = '123456789' + CAST((@CurrentRow % 10) + 1 AS NVARCHAR(10));
    SET @Email = 'aluno' + CAST(@CurrentRow + 1 AS NVARCHAR(10)) + '@exemplo.com';

    -- Inserção de dados
    INSERT INTO Alunos (Nome, DataNascimento, Genero, Endereco, Cidade, Estado, Telefone, Email)
    VALUES (@Nome, @DataNascimento, @Genero, @Endereco, @Cidade, @Estado, @Telefone, @Email);

    -- Incrementa o contador de linhas
    SET @CurrentRow = @CurrentRow + 1;
END
GO
