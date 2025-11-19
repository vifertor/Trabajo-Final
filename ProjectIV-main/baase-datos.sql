select * from proveedor

select * from marca


--------------------------------Marca

CREATE OR ALTER PROCEDURE sp_GetAllMarca
AS
BEGIN
    SELECT Marca_Id, Marca_Nombre, Marca_Estado
    FROM Marca
    WHERE Marca_Estado = 1
	 ORDER BY Marca_Id desc
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



CREATE OR ALTER PROCEDURE sp_ActivarMarca
    @Marca_Id INT
AS
BEGIN
    UPDATE Marca
    SET Marca_Estado = 1
    WHERE Marca_Id = @Marca_Id
END


CREATE OR ALTER PROCEDURE sp_GetAllMarcaInactiva
AS
BEGIN
    SELECT Marca_Id, Marca_Nombre, Marca_Estado
    FROM Marca
    WHERE Marca_Estado IS NULL OR Marca_Estado = 0
    ORDER BY Marca_Id desc
END


CREATE OR ALTER PROCEDURE sp_GetMarcaByIdinavilitado
    @Marca_Id INT
AS
BEGIN
    SELECT Marca_Id, Marca_Nombre, Marca_Estado
    FROM Marca
    WHERE Marca_Id = @Marca_Id AND Marca_Estado = 0
END


exec sp_GetAllMarcaInactiva
EXEC sp_ActivateMarca @Marca_Id = 5
exec sp_GetMarcaByIdinavilitado @Marca_ID = 5;
EXEC sp_GetMarcaByIdinavilitado @Marca_Id = 2;

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



	--Modelo

CREATE TABLE [dbo].[MODELO] (
    [IdModelo] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nombre] VARCHAR(50) NOT NULL,
    [Descripcion] VARCHAR(200) NULL,
    [Estado] BIT NOT NULL DEFAULT 1,
    [FechaRegistro] datetime not null,
);





ALTER TABLE [dbo].[MODELO]
ALTER COLUMN [FechaRegistro] DATETIME NOT NULL;
delete from mode
/* =========================
   LISTAR MODELOS ACTIVOS
   ========================= */
CREATE OR ALTER PROCEDURE sp_GetAllModelo
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdModelo,
           Nombre,
           Descripcion,
           Estado,
           FechaRegistro
    FROM   dbo.MODELO
    WHERE  Estado = 1
    ORDER BY IdModelo DESC;
END
GO


/* =========================
   INSERTAR NUEVO MODELO
   ========================= */
CREATE OR ALTER PROCEDURE sp_AddModelo
    @Nombre      VARCHAR(50),
    @Descripcion VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.MODELO (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);
END
GO


/* =========================
   OBTENER MODELO POR ID (ACTIVO)
   ========================= */
CREATE OR ALTER PROCEDURE sp_GetModeloById
    @IdModelo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdModelo,
           Nombre,
           Descripcion,
           Estado,
           FechaRegistro
    FROM   dbo.MODELO
    WHERE  IdModelo = @IdModelo
      AND  Estado    = 1;
END
GO


/* =========================
   ACTUALIZAR MODELO (SOLO SI ESTÁ ACTIVO)
   ========================= */
CREATE OR ALTER PROCEDURE sp_UpdateModelo
    @IdModelo    INT,
    @Nombre      VARCHAR(50),
    @Descripcion VARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.MODELO
    SET    Nombre      = @Nombre,
           Descripcion = @Descripcion
    WHERE  IdModelo = @IdModelo
      AND  Estado   = 1;
END
GO


/* =========================
   DESACTIVAR (SOFT-DELETE)
   ========================= */
CREATE OR ALTER PROCEDURE sp_DeleteModelo
    @IdModelo INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.MODELO
    SET    Estado = 0
    WHERE  IdModelo = @IdModelo;
END
GO


/* =========================
   RE-ACTIVAR MODELO
   ========================= */
CREATE OR ALTER PROCEDURE sp_ActivarModelo
    @IdModelo INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.MODELO
    SET    Estado = 1
    WHERE  IdModelo = @IdModelo;
