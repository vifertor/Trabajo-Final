using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace WebApi.ETL.Implementation
{
    public class ETLProductoService
    {
        private readonly string _connectionOLTP;
        private readonly string _connectionDW;

        public ETLProductoService(IConfiguration configuration)
        {
            _connectionOLTP = configuration.GetConnectionString("DefaultConnection");
            _connectionDW = configuration.GetConnectionString("ConexionDW");
        }

        public async Task<string> TransferirProductosAsync()
        {
            try
            {
                using (SqlConnection connOrigen = new SqlConnection(_connectionOLTP))
                using (SqlConnection connDestino = new SqlConnection(_connectionDW))
                {
                    await connOrigen.OpenAsync();
                    await connDestino.OpenAsync();

                    // 1️⃣ Seleccionar todos los DetalleProducto activos
                    string querySelect = @"
                        SELECT dp.Id_DetalleProducto, p.Nombre AS NombreProducto,
                               m.Marca_Nombre AS Marca, mo.Nombre AS Modelo,
                               c.NombreCategoria AS Categoria
                        FROM DetalleProducto dp
                        INNER JOIN PRODUCTO p ON p.IdProducto = dp.Id_Producto
                        INNER JOIN Marca m ON m.Marca_Id = dp.Marca_Id
                        INNER JOIN MODELO mo ON mo.IdModelo = dp.Id_Modelo
                        INNER JOIN CATEGORIA c ON c.IdCategoria = dp.Id_Categoria
                        WHERE dp.Estado = 1;";

                    using (SqlCommand cmdSelect = new SqlCommand(querySelect, connOrigen))
                    using (SqlDataReader reader = await cmdSelect.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            int idDetalleProducto = Convert.ToInt32(reader["Id_DetalleProducto"]);
                            string nombreProducto = reader["NombreProducto"].ToString();
                            string marca = reader["Marca"].ToString();
                            string modelo = reader["Modelo"].ToString();
                            string categoria = reader["Categoria"].ToString();

                            // 2️⃣ Insertar en DimProducto si no existe
                            string queryInsert = @"
                                IF NOT EXISTS (SELECT 1 FROM DimProducto WHERE IdDetalleProducto = @IdDetalleProducto)
                                INSERT INTO DimProducto (IdDetalleProducto, NombreProducto, Marca, Modelo, Categoria)
                                VALUES (@IdDetalleProducto, @NombreProducto, @Marca, @Modelo, @Categoria);";

                            using (SqlCommand cmdInsert = new SqlCommand(queryInsert, connDestino))
                            {
                                cmdInsert.Parameters.AddWithValue("@IdDetalleProducto", idDetalleProducto);
                                cmdInsert.Parameters.AddWithValue("@NombreProducto", nombreProducto);
                                cmdInsert.Parameters.AddWithValue("@Marca", marca);
                                cmdInsert.Parameters.AddWithValue("@Modelo", modelo);
                                cmdInsert.Parameters.AddWithValue("@Categoria", categoria);

                                await cmdInsert.ExecuteNonQueryAsync();
                            }
                        }
                    }
                }

                return "Transferencia de productos completada correctamente.";
            }
            catch (Exception ex)
            {
                return $"Error en ETLProducto: {ex.Message}";
            }
        }
    }
}
