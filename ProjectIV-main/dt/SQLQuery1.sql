CREATE PROCEDURE [dbo].[USP_InsertarCompra]
    @IdProveedor INT,
    @IdEmpleado INT,
    @FechaCompra DATETIME = NULL, -- Valor predeterminado NULL
    @Observaciones NVARCHAR(255),
    @DetalleCompra TipoDetalleCompra READONLY, -- Usamos el tipo de tabla como parámetro
    @Result BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Result = 1;

    -- Si no se pasa la fecha, se asigna la fecha actual
    IF @FechaCompra IS NULL
    BEGIN
        SET @FechaCompra = GETDATE();
    END

    -- Iniciar la transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insertar la compra principal en la tabla 'Compra'
        INSERT INTO Compra (IdProveedor, IdEmpleado, FechaCompra, Observaciones)
        VALUES (@IdProveedor, @IdEmpleado, @FechaCompra, @Observaciones);

        -- Obtener el Id de la compra recién insertada
        DECLARE @IdCompra INT = SCOPE_IDENTITY();

        -- Variables para manejar el detalle de la compra
        DECLARE @idProducto INT, @idCategoria INT, @idMarca INT, @idModelo INT, @IdColor INT, @IdMedida INT;
        DECLARE @IdVersionn INT, @PrecioCompra DECIMAL(10,2), @PrecioVenta DECIMAL(10,2), @Cantidad INT;
        DECLARE @IdDetalleProducto INT, @MovimientoId INT, @StockActual INT, @MontoTotal DECIMAL(10, 2);

        -- Cursor para recorrer el detalle de la compra
        DECLARE DetalleCursor CURSOR FOR
        SELECT idProducto, idCategoria, idMarca, idModelo, IdColor, IdMedida, IdVersionn, PrecioCompra, PrecioVenta, Cantidad
        FROM @DetalleCompra;

        OPEN DetalleCursor;
        FETCH NEXT FROM DetalleCursor INTO @idProducto, @idCategoria, @idMarca, @idModelo, @IdColor, @IdMedida, @IdVersionn, @PrecioCompra, @PrecioVenta, @Cantidad;

        -- Recorrer cada registro del detalle de la compra
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Insertar o actualizar en la tabla DetalleProducto
            -- Primero verificamos si el producto ya existe en DetalleProducto
            SELECT @IdDetalleProducto = IdDetalleProducto
            FROM DetalleProducto
            WHERE IdProducto = @idProducto
              AND IdCategoria = @idCategoria
              AND IdMarca = @idMarca
              AND (IdModelo = @idModelo OR IdModelo IS NULL)
              AND (IdColor = @IdColor OR IdColor IS NULL)
              AND (IdMedida = @IdMedida OR IdMedida IS NULL)
              AND (IdVersionn = @IdVersionn OR IdVersionn IS NULL);

            IF @IdDetalleProducto IS NULL
            BEGIN
                -- Si no existe el producto, insertamos un nuevo registro
                INSERT INTO DetalleProducto (IdProducto, IdCategoria, IdMarca, IdModelo, IdColor, IdMedida, IdVersionn, PrecioCompra, PrecioVenta, Estado, FechaRegistro)
                VALUES (@idProducto, @idCategoria, @idMarca, @idModelo, @IdColor, @IdMedida, @IdVersionn, @PrecioCompra, @PrecioVenta, 1, GETDATE());

                SET @IdDetalleProducto = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                -- Si el producto ya existe, solo actualizamos el precio de compra y venta
                UPDATE DetalleProducto
                SET PrecioCompra = @PrecioCompra,
                    PrecioVenta = @PrecioVenta
                WHERE IdDetalleProducto = @IdDetalleProducto;
            END

            -- Calcular el monto total de la compra
            SET @MontoTotal = @PrecioCompra * @Cantidad;

            -- Insertar el detalle de la compra en la tabla DetalleCompra
            INSERT INTO DetalleCompra (IdCompra, IdDetalleProducto, PrecioCompra, PrecioVenta, Cantidad, MontoTotal)
            VALUES (@IdCompra, @IdDetalleProducto, @PrecioCompra, @PrecioVenta, @Cantidad, @MontoTotal);

            -- Actualizar o insertar el producto en Inventario
            -- Verificar si ya existe en Inventario
            SELECT @StockActual = Stock
            FROM Inventario
            WHERE IdDetalleProducto = @IdDetalleProducto;

            IF @StockActual IS NULL
            BEGIN
                -- Si no existe, insertar un nuevo registro en Inventario
                INSERT INTO Inventario (IdDetalleProducto, Stock)
                VALUES (@IdDetalleProducto, @Cantidad);
            END
            ELSE
            BEGIN
                -- Si existe, actualizar el stock
                UPDATE Inventario
                SET Stock = Stock + @Cantidad
                WHERE IdDetalleProducto = @IdDetalleProducto;
            END

            -- Registrar el movimiento interno en la tabla MovimientoInterno
            INSERT INTO MovimientoInterno (Movimiento_Descripcion, Movimiento_Fecha, Movimiento_ProductoId, Stock, Movimiento_Estado)
            VALUES ('Compra de producto', @FechaCompra, @IdDetalleProducto, @Cantidad, 1);

            -- Obtener el ID del movimiento para actualizar Inventario
            SET @MovimientoId = SCOPE_IDENTITY();

            -- Actualizar el inventario con el movimiento registrado
            UPDATE Inventario
            SET MovimientoId = @MovimientoId
            WHERE IdDetalleProducto = @IdDetalleProducto;

            -- Obtener el siguiente registro
            FETCH NEXT FROM DetalleCursor INTO @idProducto, @idCategoria, @idMarca, @idModelo, @IdColor, @IdMedida, @IdVersionn, @PrecioCompra, @PrecioVenta, @Cantidad;
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;

        SET @Result = 1; -- Indicar que la operación fue exitosa
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, hacer rollback y asignar el resultado a 0
        ROLLBACK TRANSACTION;
        SET @Result = 0;
    END CATCH