END
GO


/* =========================
   LISTAR MODELOS INACTIVOS
   ========================= */
CREATE OR ALTER PROCEDURE sp_GetAllModeloInactiva
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdModelo,
           Nombre,
           Descripcion,
           Estado,
           FechaRegistro
    FROM   dbo.MODELO
    WHERE  Estado IS NULL OR Estado = 0
    ORDER BY IdModelo DESC;
END
GO


/* =========================
   OBTENER MODELO INACTIVO POR ID
   ========================= */
CREATE OR ALTER PROCEDURE sp_GetModeloByIdInactivo
    @IdModelo INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT IdModelo,
           Nombre,
           Descripcion,
           Estado,
           FechaRegistro
    FROM   dbo.MODELO
    WHERE  IdModelo = @IdModelo
      AND  Estado   = 0;
END
GO
select * from Marca
select * from MODELO



--ejempo 2


CREATE OR ALTER PROCEDURE sp_CRUD_MODELO
    @Opcion NVARCHAR(10),
    @IdModelo INT = NULL,
    @Nombre VARCHAR(50) = NULL,
    @Descripcion VARCHAR(200) = NULL,
    @Estado BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Opcion = 'INSERT'
    BEGIN
        INSERT INTO MODELO (Nombre, Descripcion, Estado, FechaRegistro)
        VALUES (@Nombre, @Descripcion, 1, GETDATE());
    END

    ELSE IF @Opcion = 'UPDATE'
    BEGIN
        UPDATE MODELO
        SET Nombre = @Nombre,
            Descripcion = @Descripcion
           
        WHERE IdModelo = @IdModelo;
    END

    ELSE IF @Opcion = 'DELETE'
    BEGIN
        UPDATE MODELO
        SET Estado = 0
        WHERE IdModelo = @IdModelo;
    END

    ELSE IF @Opcion = 'GETALL'
    BEGIN
        SELECT * FROM MODELO WHERE Estado = 1 ORDER BY IdModelo DESC;
    END

    ELSE IF @Opcion = 'GETBYID'
    BEGIN
        SELECT * FROM MODELO WHERE IdModelo = @IdModelo;
    END
END;


CREATE PROCEDURE sp_ActivarModelo
    @IdModelo INT
AS
BEGIN
    UPDATE MODELO
    SET Estado = 1
    WHERE IdModelo = @IdModelo;
END;
CREATE PROCEDURE sp_GetModelosInactivos
AS
BEGIN
    SELECT * FROM MODELO WHERE Estado = 0 ORDER BY IdModelo DESC;
END;


select * from MODELO





------------------------------------


CREATE TABLE [dbo].[PRODUCTO] (
    [IdProducto]    INT        IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Nombre]        VARCHAR(100) NOT NULL,
    [Descripcion]   VARCHAR(200) NULL,
    [Estado]        BIT        NOT NULL DEFAULT 1,
    [FechaCreacion] DATETIME   NOT NULL DEFAULT GETDATE()
);


/* ============================================
   CRUD GENERAL PARA PRODUCTO
   ============================================ */
CREATE OR ALTER PROCEDURE sp_CRUD_PRODUCTO
    @Opcion NVARCHAR(10),
    @IdProducto    INT           = NULL,
    @Nombre        VARCHAR(100)  = NULL,
    @Descripcion   VARCHAR(200)  = NULL,
    @Estado        BIT           = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Opcion = 'INSERT'
    BEGIN
        INSERT INTO PRODUCTO (Nombre, Descripcion, Estado, FechaCreacion)
        VALUES (@Nombre, @Descripcion, 1, GETDATE());
    END

    ELSE IF @Opcion = 'UPDATE'
    BEGIN
        UPDATE PRODUCTO
        SET Nombre      = @Nombre,
            Descripcion = @Descripcion
        WHERE IdProducto = @IdProducto;
    END

    ELSE IF @Opcion = 'DELETE'
    BEGIN
        UPDATE PRODUCTO
        SET Estado = 0
        WHERE IdProducto = @IdProducto;
    END

    ELSE IF @Opcion = 'GETALL'
    BEGIN
        SELECT *
        FROM PRODUCTO
        WHERE Estado = 1
        ORDER BY IdProducto DESC;
    END

    ELSE IF @Opcion = 'GETBYID'
    BEGIN
        SELECT *
        FROM PRODUCTO
        WHERE IdProducto = @IdProducto;
    END
