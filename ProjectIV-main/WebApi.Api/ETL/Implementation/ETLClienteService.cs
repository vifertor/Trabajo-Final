using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace WebApi.ETL.Implementation
{
    public class ETLClienteService
    {
        private readonly string _connectionOLTP;
        private readonly string _connectionDW;

        public ETLClienteService(IConfiguration configuration)
        {
            _connectionOLTP = configuration.GetConnectionString("DefaultConnection");
            _connectionDW = configuration.GetConnectionString("ConexionDW");
        }

        public async Task<string> TransferirClientesAsync()
        {
            try
            {
                using (SqlConnection connOrigen = new SqlConnection(_connectionOLTP))
                using (SqlConnection connDestino = new SqlConnection(_connectionDW))
                {
                    await connOrigen.OpenAsync();
                    await connDestino.OpenAsync();

                    // 1️⃣ Obtener nombres de clientes únicos desde la tabla Venta
                    string querySelect = @"
                        SELECT DISTINCT Nomb_Cliente 
                        FROM dbo.Venta
                        WHERE Nomb_Cliente IS NOT NULL AND LTRIM(RTRIM(Nomb_Cliente)) <> ''";

                    using (SqlCommand cmdSelect = new SqlCommand(querySelect, connOrigen))
                    using (SqlDataReader reader = await cmdSelect.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            string nombreCliente = reader["Nomb_Cliente"].ToString();

                            // 2️⃣ Insertar el cliente en el Data Mart si no existe
                            string queryInsert = @"
                                IF NOT EXISTS (SELECT 1 FROM DimCliente WHERE NombreCliente = @NombreCliente)
                                INSERT INTO DimCliente (NombreCliente)
                                VALUES (@NombreCliente);";

                            using (SqlCommand cmdInsert = new SqlCommand(queryInsert, connDestino))
                            {
                                cmdInsert.Parameters.AddWithValue("@NombreCliente", nombreCliente);
                                await cmdInsert.ExecuteNonQueryAsync();
                            }
                        }
                    }
                }

                return "Transferencia de clientes completada correctamente.";
            }
            catch (Exception ex)
            {
                return $"Error en ETL: {ex.Message}";
            }
        }
    }
}
