CREATE TABLE [dbo].[Inventario] (
    IdInventario INT IDENTITY(1,1) NOT NULL,       -- ID único del inventario
    IdDetalleProducto INT NOT NULL,                 -- Relación con la tabla DetalleProducto
    IdLote int NOT NULL,                      -- Número de lote
    Stock INT NOT NULL,                             -- Cantidad disponible del producto
    MovimientoId INT NOT NULL,                      -- Relación con la tabla MovimientoInterno
    PRIMARY KEY (IdInventario),                     -- Clave primaria
    FOREIGN KEY (IdDetalleProducto) REFERENCES [dbo].[DetalleProducto](IdDetalleProducto), -- Relación con DetalleProducto
    FOREIGN KEY (MovimientoId) REFERENCES [dbo].[MovimientoInterno](Movimiento_Id), -- Relación con MovimientoInterno
	FOREIGN KEY (IdLote) REFERENCES [dbo].[Lote](IdLote)
);
select * from Lote


ALTER TABLE [dbo].[Inventario]
ADD IdLote INT NOT NULL,
    Stock INT NOT NULL;

-- Agregar las claves foráneas correspondientes
ALTER TABLE [dbo].[Inventario]
ADD CONSTRAINT FK_Inventario_Lote FOREIGN KEY (IdLote) REFERENCES [dbo].[Lote](IdLote);



CREATE PROCEDURE [dbo].[USP_InsertarVenta]
    @IdCliente INT,
    @IdEmpleado INT,
    @Observaciones NVARCHAR(255),
    @DetalleVenta TipoDetalleVenta READONLY,
    @Result BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Result = 1;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insertar en la tabla Venta
        INSERT INTO Venta (IdCliente, IdEmpleado, FechaVenta, Observaciones)
        VALUES (@IdCliente, @IdEmpleado, GETDATE(), @Observaciones);

        DECLARE @IdVenta INT = SCOPE_IDENTITY();
        DECLARE @TotalVenta DECIMAL(18, 2) = 0;

        -- Insertar detalles de la venta
        INSERT INTO DetalleVenta (IdVenta, IdDetalleProducto, Cantidad, PrecioVenta, MontoTotal)
        SELECT 
            @IdVenta, 
            IdDetalleProducto, 
            Cantidad, 
            PrecioVenta, 
            ISNULL(Cantidad * PrecioVenta, 0) AS MontoTotal
        FROM @DetalleVenta;

        -- Calcular el total de la venta
        SELECT @TotalVenta = SUM(MontoTotal)
        FROM DetalleVenta
        WHERE IdVenta = @IdVenta;

        -- Actualizar la venta
        UPDATE Venta
        SET MontoTotal = @TotalVenta
        WHERE IdVenta = @IdVenta;

        -- Variables para inventario
        DECLARE @IdDetalleProducto INT;
        DECLARE @Cantidad INT;
        DECLARE @IdLote INT;
        DECLARE @StockActual INT;

        -- Cursor para detalles de venta
        DECLARE DetalleCursor CURSOR FOR
        SELECT IdDetalleProducto, Cantidad
        FROM @DetalleVenta;

        OPEN DetalleCursor;
        FETCH NEXT FROM DetalleCursor INTO @IdDetalleProducto, @Cantidad;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el lote asociado
            SELECT @IdLote = IdLote
            FROM DetalleProducto
            WHERE IdDetalleProducto = @IdDetalleProducto;

            -- Registrar movimiento
            INSERT INTO MovimientoInterno (Movimiento_Descripcion, Movimiento_Fecha, Movimiento_Lote, Stock, Movimiento_ProductoId)
            VALUES ('Venta de productos', GETDATE(), @IdLote, -@Cantidad, @IdDetalleProducto);

            -- Obtener stock actual
            SELECT @StockActual = Stock
            FROM Inventario
            WHERE IdDetalleProducto = @IdDetalleProducto AND IdLote = @IdLote;

            -- Actualizar inventario
            UPDATE Inventario
            SET Stock = @StockActual - @Cantidad
            WHERE IdDetalleProducto = @IdDetalleProducto AND IdLote = @IdLote;

            FETCH NEXT FROM DetalleCursor INTO @IdDetalleProducto, @Cantidad;
        END;

        CLOSE DetalleCursor;
        DEALLOCATE DetalleCursor;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Result = 0;
    END CATCH;
END;


DECLARE @DetalleVenta TipoDetalleVenta;

-- Insertar datos en el tipo tabla
INSERT INTO @DetalleVenta (IdDetalleProducto, Cantidad, PrecioVenta)
VALUES 
    (1, 2, 100.50), -- Producto 1, 2 unidades, precio 100.50 cada uno
    (2, 23, 200.00); -- Producto 2, 1 unidad, precio 200.00

-- Declarar una variable para recibir el resultado
DECLARE @Resultado BIT;

-- Ejecutar el procedimiento
EXEC USP_InsertarVenta
    @IdCliente = 1,                -- Cliente con ID 1
    @IdEmpleado = 1,               -- Empleado con ID 1
    @Observaciones = N'Prueba de venta',  -- Observaciones
    @DetalleVenta = @DetalleVenta, -- Detalles de la venta
    @Result = @Resultado OUTPUT;   -- Resultado de la operación

-- Mostrar el resultado
SELECT Resultado = @Resultado;


select * from Inventario




INSERT INTO [dbo].[Inventario] (
    IdDetalleProducto, 
    IdLote, 
    Stock, 
    Movimiento_Id
)
VALUES 
    (1, 1, 100, 1), -- Producto 1, Lote 1, Stock inicial 100, Movimiento 1
    (2, 2, 50, 2);  -- Producto 2, Lote 2, Stock inicial 50, Movimiento 2

INSERT INTO [dbo].[MovimientoInterno] (
    Movimiento_Descripcion, 
    Movimiento_Lote, 
    Stock, 
    Movimiento_ProductoId
)
VALUES 
    ('Venta de Producto A', 'Lote001', -10, 1), -- Movimiento de venta de 10 unidades del Producto 1 en Lote001
    ('Ingreso de Producto B', 'Lote002', 50, 2); -- Movimiento de ingreso de 50 unidades del Producto 2 en Lote002
	select * from Inventario



--------------------------------------------------------------

CREATE PROCEDURE USP_ListarVentas
AS
BEGIN
    SET NOCOUNT ON;

    -- Lista las ventas principales
    SELECT 
        v.IdVenta,
        v.IdCliente,
        v.IdEmpleado,
        v.Observaciones,
        v.MontoTotal,
        v.FechaVenta
    FROM 
        dbo.Venta v  -- Asegúrate de usar el esquema correcto
    ORDER BY 
        v.FechaVenta DESC;

    -- Lista los detalles de venta correspondientes
    SELECT 
        d.IdDetalleProducto,
        d.IdVenta,
        d.Cantidad,
        d.PrecioVenta
    FROM 
        dbo.DetalleVenta d  -- Asegúrate de usar el esquema correcto
    ORDER BY 
        d.IdVenta, d.IdDetalleProducto;
END




EXEC USP_ListarVentas;
SELECT * FROM Venta