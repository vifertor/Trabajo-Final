using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
// Implementation/ModeloService.cs
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;

namespace Implementation
{
    public class ModeloService: IModeloService
    {
        private readonly string _connectionString;

        public ModeloService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AgregarModelo(Modelo modelo)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_MODELO", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "INSERT");
                    command.Parameters.AddWithValue("@Nombre", modelo.Nombre);
                    command.Parameters.AddWithValue("@Descripcion", (object)modelo.Descripcion ?? DBNull.Value);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task ActualizarModelo(Modelo modelo)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_MODELO", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "UPDATE");
                    command.Parameters.AddWithValue("@IdModelo", modelo.IdModelo);
                    command.Parameters.AddWithValue("@Nombre", modelo.Nombre);
                    command.Parameters.AddWithValue("@Descripcion", (object)modelo.Descripcion ?? DBNull.Value);
                    command.Parameters.AddWithValue("@Estado", modelo.Estado);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task EliminarModelo(int id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_MODELO", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "DELETE");
                    command.Parameters.AddWithValue("@IdModelo", id);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<List<Modelo>> ListarModelos()
        {
            var modelos = new List<Modelo>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_MODELO", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "GETALL");

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            modelos.Add(new Modelo
                            {
                                IdModelo      = (int)reader["IdModelo"],
                                Nombre        = reader["Nombre"].ToString(),
                                Descripcion   = reader["Descripcion"]?.ToString(),
                                Estado        = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaRegistro = (DateTime)reader["FechaRegistro"]
                            });
                        }
                    }
                }
            }

            return modelos;
        }

        public async Task<Modelo> MostrarModelo(int id)
        {
            Modelo modelo = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_MODELO", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "GETBYID");
                    command.Parameters.AddWithValue("@IdModelo", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            modelo = new Modelo
                            {
                                IdModelo      = (int)reader["IdModelo"],
                                Nombre        = reader["Nombre"].ToString(),
                                Descripcion   = reader["Descripcion"]?.ToString(),
                                Estado        = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaRegistro = (DateTime)reader["FechaRegistro"]
                            };
                        }
                    }
                }
            }

            return modelo;
        }

        public async Task ActivarModelo(int id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_ActivarModelo", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@IdModelo", id);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<List<Modelo>> ListarModelosInactivos()
        {
            var modelos = new List<Modelo>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_GetModelosInactivos", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            modelos.Add(new Modelo
                            {
                                IdModelo      = (int)reader["IdModelo"],
                                Nombre        = reader["Nombre"].ToString(),
                                Descripcion   = reader["Descripcion"]?.ToString(),
                                Estado        = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaRegistro = (DateTime)reader["FechaRegistro"]
                            });
                        }
                    }
                }
            }

            return modelos;
        }

        public async Task<Modelo> ObtenerModeloInactivoPorId(int id)
        {
            Modelo modelo = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_GetModeloByIdInactivo", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@IdModelo", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            modelo = new Modelo
                            {
                                IdModelo      = (int)reader["IdModelo"],
                                Nombre        = reader["Nombre"].ToString(),
                                Descripcion   = reader["Descripcion"]?.ToString(),
                                Estado        = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaRegistro = (DateTime)reader["FechaRegistro"]
                            };
                        }
                    }
                }
            }

            return modelo;
        }
    }
}