END;
GO

/* ============================================
   REACTIVAR PRODUCTO
   ============================================ */
CREATE OR ALTER PROCEDURE sp_ActivarProducto
    @IdProducto INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PRODUCTO
    SET Estado = 1
    WHERE IdProducto = @IdProducto;
END;
GO

/* ============================================
   LISTAR PRODUCTOS INACTIVOS
   ============================================ */
CREATE OR ALTER PROCEDURE sp_GetProductosInactivos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM PRODUCTO
    WHERE Estado = 0
    ORDER BY IdProducto DESC;
END;
GO

/* ============================================
   OBTENER PRODUCTO INACTIVO POR ID
   ============================================ */
CREATE OR ALTER PROCEDURE sp_GetProductoByIdInactivo
    @IdProducto INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM PRODUCTO
    WHERE IdProducto = @IdProducto
      AND Estado      = 0;
END;
GO



--,empleado,empresa,proveedor,




CREATE TABLE [dbo].[Proveedor] (
    [IdProveedor]        INT             IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [NombreEmpresa]      VARCHAR(100)    NOT NULL,
    [Descripcion]        VARCHAR(200)    NULL,
    [EncargadoNombre]    VARCHAR(50)     NULL,
    [EncargadoApellido1] VARCHAR(50)     NULL,
    [EncargadoApellido2] VARCHAR(50)     NULL,
    [Correo]             VARCHAR(50)     NULL,
    [Telefono]           VARCHAR(50)     NULL,
    [Estado]             BIT             NOT NULL DEFAULT 1,
    [FechaRegistro]      DATETIME        NOT NULL DEFAULT GETDATE())



	-- ================================================
-- CRUD para Proveedor
-- ================================================
CREATE OR ALTER PROCEDURE sp_CRUD_Proveedor
    @Opcion                NVARCHAR(10),
    @IdProveedor           INT             = NULL,
    @NombreEmpresa         VARCHAR(100)    = NULL,
    @Descripcion           VARCHAR(200)    = NULL,
    @EncargadoNombre       VARCHAR(50)     = NULL,
    @EncargadoApellido1    VARCHAR(50)     = NULL,
    @EncargadoApellido2    VARCHAR(50)     = NULL,
    @Correo                VARCHAR(50)     = NULL,
    @Telefono              VARCHAR(50)     = NULL,
    @Estado                BIT             = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Opcion = 'INSERT'
    BEGIN
        INSERT INTO Proveedor
            (NombreEmpresa, Descripcion, EncargadoNombre, EncargadoApellido1, EncargadoApellido2, Correo, Telefono, Estado, FechaRegistro)
        VALUES
            (@NombreEmpresa, @Descripcion, @EncargadoNombre, @EncargadoApellido1, @EncargadoApellido2, @Correo, @Telefono, 1, GETDATE());
    END
    ELSE IF @Opcion = 'UPDATE'
    BEGIN
        UPDATE Proveedor
           SET NombreEmpresa      = @NombreEmpresa,
               Descripcion        = @Descripcion,
               EncargadoNombre    = @EncargadoNombre,
               EncargadoApellido1 = @EncargadoApellido1,
               EncargadoApellido2 = @EncargadoApellido2,
               Correo             = @Correo,
               Telefono           = @Telefono
         WHERE IdProveedor = @IdProveedor;
    END
    ELSE IF @Opcion = 'DELETE'
    BEGIN
        UPDATE Proveedor
           SET Estado = 0
         WHERE IdProveedor = @IdProveedor;
    END
    ELSE IF @Opcion = 'GETALL'
    BEGIN
        SELECT *
          FROM Proveedor
         WHERE Estado = 1
         ORDER BY IdProveedor DESC;
    END
    ELSE IF @Opcion = 'GETBYID'
    BEGIN
        SELECT *
          FROM Proveedor
         WHERE IdProveedor = @IdProveedor;
    END
