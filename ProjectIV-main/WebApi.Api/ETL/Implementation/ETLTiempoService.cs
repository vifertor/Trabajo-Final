using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.ETL.Interface;

namespace WebApi.ETL.Implementation
{
    public class ETLTiempoService : IETLTiempoService
    {
        private readonly string _connectionDW;

        public ETLTiempoService(IConfiguration configuration)
        {
            _connectionDW = configuration.GetConnectionString("ConexionDW");
        }

        public async Task<string> GenerarDimTiempoAsync(DateTime fechaInicio, DateTime fechaFin)
        {
            try
            {
                using (SqlConnection connDestino = new SqlConnection(_connectionDW))
                {
                    await connDestino.OpenAsync();

                    // Generar fechas entre fechaInicio y fechaFin
                    DateTime fecha = fechaInicio;
                    while (fecha <= fechaFin)
                    {
                        int año = fecha.Year;
                        int mes = fecha.Month;
                        int día = fecha.Day;
                        string trimestre = ((mes - 1) / 3 + 1).ToString(); // "1", "2", "3" o "4"

                        string queryInsert = @"
                            IF NOT EXISTS (SELECT 1 FROM DimTiempo WHERE Fecha = @Fecha)
                            INSERT INTO DimTiempo (Fecha, Año, Mes, Día, Trimestre)
                            VALUES (@Fecha, @Año, @Mes, @Día, @Trimestre);";

                        using (SqlCommand cmdInsert = new SqlCommand(queryInsert, connDestino))
                        {
                            cmdInsert.Parameters.AddWithValue("@Fecha", fecha);
                            cmdInsert.Parameters.AddWithValue("@Año", año);
                            cmdInsert.Parameters.AddWithValue("@Mes", mes);
                            cmdInsert.Parameters.AddWithValue("@Día", día);
                            cmdInsert.Parameters.AddWithValue("@Trimestre", trimestre);

                            await cmdInsert.ExecuteNonQueryAsync();
                        }

                        fecha = fecha.AddDays(1);
                    }
                }

                return "DimTiempo generada correctamente.";
            }
            catch (Exception ex)
            {
                return $"Error en ETLTiempo: {ex.Message}";
            }
        }
    }
}
