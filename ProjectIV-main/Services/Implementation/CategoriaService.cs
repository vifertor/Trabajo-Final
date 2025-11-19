using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;

namespace Implementation
{
    public class CategoriaService : ICategoriaService
    {
        private readonly string _connectionString;

        public CategoriaService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AgregarCategoria(Categoria categoria)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_CATEGORIA", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "INSERT");
                    command.Parameters.AddWithValue("@NombreCategoria", categoria.Categoria_Nombre);
                    // Estado se establece por defecto en el SP a 1, no es necesario enviar
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task ActualizarCategoria(Categoria categoria)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_CATEGORIA", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "UPDATE");
                    command.Parameters.AddWithValue("@IdCategoria", categoria.Categoria_Id);
                    command.Parameters.AddWithValue("@NombreCategoria", categoria.Categoria_Nombre);
                    command.Parameters.AddWithValue("@Estado", categoria.Categoria_Estado);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task EliminarCategoria(int id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_CATEGORIA", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "DELETE");
                    command.Parameters.AddWithValue("@IdCategoria", id);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<List<Categoria>> ListarCategorias()
        {
            var categorias = new List<Categoria>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_CATEGORIA", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "GETALL");

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            categorias.Add(new Categoria
                            {
                                Categoria_Id = (int)reader["IdCategoria"],
                                Categoria_Nombre = reader["NombreCategoria"].ToString(),
                                Categoria_Estado = reader["Estado"] != DBNull.Value && (bool)reader["Estado"]
                            });
                        }
                    }
                }
            }

            return categorias;
        }

        public async Task<Categoria> MostrarCategoria(int id)
        {
            Categoria categoria = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_CRUD_CATEGORIA", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Opcion", "GETBYID");
                    command.Parameters.AddWithValue("@IdCategoria", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            categoria = new Categoria
                            {
                                Categoria_Id = (int)reader["IdCategoria"],
                                Categoria_Nombre = reader["NombreCategoria"].ToString(),
                                Categoria_Estado = reader["Estado"] != DBNull.Value && (bool)reader["Estado"]
                            };
                        }
                    }
                }
            }

            return categoria;
        }

        public async Task ActivarCategoria(int id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("sp_ActivarCategoria", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@IdCategoria", id);
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<List<Categoria>> ListarCategoriasInactivas()
        {
            var categorias = new List<Categoria>();

            using SqlConnection conn = new(_connectionString);
            await conn.OpenAsync();
            SqlCommand cmd = new("sp_GetCategoriasInactivas", conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                categorias.Add(new Categoria
                {
                     Categoria_Id = (int)reader["IdCategoria"],
                   Categoria_Nombre = reader["NombreCategoria"].ToString(),
                    Categoria_Estado = (bool)reader["Estado"]
                });
            }

            return categorias;
        }
         public async Task<Categoria> ObtenerCategoriaInactivaPorId(int idCategoria)
        {
            Categoria categoria = null;
            using SqlConnection conn = new(_connectionString);
            await conn.OpenAsync();
            SqlCommand cmd = new("sp_GetCategoriaByIdInactiva", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdCategoria", idCategoria);

            using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                categoria = new Categoria
                {
                     Categoria_Id  = (int)reader["IdCategoria"],
                    Categoria_Nombre = reader["NombreCategoria"].ToString(),
                    Categoria_Estado= false
                };
            }

            return categoria;
        }
    }
}
