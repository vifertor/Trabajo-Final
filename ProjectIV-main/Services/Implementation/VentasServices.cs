using WebApi.Services.Interface;
using WebApi.Model;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;

namespace WebApi.Services.Implementation
{
    public class VentaService : IVentaService
{
    private readonly string _connectionString;

    public VentaService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    // Registrar venta maestro-detalle con precio tomado del inventario
public async Task<int> RegistrarVentaAsync(RegistrarVentaRequest venta)
{
    using SqlConnection conn = new(_connectionString);
    await conn.OpenAsync();

    using SqlTransaction tran = conn.BeginTransaction();
    try
    {
        // Insertar cabecera de venta (MontoTotal se pondrá después)
        string insertVentaQuery = @"
            INSERT INTO Venta (Nomb_Cliente, IdEmpleado, FechaVenta, Observaciones, MontoTotal, Estado)
            VALUES (@Nomb_Cliente, @IdEmpleado, @FechaVenta, @Observaciones, 0, 1);
            SELECT CAST(SCOPE_IDENTITY() AS INT);";

        using SqlCommand cmdVenta = new(insertVentaQuery, conn, tran);
        cmdVenta.Parameters.AddWithValue("@Nomb_Cliente", venta.Nomb_Cliente);
        cmdVenta.Parameters.AddWithValue("@IdEmpleado", venta.IdEmpleado);
        cmdVenta.Parameters.AddWithValue("@FechaVenta", DateTime.Now);
        cmdVenta.Parameters.AddWithValue("@Observaciones", (object)venta.Observaciones ?? DBNull.Value);

        int idVenta = (int)await cmdVenta.ExecuteScalarAsync();
        decimal montoTotalVenta = 0;

        foreach (var det in venta.DetallesVenta)
        {
            // Validar stock
            string checkStockQuery = "SELECT Cantidad, PrecioUnitario FROM Inventario WHERE IdInventario = @IdInventario;";
            using SqlCommand cmdStock = new(checkStockQuery, conn, tran);
            cmdStock.Parameters.AddWithValue("@IdInventario", det.IdInventario);

            using SqlDataReader reader = await cmdStock.ExecuteReaderAsync();
            if (!reader.Read())
                throw new Exception($"Inventario no encontrado para IdInventario {det.IdInventario}");

            int stockActual = reader.GetInt32(reader.GetOrdinal("Cantidad"));
            decimal precioUnitario = reader.GetDecimal(reader.GetOrdinal("PrecioUnitario"));
            reader.Close();

            if (stockActual < det.Cantidad)
                throw new Exception($"Stock insuficiente para IdInventario {det.IdInventario}");

            decimal montoDetalle = precioUnitario * det.Cantidad;

            // Insertar detalle de venta usando precio desde inventario
            string insertDetalleQuery = @"
                INSERT INTO DetalleVenta (IdVenta, Inventario, Cantidad, PrecioVenta, MontoTotal, Estado)
                VALUES (@IdVenta, @IdInventario, @Cantidad, @PrecioVenta, @MontoTotal, 1);";

            using SqlCommand cmdDetalle = new(insertDetalleQuery, conn, tran);
            cmdDetalle.Parameters.AddWithValue("@IdVenta", idVenta);
            cmdDetalle.Parameters.AddWithValue("@IdInventario", det.IdInventario);
            cmdDetalle.Parameters.AddWithValue("@Cantidad", det.Cantidad);
            cmdDetalle.Parameters.AddWithValue("@PrecioVenta", precioUnitario);
            cmdDetalle.Parameters.AddWithValue("@MontoTotal", montoDetalle);
            await cmdDetalle.ExecuteNonQueryAsync();

            // Actualizar inventario
            string updateStockQuery = "UPDATE Inventario SET Cantidad = Cantidad - @Cantidad WHERE IdInventario = @IdInventario;";
            using SqlCommand cmdUpdateStock = new(updateStockQuery, conn, tran);
            cmdUpdateStock.Parameters.AddWithValue("@Cantidad", det.Cantidad);
            cmdUpdateStock.Parameters.AddWithValue("@IdInventario", det.IdInventario);
            await cmdUpdateStock.ExecuteNonQueryAsync();

            montoTotalVenta += montoDetalle;
        }

        // Actualizar monto total de venta
        string updateVentaMonto = "UPDATE Venta SET MontoTotal = @MontoTotal WHERE IdVenta = @IdVenta;";
        using SqlCommand cmdUpdateMonto = new(updateVentaMonto, conn, tran);
        cmdUpdateMonto.Parameters.AddWithValue("@MontoTotal", montoTotalVenta);
        cmdUpdateMonto.Parameters.AddWithValue("@IdVenta", idVenta);
        await cmdUpdateMonto.ExecuteNonQueryAsync();

        tran.Commit();
        return idVenta;
    }
    catch
    {
        tran.Rollback();
        throw;
    }
}

