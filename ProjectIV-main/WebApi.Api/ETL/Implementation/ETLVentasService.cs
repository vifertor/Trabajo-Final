using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.ETL.Interface;
using WebApi.Models.ETL;

namespace WebApi.ETL.Implementation
{
    public class ETLVentasService : IETLVentasService
    {
        private readonly string _connectionOLTP;
        private readonly string _connectionDW;

        public ETLVentasService(IConfiguration configuration)
        {
            _connectionOLTP = configuration.GetConnectionString("DefaultConnection");
            _connectionDW = configuration.GetConnectionString("ConexionDW");
        }

        // Método existente de transferencia
        public async Task<string> TransferirHechosVentasAsync()
        {
            try
            {
                using (SqlConnection connOrigen = new SqlConnection(_connectionOLTP))
                using (SqlConnection connDestino = new SqlConnection(_connectionDW))
                {
                    await connOrigen.OpenAsync();
                    await connDestino.OpenAsync();

                    // Obtener todas las ventas y sus detalles
                    string querySelect = @"
                        SELECT dv.IdDetalleVenta, v.IdVenta, v.Nomb_Cliente, v.IdEmpleado, v.FechaVenta,
                               i.Id_DetalleProducto, dv.Cantidad, dv.PrecioVenta
                        FROM DetalleVenta dv
                        INNER JOIN Venta v ON v.IdVenta = dv.IdVenta
                        INNER JOIN Inventario i ON i.IdInventario = dv.Inventario
                        WHERE dv.Estado = 1 AND v.Estado = 1;";

                    using (SqlCommand cmdSelect = new SqlCommand(querySelect, connOrigen))
                    using (SqlDataReader reader = await cmdSelect.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            int idVenta = Convert.ToInt32(reader["IdVenta"]);
                            int idDetalleProducto = Convert.ToInt32(reader["Id_DetalleProducto"]);
                            string nombreCliente = reader["Nomb_Cliente"].ToString();
                            int idEmpleado = Convert.ToInt32(reader["IdEmpleado"]);
                            DateTime fecha = Convert.ToDateTime(reader["FechaVenta"]).Date;
                            int cantidad = Convert.ToInt32(reader["Cantidad"]);
                            double precioUnitario = Convert.ToDouble(reader["PrecioVenta"]);
                            double totalVenta = cantidad * precioUnitario;

                            // Obtener IdCliente desde DimCliente
                            string queryCliente = @"SELECT IdCliente FROM DimCliente WHERE NombreCliente = @NombreCliente";
                            int idCliente = 0;
                            using (SqlCommand cmdCliente = new SqlCommand(queryCliente, connDestino))
                            {
                                cmdCliente.Parameters.AddWithValue("@NombreCliente", nombreCliente);
                                var result = await cmdCliente.ExecuteScalarAsync();
                                idCliente = result != null ? Convert.ToInt32(result) : 0;
                            }

                            if (idCliente == 0) continue;

                            // Insertar en HechosVentas si no existe
                            string queryInsert = @"
                                IF NOT EXISTS (SELECT 1 FROM HechosVentas 
                                               WHERE IdVenta = @IdVenta AND IdDetalleProducto = @IdDetalleProducto)
                                INSERT INTO HechosVentas 
                                (IdVenta, IdDetalleProducto, IdCliente, IdEmpleado, Fecha, TotalVenta, CantidadVendida, PrecioUnitario)
                                VALUES (@IdVenta, @IdDetalleProducto, @IdCliente, @IdEmpleado, @Fecha, @TotalVenta, @CantidadVendida, @PrecioUnitario);";

                            using (SqlCommand cmdInsert = new SqlCommand(queryInsert, connDestino))
                            {
                                cmdInsert.Parameters.AddWithValue("@IdVenta", idVenta);
                                cmdInsert.Parameters.AddWithValue("@IdDetalleProducto", idDetalleProducto);
                                cmdInsert.Parameters.AddWithValue("@IdCliente", idCliente);
                                cmdInsert.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                                cmdInsert.Parameters.AddWithValue("@Fecha", fecha);
                                cmdInsert.Parameters.AddWithValue("@TotalVenta", totalVenta);
                                cmdInsert.Parameters.AddWithValue("@CantidadVendida", cantidad);
                                cmdInsert.Parameters.AddWithValue("@PrecioUnitario", precioUnitario);

                                await cmdInsert.ExecuteNonQueryAsync();
                            }
                        }
                    }
                }

                return "Transferencia de HechosVentas completada correctamente.";
            }
            catch (Exception ex)
            {
                return $"Error en ETLVentas: {ex.Message}";
            }
        }

        // NUEVO: Obtener todos los registros de HechosVentas
        public async Task<List<HechosVentas>> ObtenerHechosVentasAsync()
        {
            var lista = new List<HechosVentas>();

            try
            {
                using (SqlConnection connDestino = new SqlConnection(_connectionDW))
                {
                    await connDestino.OpenAsync();
                    string query = "SELECT * FROM HechosVentas";

                    using (SqlCommand cmd = new SqlCommand(query, connDestino))
                    using (SqlDataReader reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            lista.Add(new HechosVentas
                            {
                                IdVenta = Convert.ToInt32(reader["IdVenta"]),
                                IdDetalleProducto = Convert.ToInt32(reader["IdDetalleProducto"]),
                                IdCliente = Convert.ToInt32(reader["IdCliente"]),
                                IdEmpleado = Convert.ToInt32(reader["IdEmpleado"]),
                                Fecha = Convert.ToDateTime(reader["Fecha"]),
                                TotalVenta = Convert.ToDouble(reader["TotalVenta"]),
                                CantidadVendida = Convert.ToInt32(reader["CantidadVendida"]),
                                PrecioUnitario = Convert.ToDouble(reader["PrecioUnitario"])
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // opcional: loguear el error
            }

            return lista;
        }
    }
}
