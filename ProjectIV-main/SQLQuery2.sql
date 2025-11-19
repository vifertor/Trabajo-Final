select * from proveedor

select * from marca


--------------------------------Marca

CREATE OR ALTER PROCEDURE sp_GetAllMarca
AS
BEGIN
    SELECT Marca_Id, Marca_Nombre, Marca_Estado
    FROM Marca
    WHERE Marca_Estado = 1
END


----------------------

CREATE OR ALTER PROCEDURE sp_AddMarca
    @Marca_Nombre VARCHAR(40)
AS
BEGIN
    INSERT INTO Marca (Marca_Nombre)
    VALUES (@Marca_Nombre)
END

---------------

CREATE OR ALTER PROCEDURE sp_GetMarcaById
    @Marca_Id INT
AS
BEGIN
    SELECT Marca_Id, Marca_Nombre, Marca_Estado
    FROM Marca
    WHERE Marca_Id = @Marca_Id AND Marca_Estado = 1
END

--------------------------------

CREATE OR ALTER PROCEDURE sp_UpdateMarca
    @Marca_Id INT,
    @Marca_Nombre VARCHAR(40)
AS
BEGIN
    UPDATE Marca
    SET Marca_Nombre = @Marca_Nombre
    WHERE Marca_Id = @Marca_Id AND Marca_Estado = 1
END


--------------------------------


CREATE OR ALTER PROCEDURE sp_DeleteMarca
    @Marca_Id INT
AS
BEGIN
    UPDATE Marca
    SET Marca_Estado = 0
    WHERE Marca_Id = @Marca_Id
END


select * from Marca



--------------------------------------------------------------------------






create database Usuario(
    Usuario_Id INT PRIMARY KEY IDENTITY(1,1),
    NombreCompleto NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(60) NOT NULL UNIQUE,
    Contrasena NVARCHAR(50) NOT NULL, -- Aquí se guardará la contraseña hasheada
    Rol int, 
	FechaCreacion datetime,
    Estado BIT NOT NULL DEFAULT 1
	
	)