    // Obtener ventas (activas o por id)
    public async Task<List<VentaModel>> ObtenerVentasAsync(int? idVenta = null)
    {
        List<VentaModel> ventas = new();
        using SqlConnection conn = new(_connectionString);
        await conn.OpenAsync();

        string query = @"
            SELECT V.IdVenta, V.Nomb_Cliente, V.IdEmpleado, E.Nombres, E.Apellidos, V.FechaVenta, V.Observaciones, V.MontoTotal, V.Estado
            FROM Venta V
            INNER JOIN EMPLEADO E ON V.IdEmpleado = E.IdEmpleado
            WHERE (@IdVenta IS NULL OR V.IdVenta = @IdVenta)
            ORDER BY V.FechaVenta DESC;";

        using SqlCommand cmd = new(query, conn);
        cmd.Parameters.AddWithValue("@IdVenta", idVenta ?? (object)DBNull.Value);

        using SqlDataReader reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            ventas.Add(new VentaModel
            {
                IdVenta = reader.GetInt32(0),
                Nomb_Cliente = reader.GetString(1),
                IdEmpleado = reader.GetInt32(2),
                NombreEmpleado = reader.GetString(3),
                ApellidoEmpleado = reader.GetString(4),
                FechaVenta = reader.GetDateTime(5),
                Observaciones = reader.IsDBNull(6) ? null : reader.GetString(6),
                MontoTotal = reader.GetDecimal(7),
                EstadoVenta = reader.GetBoolean(8)
            });
        }

        return ventas;
    }

    // Obtener detalles de venta
    public async Task<List<DetalleVentaConNombresModel>> ObtenerDetalleVentaAsync(int idVenta)
    {
        List<DetalleVentaConNombresModel> detalles = new();
        using SqlConnection conn = new(_connectionString);
        await conn.OpenAsync();

        string query = @"
            SELECT dv.IdVenta, dp.Id_Producto, p.Nombre, dp.Marca_Id, m.Marca_Nombre AS NombreMarca, dv.Cantidad, dv.PrecioVenta, (dv.Cantidad * dv.PrecioVenta) AS MontoTotalDetalle
            FROM DetalleVenta dv
            INNER JOIN Inventario i ON dv.Inventario = i.IdInventario
            INNER JOIN DetalleProducto dp ON i.Id_DetalleProducto = dp.Id_DetalleProducto
            INNER JOIN Producto p ON dp.Id_Producto = p.IdProducto
            INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
            WHERE dv.IdVenta = @IdVenta;";

        using SqlCommand cmd = new(query, conn);
        cmd.Parameters.AddWithValue("@IdVenta", idVenta);

        using SqlDataReader reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            detalles.Add(new DetalleVentaConNombresModel
            {
                IdVenta = reader.GetInt32(0),
                Id_Producto = reader.GetInt32(1),
                NombreProducto = reader.GetString(2),
                Marca_Id = reader.GetInt32(3),
                NombreMarca = reader.GetString(4),
                Cantidad = reader.GetInt32(5),
                PrecioVenta = reader.GetDecimal(6),
                MontoTotalDetalle = reader.GetDecimal(7)
            });
        }

