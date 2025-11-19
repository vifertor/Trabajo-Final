using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;

using System.Threading.Tasks;
namespace Implementation
{
    public class MarcaService : IMarcaService
    {
        private readonly string _connectionString;

        public MarcaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task ActualizarMarca(Marca marcaa)
        {



            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_UpdateMarca", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Marca_Id", marcaa.Marca_Id);
                command.Parameters.AddWithValue("@Marca_Nombre", marcaa.Marca_Nombre);


                await command.ExecuteNonQueryAsync();
            }

        }

        public async Task AgregarMarca(Marca marca)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_AddMarca", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Marca_Nombre", marca.Marca_Nombre);

                await command.ExecuteNonQueryAsync();
            }

        }

        public async Task EliminarMarca(int Marca_Id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_DeleteMarca", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Marca_Id", Marca_Id);

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<Marca>> ListarMarcasActivas()
        {
            var marcas = new List<Marca>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_GetAllMarca", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };

                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        marcas.Add(new Marca
                        {
                            Marca_Id = (int)reader["Marca_Id"],
                            Marca_Nombre = reader["Marca_Nombre"].ToString(),
                            Marca_Estado = (bool)reader["Marca_Estado"]
                        });
                    }
                }
            }

            return marcas;
        }

        public async Task<Marca> MostrarMarca(int Id)
        {
            Marca marca = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_GetMarcaById", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Marca_Id", Id);

                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        marca = new Marca
                        {
                            Marca_Id = (int)reader["Marca_Id"],
                            Marca_Nombre = reader["Marca_Nombre"].ToString(),
                            Marca_Estado = (bool)reader["Marca_Estado"]
                        };
                    }
                }
            }

            return marca;

        }

        public async Task ActivarMarca(int Marca_Id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_ActivarMarca", connection)
                {
                    CommandType = CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Marca_Id", Marca_Id);
                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<Marca>> ListarMarcasInactivas()
        {
            var marcas = new List<Marca>();
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_GetAllMarcaInactiva", connection)
                {
                    CommandType = CommandType.StoredProcedure
                };

                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        marcas.Add(new Marca
                        {
                            Marca_Id = (int)reader["Marca_Id"],
                            Marca_Nombre = reader["Marca_Nombre"].ToString(),
                            Marca_Estado = (bool)reader["Marca_Estado"]
                        });
                    }
                }
            }
            return marcas;
        }

          public async Task<Marca> MostrarMarcaINACTIVA(int Idmarca)
        {
            Marca marca = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_GetMarcaByIdinavilitado", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Marca_Id", Idmarca);

                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        marca = new Marca
                        {
                            Marca_Id = (int)reader["Marca_Id"],
                            Marca_Nombre = reader["Marca_Nombre"].ToString(),
                            Marca_Estado = (bool)reader["Marca_Estado"]
                        };
                    }
                }
            }

            return marca;

        }


    }
}