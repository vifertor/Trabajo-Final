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
    public class ProductoService : IProductoService
    {
        private readonly string _connectionString;

        public ProductoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AgregarProducto(Producto producto)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_CRUD_PRODUCTO", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Opcion", "INSERT");
                    cmd.Parameters.AddWithValue("@Nombre", producto.Nombre);
                    cmd.Parameters.AddWithValue("@Descripcion", (object)producto.Descripcion ?? DBNull.Value);
                    await cmd.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task ActualizarProducto(Producto producto)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_CRUD_PRODUCTO", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Opcion", "UPDATE");
                    cmd.Parameters.AddWithValue("@IdProducto", producto.IdProducto);
                    cmd.Parameters.AddWithValue("@Nombre", producto.Nombre);
                    cmd.Parameters.AddWithValue("@Descripcion", (object)producto.Descripcion ?? DBNull.Value);
                    await cmd.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task EliminarProducto(int id)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_CRUD_PRODUCTO", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Opcion", "DELETE");
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    await cmd.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<List<Producto>> ListarProductos()
        {
            var lista = new List<Producto>();
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_CRUD_PRODUCTO", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Opcion", "GETALL");
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            lista.Add(new Producto
                            {
                                IdProducto = (int)reader["IdProducto"],
                                Nombre = reader["Nombre"].ToString(),
                                Descripcion = reader["Descripcion"]?.ToString(),
                                Estado = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaCreacion = (DateTime)reader["FechaCreacion"]
                            });
                        }
                    }
                }
            }
            return lista;
        }

        public async Task<Producto> MostrarProducto(int id)
        {
            Producto producto = null;
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_CRUD_PRODUCTO", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Opcion", "GETBYID");
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            producto = new Producto
                            {
                                IdProducto = (int)reader["IdProducto"],
                                Nombre = reader["Nombre"].ToString(),
                                Descripcion = reader["Descripcion"]?.ToString(),
                                Estado = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaCreacion = (DateTime)reader["FechaCreacion"]
                            };
                        }
                    }
                }
            }
            return producto;
        }

        public async Task ActivarProducto(int id)
        {
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_ActivarProducto", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    await cmd.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<List<Producto>> ListarProductosInactivos()
        {
            var lista = new List<Producto>();
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_GetProductosInactivos", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            lista.Add(new Producto
                            {
                                IdProducto = (int)reader["IdProducto"],
                                Nombre = reader["Nombre"].ToString(),
                                Descripcion = reader["Descripcion"]?.ToString(),
                                Estado = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaCreacion = (DateTime)reader["FechaCreacion"]
                            });
                        }
                    }
                }
            }
            return lista;
        }

        public async Task<Producto> ObtenerProductoInactivoPorId(int id)
        {
            Producto producto = null;
            using (var conn = new SqlConnection(_connectionString))
            {
                await conn.OpenAsync();
                using (var cmd = new SqlCommand("sp_GetProductoByIdInactivo", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IdProducto", id);
                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            producto = new Producto
                            {
                                IdProducto = (int)reader["IdProducto"],
                                Nombre = reader["Nombre"].ToString(),
                                Descripcion = reader["Descripcion"]?.ToString(),
                                Estado = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                                FechaCreacion = (DateTime)reader["FechaCreacion"]
                            };
                        }
                    }
                }
            }
            return producto;
        }
 
    }

}