END;
GO

-- ================================================
-- Reactivar Proveedor
-- ================================================
CREATE OR ALTER PROCEDURE sp_ActivarProveedor
    @IdProveedor INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Proveedor
       SET Estado = 1
     WHERE IdProveedor = @IdProveedor;
END;
GO

-- ================================================
-- Listar Proveedores Inactivos
-- ================================================
CREATE OR ALTER PROCEDURE sp_GetProveedoresInactivos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
      FROM Proveedor
     WHERE Estado = 0
     ORDER BY IdProveedor DESC;
END;
GO

-- ================================================
-- Obtener Proveedor Inactivo por ID
-- ================================================
CREATE OR ALTER PROCEDURE sp_GetProveedorByIdInactivo
    @IdProveedor INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
      FROM Proveedor
     WHERE IdProveedor = @IdProveedor
       AND Estado      = 0;
END;
GO











----------------------------------------
-----------------------



--cPOMPRA

CREATE TABLE DetalleProducto (
    Id_DetalleProducto INT PRIMARY KEY IDENTITY(1,1),
    Id_Producto INT NOT NULL,
    Marca_Id INT NOT NULL,
    Id_Categoria INT NOT NULL,
    Id_Modelo INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Estado BIT NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (Id_Producto) REFERENCES Producto(IdProducto),
    FOREIGN KEY (Marca_Id) REFERENCES Marca(Marca_Id),
    FOREIGN KEY (Id_Categoria) REFERENCES Categoria(IdCategoria),
    FOREIGN KEY (Id_Modelo) REFERENCES Modelo(IdModelo)
);
INSERT INTO DetalleProducto 
(Id_Producto, Marca_Id, Id_Categoria, Id_Modelo, PrecioUnitario, Estado)
VALUES 
(1, 1, 3, 4, 650.00, 1),
(2, 2, 4, 3, 10.50, 1)


select *from MODELO

CREATE TABLE Inventario (
    IdInventario INT PRIMARY KEY IDENTITY(1,1),
    Id_DetalleProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    Estado BIT NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (Id_DetalleProducto) REFERENCES DetalleProducto(Id_DetalleProducto)
);




CREATE TABLE Compra (
    Id_Compra INT PRIMARY KEY IDENTITY(1,1),
    Id_Proveedor INT NOT NULL,
    Id_Empleado INT NOT NULL,
    MontoTotal DECIMAL(10, 2) NOT NULL, -- Total ya incluye IVA u otros conceptos
    FechaCompra DATETIME NOT NULL DEFAULT GETDATE(),
    Estado BIT NOT NULL,

    FOREIGN KEY (Id_Proveedor) REFERENCES Proveedor(IdProveedor),
    FOREIGN KEY (Id_Empleado) REFERENCES Empleado(IdEmpleado)
);


CREATE TABLE DetalleCompra (
    Id_DetalleCompra INT PRIMARY KEY IDENTITY(1,1),
    Id_Compra INT NOT NULL,
    Id_DetalleProducto INT NOT NULL,
    PrecioCompra DECIMAL(10, 2) NOT NULL,
    Cantidad INT NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    Estado BIT NOT NULL,

    FOREIGN KEY (Id_Compra) REFERENCES Compra(Id_Compra),
    FOREIGN KEY (Id_DetalleProducto) REFERENCES DetalleProducto(Id_DetalleProducto)
);




-------------------maestro


------------2


CREATE TYPE TipoDetalleCompra AS TABLE (
    Id_DetalleProducto INT,
    Cantidad INT,
    PrecioCompra DECIMAL(10,2)
);