        return detalles;
    }

    // Actualizar venta (cabecera)
    public async Task<bool> ActualizarVentaAsync(VentaModel venta)
    {
        using SqlConnection conn = new(_connectionString);
        await conn.OpenAsync();

        string query = @"
            UPDATE Venta
            SET Nomb_Cliente = @Nomb_Cliente,
                IdEmpleado = @IdEmpleado,
                Observaciones = @Observaciones,
                Estado = @Estado
            WHERE IdVenta = @IdVenta;";

        using SqlCommand cmd = new(query, conn);
        cmd.Parameters.AddWithValue("@IdVenta", venta.IdVenta);
        cmd.Parameters.AddWithValue("@Nomb_Cliente", venta.Nomb_Cliente);
        cmd.Parameters.AddWithValue("@IdEmpleado", venta.IdEmpleado);
        cmd.Parameters.AddWithValue("@Observaciones", (object)venta.Observaciones ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Estado", venta.EstadoVenta);

        int rows = await cmd.ExecuteNonQueryAsync();
        return rows > 0;
    }

    // Anular venta
    public async Task<bool> AnularVentaAsync(int idVenta)
    {
        using SqlConnection conn = new(_connectionString);
        await conn.OpenAsync();
        using SqlTransaction tran = conn.BeginTransaction();

        try
        {
            // Validar venta activa
            string validarQuery = "SELECT Estado FROM Venta WHERE IdVenta = @IdVenta;";
            using SqlCommand cmdVal = new(validarQuery, conn, tran);
            cmdVal.Parameters.AddWithValue("@IdVenta", idVenta);
            var estado = await cmdVal.ExecuteScalarAsync();
            if (estado == null || !(bool)estado)
                throw new Exception($"Venta {idVenta} no existe o ya está anulada.");

            // Anular venta
            string anularVentaQuery = "UPDATE Venta SET Estado = 0 WHERE IdVenta = @IdVenta;";
            using SqlCommand cmdAnular = new(anularVentaQuery, conn, tran);
            cmdAnular.Parameters.AddWithValue("@IdVenta", idVenta);
            await cmdAnular.ExecuteNonQueryAsync();

            // Revertir inventario y anular detalles
            string detallesQuery = "SELECT IdDetalleVenta, Inventario, Cantidad FROM DetalleVenta WHERE IdVenta = @IdVenta AND Estado = 1;";
            using SqlCommand cmdDetalles = new(detallesQuery, conn, tran);
            cmdDetalles.Parameters.AddWithValue("@IdVenta", idVenta);
            using SqlDataReader reader = await cmdDetalles.ExecuteReaderAsync();

            var detalles = new List<(int idDetalle, int idInventario, int cantidad)>();
            while (await reader.ReadAsync())
            {
                detalles.Add((reader.GetInt32(0), reader.GetInt32(1), reader.GetInt32(2)));
            }
            reader.Close();

            foreach (var d in detalles)
            {
                string updateStock = "UPDATE Inventario SET Cantidad = Cantidad + @Cantidad WHERE IdInventario = @IdInventario;";
                using SqlCommand cmdUpdStock = new(updateStock, conn, tran);
                cmdUpdStock.Parameters.AddWithValue("@Cantidad", d.cantidad);
                cmdUpdStock.Parameters.AddWithValue("@IdInventario", d.idInventario);
                await cmdUpdStock.ExecuteNonQueryAsync();

                string updateDetalle = "UPDATE DetalleVenta SET Estado = 0 WHERE IdDetalleVenta = @IdDetalle;";
                using SqlCommand cmdUpdDet = new(updateDetalle, conn, tran);
                cmdUpdDet.Parameters.AddWithValue("@IdDetalle", d.idDetalle);
                await cmdUpdDet.ExecuteNonQueryAsync();
            }

            tran.Commit();
            return true;
        }
        catch
        {
            tran.Rollback();
            throw;
        }
    }

    // Reactivar venta
    public async Task<bool> ReactivarVentaAsync(int idVenta)
    {
        using SqlConnection conn = new(_connectionString);
        await conn.OpenAsync();
        string query = "UPDATE Venta SET Estado = 1 WHERE IdVenta = @IdVenta;";
        using SqlCommand cmd = new(query, conn);
        cmd.Parameters.AddWithValue("@IdVenta", idVenta);
        int rows = await cmd.ExecuteNonQueryAsync();
        return rows > 0;
    }

    // Obtener ventas inactivas
    public async Task<List<VentaModel>> ObtenerVentasInactivasAsync()
    {
        List<VentaModel> ventas = new();
        using SqlConnection conn = new(_connectionString);
        await conn.OpenAsync();

        string query = "SELECT IdVenta, Nomb_Cliente, IdEmpleado, FechaVenta, Observaciones, MontoTotal, Estado FROM Venta WHERE Estado = 0;";
        using SqlCommand cmd = new(query, conn);
        using SqlDataReader reader = await cmd.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            ventas.Add(new VentaModel
            {
                IdVenta = reader.GetInt32(0),
                Nomb_Cliente = reader.GetString(1),
                IdEmpleado = reader.GetInt32(2),
                FechaVenta = reader.GetDateTime(3),
                Observaciones = reader.IsDBNull(4) ? null : reader.GetString(4),
                MontoTotal = reader.GetDecimal(5),
                EstadoVenta = reader.GetBoolean(6)
            });
        }

        return ventas;
    }
}
}
