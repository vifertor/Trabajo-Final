using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Configuration;
using WebApi.Model;

namespace Implementation
{
    public class RolService : IRolService
    {

        private readonly string _cs;
        public RolService(IConfiguration config)
            => _cs = config.GetConnectionString("DefaultConnection")!;

        public async Task<List<Rol>> ObtenerRolesPorUsuarioAsync(int usuarioId)
        {
            var lista = new List<Rol>();
            using var cn = new SqlConnection(_cs);
            var sql = @"
              SELECT r.Rol_Id, r.Nombre_rol, r.Descripcion
              FROM Rol r
              INNER JOIN UserRol ur
                ON ur.Rol_Id = r.Rol_Id
              WHERE ur.Usuario_Id = @u";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@u", usuarioId);
            await cn.OpenAsync();
            using var rdr = await cmd.ExecuteReaderAsync();
            while (await rdr.ReadAsync())
                lista.Add(new Rol
                {
                    Rol_Id = rdr.GetInt32(0),
                    Nombre_rol = rdr.GetString(1),
                    Descripcion = rdr.IsDBNull(2) ? null : rdr.GetString(2)
                });
            return lista;
        }

        public async Task AsignarRolAsync(int usuarioId, int rolId)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "INSERT INTO UserRol (Usuario_Id, Rol_Id) VALUES (@u, @r)";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@u", usuarioId);
            cmd.Parameters.AddWithValue("@r", rolId);
            await cn.OpenAsync();
            await cmd.ExecuteNonQueryAsync();
        }

        public async Task<bool> QuitarRolAsync(int usuarioId, int rolId)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "DELETE FROM UserRol WHERE Usuario_Id = @u AND Rol_Id = @r";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@u", usuarioId);
            cmd.Parameters.AddWithValue("@r", rolId);
            await cn.OpenAsync();
            return await cmd.ExecuteNonQueryAsync() > 0;
        }

        public async Task<List<Rol>> GetAllAsync()
        {
            var lista = new List<Rol>();
            using var cn = new SqlConnection(_cs);
            var sql = "SELECT Rol_Id, Nombre_rol, Descripcion FROM Rol";
            using var cmd = new SqlCommand(sql, cn);
            await cn.OpenAsync();
            using var rdr = await cmd.ExecuteReaderAsync();
            while (await rdr.ReadAsync())
            {
                lista.Add(new Rol
                {
                    Rol_Id = rdr.GetInt32(0),
                    Nombre_rol = rdr.GetString(1),
                    Descripcion = rdr.IsDBNull(2) ? null : rdr.GetString(2)
                });
            }
            return lista;
        }

        public async Task<Rol?> GetByIdAsync(int id)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "SELECT Rol_Id, Nombre_rol, Descripcion FROM Rol WHERE Rol_Id = @id";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@id", id);
            await cn.OpenAsync();
            using var rdr = await cmd.ExecuteReaderAsync();
            if (await rdr.ReadAsync())
            {
                return new Rol
                {
                    Rol_Id = rdr.GetInt32(0),
                    Nombre_rol = rdr.GetString(1),
                    Descripcion = rdr.IsDBNull(2) ? null : rdr.GetString(2)
                };
            }
            return null;
        }

        public async Task<Rol> CreateAsync(string nombreRol, string? descripcion = null)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "INSERT INTO Rol (Nombre_rol, Descripcion) OUTPUT INSERTED.Rol_Id VALUES (@nombre, @desc)";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@nombre", nombreRol);
            cmd.Parameters.AddWithValue("@desc", (object?)descripcion ?? DBNull.Value);
            await cn.OpenAsync();
            var id = (int)await cmd.ExecuteScalarAsync();

            return new Rol { Rol_Id = id, Nombre_rol = nombreRol, Descripcion = descripcion };
        }

        public async Task ActualizarRolesUsuario(int usuarioId, List<int> nuevosRoles)
        {
            using var cn = new SqlConnection(_cs);
            await cn.OpenAsync();

            using var tx = cn.BeginTransaction();

            try
            {
                // Eliminar roles existentes
                var eliminar = new SqlCommand("DELETE FROM UserRol WHERE Usuario_Id = @id", cn, tx);
                eliminar.Parameters.AddWithValue("@id", usuarioId);
                await eliminar.ExecuteNonQueryAsync();

                // Insertar nuevos roles
                foreach (var rolId in nuevosRoles)
                {
                    var insertar = new SqlCommand("INSERT INTO UserRol (Usuario_Id, Rol_Id) VALUES (@uid, @rid)", cn, tx);
                    insertar.Parameters.AddWithValue("@uid", usuarioId);
                    insertar.Parameters.AddWithValue("@rid", rolId);
                    await insertar.ExecuteNonQueryAsync();
                }

                tx.Commit();
            }
            catch
            {
                tx.Rollback();
                throw;
            }
        }



        private async Task<int?> ObtenerRolIdPorNombre(string nombreRol)
        {
            using var cn = new SqlConnection(_cs);
            var sql = "SELECT Rol_Id FROM Rol WHERE Nombre_rol = @nombre";
            using var cmd = new SqlCommand(sql, cn);
            cmd.Parameters.AddWithValue("@nombre", nombreRol);
            await cn.OpenAsync();
            var result = await cmd.ExecuteScalarAsync();
            return result != null ? (int?)result : null;
        }

        public Task ActualizarRolesUsuario(int usuarioId, List<string> nuevosRoles)
        {
            throw new NotImplementedException();
        }

        //public Task ActualizarRolesUsuario(int usuarioId, List<int> nuevosRoles)
        //{
        //   throw new NotImplementedException();
        //}
    }
}