CREATE PROCEDURE USP_InsertCompra
    @Id_Proveedor INT,
    @Id_Empleado INT,
    @DetalleCompra TipoDetalleCompra READONLY,
    @Result BIT OUTPUT
AS
BEGIN
    DECLARE @Id_Compra INT;
    DECLARE @MontoTotal DECIMAL(10,2);

    BEGIN TRANSACTION;

    BEGIN TRY
        -- 1. Insertar en la tabla Compra con monto inicial 0
        INSERT INTO Compra (Id_Proveedor, Id_Empleado, MontoTotal, FechaCompra, Estado)
        VALUES (@Id_Proveedor, @Id_Empleado, 0, GETDATE(), 1);

        SET @Id_Compra = SCOPE_IDENTITY();

        -- 2. Insertar en DetalleCompra con cálculo de Subtotal
        INSERT INTO DetalleCompra (Id_Compra, Id_DetalleProducto, PrecioCompra, Cantidad, Subtotal, Estado)
        SELECT 
            @Id_Compra,
            Id_DetalleProducto,
            PrecioCompra,
            Cantidad,
            PrecioCompra * Cantidad,
            1
        FROM @DetalleCompra;

        -- 3. Calcular el MontoTotal y actualizar Compra
        SELECT @MontoTotal = SUM(PrecioCompra * Cantidad)
        FROM @DetalleCompra;

        UPDATE Compra
        SET MontoTotal = @MontoTotal
        WHERE Id_Compra = @Id_Compra;

        -- 4. Actualizar Inventario
        MERGE Inventario AS inv
        USING (
            SELECT Id_DetalleProducto, Cantidad FROM @DetalleCompra
        ) AS src
        ON inv.Id_DetalleProducto = src.Id_DetalleProducto
        WHEN MATCHED THEN
            UPDATE SET inv.Cantidad = inv.Cantidad + src.Cantidad
        WHEN NOT MATCHED THEN
            INSERT (Id_DetalleProducto, Cantidad, Estado, FechaRegistro)
            VALUES (src.Id_DetalleProducto, src.Cantidad, 1, GETDATE());

        SET @Result = 1;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        SET @Result = 0;
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END



---------333
--101209


select *from Compra
select * from DetalleCompra
select *from Proveedor
SELECT * FROM Inventario
sel
select *de
select *from DetalleProducto
select*from Marca
select*from MODELO
select *from PRODUCTO
select*from CATEGORIA

DECLARE @DetalleCompra TipoDetalleCompra;

-- Insertar detalle(s)
INSERT INTO @DetalleCompra (Id_DetalleProducto, Cantidad, PrecioCompra)
VALUES
    (6, 10, 25.50),
	 (7, 10, 10)-- Ejemplo: detalle producto con ID=1, 10 unidades, precio 25.50
  

DECLARE @Resultado BIT;

EXEC USP_InsertCompra
    @Id_Proveedor = 1,
    @Id_Empleado = 1,
    @DetalleCompra = @DetalleCompra,
    @Result = @Resultado OUTPUT;

-- Mostrar resultado
SELECT @Resultado AS Resultado;










select *f
selecg *from det
select * from DetalleProducto
select *from DetalleCompra
select *from Proveedor
---------listar
CREATE PROCEDURE USP_ListarComprasConDetalle
AS
BEGIN
    SELECT 
        c.Id_Compra,
        c.Id_Proveedor,
        p.NombreEmpresa, -- asumiendo que tienes esta columna en Proveedor
        c.Id_Empleado,
        e.Nombres,  -- asumiendo que tienes esta columna en Empleado
        c.MontoTotal,
        c.FechaCompra,
        c.Estado,
        dc.Id_DetalleCompra,
        dc.Id_DetalleProducto,
        dp.PrecioUnitario,
        dc.PrecioCompra,
        dc.Cantidad,
        dc.Subtotal
    FROM Compra c
    INNER JOIN Proveedor p ON c.Id_Proveedor = p.IdProveedor
    INNER JOIN Empleado e ON c.Id_Empleado = e.IdEmpleado
    INNER JOIN DetalleCompra dc ON c.Id_Compra = dc.Id_Compra
    INNER JOIN DetalleProducto dp ON dc.Id_DetalleProducto = dp.Id_DetalleProducto
    ORDER BY c.Id_Compra, dc.Id_DetalleCompra;
