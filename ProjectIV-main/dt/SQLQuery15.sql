CREATE TYPE TipoDetalleVenta AS TABLE
(
    IdDetalleProducto INT,     -- Id del producto en el detalle
    Cantidad INT,              -- Cantidad de productos vendidos
    PrecioVenta DECIMAL(18, 2) -- Precio de venta del producto
);
GO




CREATE PROCEDURE [dbo].[USP_InsertarVenta]
    @IdCliente INT,                -- ID del cliente
    @IdEmpleado INT,               -- ID del empleado que registra la venta
    @Observaciones NVARCHAR(255),  -- Observaciones de la venta
    @DetalleVenta TipoDetalleVenta READONLY, -- Tipo tabla para los detalles de la venta
    @Result BIT OUTPUT             -- Resultado de la operación
AS
BEGIN
    SET NOCOUNT ON;
    SET @Result = 1;  -- Inicialmente asume que la operación fue exitosa

    -- Comenzamos la transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insertar en la tabla Venta (maestro) con la fecha actual automáticamente
        INSERT INTO Venta (IdCliente, IdEmpleado, FechaVenta, Observaciones)
        VALUES (@IdCliente, @IdEmpleado, GETDATE(), @Observaciones); -- Usamos GETDATE() para obtener la fecha actual

        -- Obtener el IdVenta recién insertado
        DECLARE @IdVenta INT = SCOPE_IDENTITY();
        DECLARE @TotalVenta DECIMAL(18, 2) = 0;  -- Declaramos la variable para el total

        -- Insertar los detalles de la venta (detalle), calculando el MontoTotal para cada producto
        INSERT INTO DetalleVenta (IdVenta, IdDetalleProducto, Cantidad, PrecioVenta, MontoTotal)
        SELECT 
            @IdVenta, 
            IdDetalleProducto, 
            Cantidad, 
            PrecioVenta, 
            CASE 
                WHEN Cantidad IS NULL THEN 0
                WHEN PrecioVenta IS NULL THEN 0
                ELSE Cantidad * PrecioVenta 
            END AS MontoTotal
        FROM @DetalleVenta;

        -- Calcular el total de la venta sumando los montos de todos los detalles
        SELECT @TotalVenta = SUM(MontoTotal)
        FROM DetalleVenta
        WHERE IdVenta = @IdVenta;

        -- Actualizar el campo MontoTotal en la tabla Venta con el total calculado
        UPDATE Venta
        SET MontoTotal = @TotalVenta
        WHERE IdVenta = @IdVenta;

        -- Variables para registrar y actualizar el inventario
        DECLARE @IdDetalleProducto INT;
        DECLARE @Cantidad INT;
        DECLARE @StockActual INT;
        DECLARE @IdLote INT;

        -- Cursor para recorrer los detalles de venta
        DECLARE DetalleCursor CURSOR FOR
        SELECT IdDetalleProducto, Cantidad
        FROM @DetalleVenta;

        OPEN DetalleCursor;
        FETCH NEXT FROM DetalleCursor INTO @IdDetalleProducto, @Cantidad;

        -- Recorrer todos los detalles de la venta
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el lote asociado al producto
            SELECT @IdLote = DP.IdLote
            FROM DetalleProducto DP
            WHERE DP.IdDetalleProducto = @IdDetalleProducto;

            -- Registrar el movimiento en la bitácora de movimientos (MovimientoInterno)
            INSERT INTO MovimientoInterno (Movimiento_Descripcion, Movimiento_Fecha, Movimiento_Lote, Stock, Movimiento_ProductoId)
            VALUES ('Venta de productos', GETDATE(), @IdLote, -@Cantidad, @IdDetalleProducto); -- Disminuir el stock

            -- Obtener el stock actual del inventario
            SELECT @StockActual = Stock
            FROM Inventario
            WHERE IdDetalleProducto = @IdDetalleProducto AND IdLote = @IdLote;

            -- Actualizar el inventario, restando la cantidad vendida
            UPDATE Inventario
            SET Stock = @StockActual - @Cantidad
            WHERE IdDetalleProducto = @IdDetalleProducto AND IdLote = @IdLote;

            FETCH NEXT FROM DetalleCursor INTO @IdDetalleProducto, @Cantidad;
        END;

        CLOSE DetalleCursor;
        DEALLOCATE DetalleCursor;

        -- Confirmar la transacción
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        -- En caso de error, revertir la transacción
        ROLLBACK TRANSACTION;
        SET @Result = 0; -- Indicar que hubo un error
    END CATCH;
END;



DECLARE @DetalleVenta TipoDetalleVenta;

-- Insertar detalles de venta
INSERT INTO @DetalleVenta (IdDetalleProducto, Cantidad, PrecioVenta)
VALUES 
    (1, 1, 100),  -- Producto con ID 1, Cantidad 2, Precio 100
    (2, 1, 200);  -- Producto con ID 2, Cantidad 1, Precio 150

DECLARE @Result BIT;

-- Ejecutar el procedimiento
EXEC [dbo].[USP_InsertarVenta]
    @IdCliente = 1,
    @IdEmpleado = 2,
    @Observaciones = 'Venta dd',
    @DetalleVenta = @DetalleVenta,
    @Result = @Result OUTPUT;

-- Verificar el resultado
SELECT @Result AS Resultado;














select * from DetalleProducto
select * from Inventario
select * from DetalleVenta
select * from MovimientoInterno
select * from Venta
select * from EMPLEADO
select * from CLIENTE