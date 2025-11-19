using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;

namespace Implementation
{
    public class EmpleadoService : IEmpleadoService
    {
        private readonly string _connectionString;

        public EmpleadoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AgregarEmpleado(Empleado empleado)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_Empleado_Crear", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };

                command.Parameters.AddWithValue("@Nombres", empleado.Nombres);
                command.Parameters.AddWithValue("@Apellidos", empleado.Apellidos ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@Correo", empleado.Correo);
                command.Parameters.AddWithValue("@Cedula", empleado.Cedula ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@Telefono", empleado.Telefono ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@Genero", empleado.Genero ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@FechaNacimiento", (object)empleado.FechaNacimiento ?? DBNull.Value);
                command.Parameters.AddWithValue("@Estado", empleado.Estado);

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task ActualizarEmpleado(Empleado empleado)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_Empleado_Actualizar", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };

                command.Parameters.AddWithValue("@IdEmpleado", empleado.IdEmpleado);
                command.Parameters.AddWithValue("@Nombres", empleado.Nombres);
                command.Parameters.AddWithValue("@Apellidos", empleado.Apellidos ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@Correo", empleado.Correo);
                command.Parameters.AddWithValue("@Cedula", empleado.Cedula ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@Telefono", empleado.Telefono ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@Genero", empleado.Genero ?? (object)DBNull.Value);
                command.Parameters.AddWithValue("@FechaNacimiento", (object)empleado.FechaNacimiento ?? DBNull.Value);
                command.Parameters.AddWithValue("@Estado", empleado.Estado);

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<Empleado>> ListarEmpleados()
        {
            var empleados = new List<Empleado>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_Empleado_Listar", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };

                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        empleados.Add(new Empleado
                        {
                            IdEmpleado = (int)reader["IdEmpleado"],
                            Nombres = reader["Nombres"].ToString(),
                            Apellidos = reader["Apellidos"]?.ToString(),
                            Correo = reader["Correo"].ToString(),
                            Cedula = reader["Cedula"]?.ToString(),
                            Telefono = reader["Telefono"]?.ToString(),
                            Genero = reader["Genero"]?.ToString(),
                            FechaNacimiento = reader["FechaNacimiento"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["FechaNacimiento"]),
                            Estado = reader["Estado"] != DBNull.Value && Convert.ToBoolean(reader["Estado"]),
                            FechaRegistro = reader["FechaRegistro"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["FechaRegistro"])
                        });
                    }
                }
            }

            return empleados;
        }

        public async Task<Empleado> MostrarEmpleado(int idEmpleado)
        {
            Empleado empleado = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_Empleado_ObtenerPorId", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        empleado = new Empleado
                        {
                            IdEmpleado = (int)reader["IdEmpleado"],
                            Nombres = reader["Nombres"].ToString(),
                            Apellidos = reader["Apellidos"]?.ToString(),
                            Correo = reader["Correo"].ToString(),
                            Cedula = reader["Cedula"]?.ToString(),
                            Telefono = reader["Telefono"]?.ToString(),
                            Genero = reader["Genero"]?.ToString(),
                            FechaNacimiento = reader["FechaNacimiento"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["FechaNacimiento"]),
                            Estado = reader["Estado"] != DBNull.Value && Convert.ToBoolean(reader["Estado"]),
                            FechaRegistro = reader["FechaRegistro"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["FechaRegistro"])
                        };
                    }
                }
            }

            return empleado;
        }

        public async Task EliminarEmpleado(int idEmpleado)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_Empleado_Eliminar", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task ReactivarEmpleado(int idEmpleado)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_Empleado_Reactivar", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<Empleado>> ListarEmpleadosInactivos()
        {
            var empleados = new List<Empleado>();

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (var command = new SqlCommand("sp_GetEmpleadosInactivos", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            empleados.Add(new Empleado
                            {
                                IdEmpleado        = (int)reader["IdEmpleado"],
                                Nombres           = reader["Nombres"].ToString(),
                                Apellidos         = reader["Apellidos"]?.ToString(),
                                Correo            = reader["Correo"].ToString(),
                                Cedula            = reader["Cedula"]?.ToString(),
                                Telefono          = reader["Telefono"]?.ToString(),
                                Genero            = reader["Genero"]?.ToString(),
                                FechaNacimiento   = reader["FechaNacimiento"] == DBNull.Value 
                                                        ? (DateTime?)null 
                                                        : (DateTime)reader["FechaNacimiento"],
                                Estado            = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaRegistro     = reader["FechaRegistro"] == DBNull.Value 
                                                        ? (DateTime?)null 
                                                        : (DateTime)reader["FechaRegistro"]
                            });
                        }
                    }
                }
            }

            return empleados;
        }

        public async Task<Empleado> ObtenerEmpleadoInactivoPorId(int idEmpleado)
        {
            Empleado empleado = null;

            using (var connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (var command = new SqlCommand("sp_GetEmpleadoByIdInactivo", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            empleado = new Empleado
                            {
                                IdEmpleado        = (int)reader["IdEmpleado"],
                                Nombres           = reader["Nombres"].ToString(),
                                Apellidos         = reader["Apellidos"]?.ToString(),
                                Correo            = reader["Correo"].ToString(),
                                Cedula            = reader["Cedula"]?.ToString(),
                                Telefono          = reader["Telefono"]?.ToString(),
                                Genero            = reader["Genero"]?.ToString(),
                                FechaNacimiento   = reader["FechaNacimiento"] == DBNull.Value 
                                                        ? (DateTime?)null 
                                                        : (DateTime)reader["FechaNacimiento"],
                                Estado            = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaRegistro     = reader["FechaRegistro"] == DBNull.Value 
                                                        ? (DateTime?)null 
                                                        : (DateTime)reader["FechaRegistro"]
                            };
                        }
                    }
                }
            }

            return empleado;
        }
    }
}