END;


EXEC USP_ListarComprasConDetalle;



version 2


CREATE PROCEDURE USP_ListarComprasActivas
AS
BEGIN
    -- Maestro: lista de compras activas
    SELECT 
        c.Id_Compra,
        c.Id_Proveedor,
        p.NombreEmpresa,
        c.Id_Empleado,
        e.Nombres AS NombreEmpleado,
        c.MontoTotal,
        c.FechaCompra,
        c.Estado
    FROM Compra c
    INNER JOIN Proveedor p ON c.Id_Proveedor = p.IdProveedor
    INNER JOIN Empleado e ON c.Id_Empleado = e.IdEmpleado
    WHERE c.Estado = 1;

    -- Detalle: detalles de todas las compras activas
    SELECT 
        dc.Id_DetalleCompra,
        dc.Id_Compra,
        dc.Id_DetalleProducto,
        pr.Nombre AS NombreProducto,
        m.Marca_Nombre AS Marca,
        mo.Nombre AS Modelo,
        c.NombreCategoria AS Categoria,
        dp.PrecioUnitario,
        dc.PrecioCompra,
        dc.Cantidad,
        dc.Subtotal
    FROM DetalleCompra dc
    INNER JOIN Compra comp ON dc.Id_Compra = comp.Id_Compra AND comp.Estado = 1
    INNER JOIN DetalleProducto dp ON dc.Id_DetalleProducto = dp.Id_DetalleProducto
    INNER JOIN Producto pr ON dp.Id_Producto = pr.IdProducto
    INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
    INNER JOIN Modelo mo ON dp.Id_Modelo = mo.IdModelo
    INNER JOIN Categoria c ON dp.Id_Categoria = c.IdCategoria
    ORDER BY dc.Id_Compra, dc.Id_DetalleCompra;
END


d
sw
select*frompr
select* from pr
select *from Compra
select *from DetalleCompra
select ?*


----buscar

CREATE PROCEDURE USP_GetCompraById
    @IdCompra INT
AS
BEGIN
    -- Maestro (compra)
    SELECT 
        c.Id_Compra,
        c.Id_Proveedor,
        p.NombreEmpresa, -- ajusta al nombre real en tu tabla
        c.Id_Empleado,
        e.Nombres, -- ajusta al nombre real
        c.MontoTotal,
        c.FechaCompra,
        c.Estado
    FROM Compra c
    INNER JOIN Proveedor p ON c.Id_Proveedor = p.IdProveedor
    INNER JOIN Empleado e ON c.Id_Empleado = e.IdEmpleado
    WHERE c.Id_Compra = @IdCompra;

    -- Detalle de la compra
    SELECT 
        dc.Id_DetalleCompra,
        dc.Id_Compra,
        dc.Id_DetalleProducto,
        pr.Nombre AS NombreProducto, -- ajusta al nombre real en Producto
        m.Marca_Nombre AS Marca,
        mo.Nombre AS Modelo,
        c.NombreCategoria AS Categoria,
        dp.PrecioUnitario,
        dc.PrecioCompra,
        dc.Cantidad,
        dc.Subtotal
    FROM DetalleCompra dc
    INNER JOIN DetalleProducto dp ON dc.Id_DetalleProducto = dp.Id_DetalleProducto
    INNER JOIN Producto pr ON dp.Id_Producto = pr.IdProducto
    INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
    INNER JOIN Modelo mo ON dp.Id_Modelo = mo.IdModelo
    INNER JOIN Categoria c ON dp.Id_Categoria = c.IdCategoria
    WHERE dc.Id_Compra = @IdCompra;
END;



select ( from deta



select *from pro

select *from producto



EXEC USP_GetCompraById @IdCompra = 5;




select * from Compra