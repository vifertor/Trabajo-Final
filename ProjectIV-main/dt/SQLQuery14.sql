/*
This query text was retrieved from showplan XML, and may be truncated.
*/

DECLARE @Resultado BIT;

-- Variables de ejemplo
DECLARE @DetalleCompra TipoDetalleCompra;

-- Insertamos un solo registro en la tabla TipoDetalleCompra
INSERT INTO @DetalleCompra (idProducto, idCategoria, idMarca, idModelo, IdColor, IdMedida, IdVersionn, PrecioCompra, PrecioVenta, Cantidad)
VALUES 
    (1, 1, 1, 1, 1, 1, 1, 100.00, 150.00, 10)
;

-- Ejecutamos el procedimiento
EXEC [dbo].[USP_InsertarCompra]
    @IdProveedor = 4,   -- ID del proveedor
    @IdEmpleado = 1,    -- ID del empleado
    @FechaCompra = '2024-12-02', 
    @Observaciones = 'Compra de ejemplo',
    @DetalleCompra = @DetalleCompra, -- Pasamos la variable de tipo tabla
    @Result = @Resultado OUTPUT
;

-- Verificar el resultado
SELECT @Resultado AS Resultado

