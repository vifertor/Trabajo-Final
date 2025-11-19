using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;

namespace Implementation
{
    public class ProveedorService : IProveedorService
    {
        private readonly string _connectionString;

        public ProveedorService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AgregarProveedor(Proveedor p)
        {
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_CRUD_Proveedor", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Opcion", "INSERT");
            cmd.Parameters.AddWithValue("@NombreEmpresa",      p.NombreEmpresa);
            cmd.Parameters.AddWithValue("@Descripcion",        (object)p.Descripcion        ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EncargadoNombre",    (object)p.EncargadoNombre    ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EncargadoApellido1", (object)p.EncargadoApellido1 ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EncargadoApellido2", (object)p.EncargadoApellido2 ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Correo",             (object)p.Correo             ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Telefono",           (object)p.Telefono           ?? DBNull.Value);
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task ActualizarProveedor(Proveedor p)
        {
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_CRUD_Proveedor", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Opcion", "UPDATE");
            cmd.Parameters.AddWithValue("@IdProveedor",        p.IdProveedor);
            cmd.Parameters.AddWithValue("@NombreEmpresa",      p.NombreEmpresa);
            cmd.Parameters.AddWithValue("@Descripcion",        (object)p.Descripcion        ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EncargadoNombre",    (object)p.EncargadoNombre    ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EncargadoApellido1", (object)p.EncargadoApellido1 ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@EncargadoApellido2", (object)p.EncargadoApellido2 ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Correo",             (object)p.Correo             ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Telefono",           (object)p.Telefono           ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Estado",             p.Estado);
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task EliminarProveedor(int id)
        {
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_CRUD_Proveedor", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Opcion", "DELETE");
            cmd.Parameters.AddWithValue("@IdProveedor", id);
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task<List<Proveedor>> ListarProveedores()
        {
            var lista = new List<Proveedor>();
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_CRUD_Proveedor", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Opcion", "GETALL");
            await using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new Proveedor
                {
                    IdProveedor        = (int)reader["IdProveedor"],
                    NombreEmpresa      = reader["NombreEmpresa"].ToString(),
                    Descripcion        = reader["Descripcion"]?.ToString(),
                    EncargadoNombre    = reader["EncargadoNombre"]?.ToString(),
                    EncargadoApellido1 = reader["EncargadoApellido1"]?.ToString(),
                    EncargadoApellido2 = reader["EncargadoApellido2"]?.ToString(),
                    Correo             = reader["Correo"]?.ToString(),
                    Telefono           = reader["Telefono"]?.ToString(),
                    Estado             = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                    FechaRegistro      = (DateTime)reader["FechaRegistro"]
                });
            }
            return lista;
        }

        public async Task<Proveedor> MostrarProveedor(int id)
        {
            Proveedor p = null;
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_CRUD_Proveedor", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@Opcion", "GETBYID");
            cmd.Parameters.AddWithValue("@IdProveedor", id);
            await using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                p = new Proveedor
                {
                    IdProveedor        = (int)reader["IdProveedor"],
                    NombreEmpresa      = reader["NombreEmpresa"].ToString(),
                    Descripcion        = reader["Descripcion"]?.ToString(),
                    EncargadoNombre    = reader["EncargadoNombre"]?.ToString(),
                    EncargadoApellido1 = reader["EncargadoApellido1"]?.ToString(),
                    EncargadoApellido2 = reader["EncargadoApellido2"]?.ToString(),
                    Correo             = reader["Correo"]?.ToString(),
                    Telefono           = reader["Telefono"]?.ToString(),
                    Estado             = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                    FechaRegistro      = (DateTime)reader["FechaRegistro"]
                };
            }
            return p;
        }

        public async Task ActivarProveedor(int id)
        {
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_ActivarProveedor", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdProveedor", id);
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task<List<Proveedor>> ListarProveedoresInactivos()
        {
            var lista = new List<Proveedor>();
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_GetProveedoresInactivos", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            await using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                lista.Add(new Proveedor
                {
                    IdProveedor        = (int)reader["IdProveedor"],
                    NombreEmpresa      = reader["NombreEmpresa"].ToString(),
                    Descripcion        = reader["Descripcion"]?.ToString(),
                    EncargadoNombre    = reader["EncargadoNombre"]?.ToString(),
                    EncargadoApellido1 = reader["EncargadoApellido1"]?.ToString(),
                    EncargadoApellido2 = reader["EncargadoApellido2"]?.ToString(),
                    Correo             = reader["Correo"]?.ToString(),
                    Telefono           = reader["Telefono"]?.ToString(),
                    Estado             = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                    FechaRegistro      = (DateTime)reader["FechaRegistro"]
                });
            }
            return lista;
        }

        public async Task<Proveedor> ObtenerProveedorInactivoPorId(int id)
        {
            Proveedor p = null;
            await using var conn = new SqlConnection(_connectionString);
            await conn.OpenAsync();
            using var cmd = new SqlCommand("sp_GetProveedorByIdInactivo", conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.AddWithValue("@IdProveedor", id);
            await using var reader = await cmd.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                p = new Proveedor
                {
                    IdProveedor        = (int)reader["IdProveedor"],
                    NombreEmpresa      = reader["NombreEmpresa"].ToString(),
                    Descripcion        = reader["Descripcion"]?.ToString(),
                    EncargadoNombre    = reader["EncargadoNombre"]?.ToString(),
                    EncargadoApellido1 = reader["EncargadoApellido1"]?.ToString(),
                    EncargadoApellido2 = reader["EncargadoApellido2"]?.ToString(),
                    Correo             = reader["Correo"]?.ToString(),
                    Telefono           = reader["Telefono"]?.ToString(),
                    Estado             = reader["Estado"] != DBNull.Value && (bool)reader["Estado"],
                    FechaRegistro      = (DateTime)reader["FechaRegistro"]
                };
            }
            return p;
        }
    }
}
