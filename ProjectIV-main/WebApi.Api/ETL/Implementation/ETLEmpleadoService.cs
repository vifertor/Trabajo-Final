using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.ETL.Interface;

namespace WebApi.ETL.Implementation
{
    public class ETLEmpleadoService : IETLEmpleadoService
    {
        private readonly string _connectionOLTP;
        private readonly string _connectionDW;

        public ETLEmpleadoService(IConfiguration configuration)
        {
            _connectionOLTP = configuration.GetConnectionString("DefaultConnection");
            _connectionDW = configuration.GetConnectionString("ConexionDW");
        }

        public async Task<string> TransferirEmpleadosAsync()
        {
            try
            {
                using (SqlConnection connOrigen = new SqlConnection(_connectionOLTP))
                using (SqlConnection connDestino = new SqlConnection(_connectionDW))
                {
                    await connOrigen.OpenAsync();
                    await connDestino.OpenAsync();

                    // 1️⃣ Obtener empleados activos
                    string querySelect = @"
                        SELECT IdEmpleado, Nombres, Apellidos, Telefono, Correo
                        FROM EMPLEADO
                        WHERE Estado = 1;";

                    using (SqlCommand cmdSelect = new SqlCommand(querySelect, connOrigen))
                    using (SqlDataReader reader = await cmdSelect.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            int idEmpleado = Convert.ToInt32(reader["IdEmpleado"]);
                            string nombreEmpleado = reader["Nombres"].ToString() + " " + reader["Apellidos"].ToString();
                            string telefono = reader["Telefono"]?.ToString() ?? "";
                            string correo = reader["Correo"]?.ToString() ?? "";
                            string direccion = ""; // No hay campo dirección en OLTP, puede quedar vacío o mapear desde otra tabla si existe

                            // 2️⃣ Insertar en DimEmpleado si no existe
                            string queryInsert = @"
                                IF NOT EXISTS (SELECT 1 FROM DimEmpleado WHERE IdEmpleado = @IdEmpleado)
                                INSERT INTO DimEmpleado (IdEmpleado, NombreEmpleado, Telefono, Correo, Direccion)
                                VALUES (@IdEmpleado, @NombreEmpleado, @Telefono, @Correo, @Direccion);";

                            using (SqlCommand cmdInsert = new SqlCommand(queryInsert, connDestino))
                            {
                                cmdInsert.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                                cmdInsert.Parameters.AddWithValue("@NombreEmpleado", nombreEmpleado);
                                cmdInsert.Parameters.AddWithValue("@Telefono", telefono);
                                cmdInsert.Parameters.AddWithValue("@Correo", correo);
                                cmdInsert.Parameters.AddWithValue("@Direccion", direccion);

                                await cmdInsert.ExecuteNonQueryAsync();
                            }
                        }
                    }
                }

                return "Transferencia de empleados completada correctamente.";
            }
            catch (Exception ex)
            {
                return $"Error en ETLEmpleado: {ex.Message}";
            }
        }
    }
}