END;


DECLARE @Resultado BIT;
DECLARE @DetalleCompra TipoDetalleCompra;

-- Insertar datos de prueba en @DetalleCompra
INSERT INTO @DetalleCompra (idProducto, idCategoria, idMarca, idModelo, IdColor, IdMedida, IdVersionn, PrecioCompra, PrecioVenta, Cantidad)
VALUES (1, 1, 1, 1, 1, 1, 1, 100.00, 150.00, 10);

-- Llamar al procedimiento con los parámetros adecuados
EXEC [dbo].[USP_InsertarCompra]
    @IdProveedor = 4,  
    @IdEmpleado = 1,    
    @FechaCompra = '2024-12-02', 
    @Observaciones = 'Compra de ejemplo',
    @DetalleCompra = @DetalleCompra, 
    @Result = @Resultado OUTPUT;

-- Mostrar el resultado
SELECT @Resultado AS Resultado;




select * from 




CREATE TYPE TipoDetalleCompra AS TABLE
(
    idProducto INT,
    idCategoria INT,
    idMarca INT,
    idModelo INT,
    IdColor INT,
    IdMedida INT,
    IdVersionn INT,
    PrecioCompra DECIMAL(10,2),
    PrecioVenta DECIMAL(10,2),
    Cantidad INT,
    IdLote INT
);



SELECT * 
FROM sys.objects 
WHERE type = 'P' AND name = 'USP_InsertarCompra';



INSERT INTO EMPLEADO (Nombres, Apellidos, Correo, Direccion, Telefono, Genero, FechaNacimiento, Estado)
VALUES
('Juan', 'Pérez', 'juan.perez@email.com', 'Calle Falsa 123', '555-1234', 'Masculino', '1985-06-15', 1),
('Ana', 'González', 'ana.gonzalez@email.com', 'Avenida Siempre Viva 456', '555-5678', 'Femenino', '1990-11-20', 1),
('Carlos', 'Lopez', 'carlos.lopez@email.com', 'Calle Luna 789', '555-9012', 'Masculino', '1988-03-10', 1),
('María', 'Martínez', 'maria.martinez@email.com', 'Calle Sol 101', '555-3456', 'Femenino', '1992-07-25', 1),
('Luis', 'Rodríguez', 'luis.rodriguez@email.com', 'Calle Mar 202', '555-7890', 'Masculino', '1980-12-30', 0);

select * from EMPLEADO
select * from Proveedor


select * from Lote
select*from CATEGORIA
select * from MODELO
select * from versionn
select * from PRODUCTO
select * from Color
select * from MARCA
select * from Medida
select * from Compra

select * from DetalleCompra
select * from DetalleProducto
select * from Inventario
select * from MovimientoInterno
select * from EMPLEADO
select * from Proveedor

