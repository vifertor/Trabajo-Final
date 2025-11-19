using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;

namespace Implementation
{
    public class DetalleProductoService : IDetalleProductoService
    {
        private readonly string _connectionString;

        public DetalleProductoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection")
                                ?? throw new InvalidOperationException("Cadena de conexión no configurada.");
        }

        private DetalleProductoConNombres MapDetalle(SqlDataReader reader)
        {
            return new DetalleProductoConNombres
            {
                Id_DetalleProducto = (int)reader["Id_DetalleProducto"],
                Id_Producto = (int)reader["Id_Producto"],
                NombreProducto = reader["NombreProducto"].ToString(),
                Marca_Id = (int)reader["Marca_Id"],
                NombreMarca = reader["NombreMarca"].ToString(),
                Id_Categoria = (int)reader["Id_Categoria"],
                NombreCategoria = reader["NombreCategoria"].ToString(),
                Id_Modelo = (int)reader["Id_Modelo"],
                NombreModelo = reader["NombreModelo"].ToString(),
                Estado = (bool)reader["Estado"],
                FechaRegistro = (DateTime)reader["FechaRegistro"]
            };
        }

        public async Task<List<DetalleProductoConNombres>> GetAll()
        {
            var lista = new List<DetalleProductoConNombres>();

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT dp.Id_DetalleProducto, dp.Id_Producto, p.Nombre AS NombreProducto,
                       dp.Marca_Id, m.Marca_Nombre AS NombreMarca,
                       dp.Id_Categoria, c.NombreCategoria AS NombreCategoria,
                       dp.Id_Modelo, mo.Nombre AS NombreModelo,
                       dp.Estado, dp.FechaRegistro
                FROM DetalleProducto dp
                INNER JOIN PRODUCTO p ON dp.Id_Producto = p.IdProducto
                INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
                INNER JOIN CATEGORIA c ON dp.Id_Categoria = c.IdCategoria
                INNER JOIN MODELO mo ON dp.Id_Modelo = mo.IdModelo
                WHERE dp.Estado = 1
                ORDER BY dp.FechaRegistro DESC", conn);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                lista.Add(MapDetalle(reader));

            return lista;
        }

        public async Task<DetalleProductoConNombres?> GetById(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT dp.Id_DetalleProducto, dp.Id_Producto, p.Nombre AS NombreProducto,
                       dp.Marca_Id, m.Marca_Nombre AS NombreMarca,
                       dp.Id_Categoria, c.NombreCategoria AS NombreCategoria,
                       dp.Id_Modelo, mo.Nombre AS NombreModelo,
                       dp.Estado, dp.FechaRegistro
                FROM DetalleProducto dp
                INNER JOIN PRODUCTO p ON dp.Id_Producto = p.IdProducto
                INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
                INNER JOIN CATEGORIA c ON dp.Id_Categoria = c.IdCategoria
                INNER JOIN MODELO mo ON dp.Id_Modelo = mo.IdModelo
                WHERE dp.Id_DetalleProducto = @id", conn);

            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();

            if (await reader.ReadAsync())
                return MapDetalle(reader);

            return null;
        }

        public async Task<bool> Create(DetalleProducto detalle)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                INSERT INTO DetalleProducto (Id_Producto, Marca_Id, Id_Categoria, Id_Modelo, Estado)
                VALUES (@Id_Producto, @Marca_Id, @Id_Categoria, @Id_Modelo, @Estado)", conn);

            cmd.Parameters.AddWithValue("@Id_Producto", detalle.Id_Producto);
            cmd.Parameters.AddWithValue("@Marca_Id", detalle.Marca_Id);
            cmd.Parameters.AddWithValue("@Id_Categoria", detalle.Id_Categoria);
            cmd.Parameters.AddWithValue("@Id_Modelo", detalle.Id_Modelo);
            cmd.Parameters.AddWithValue("@Estado", detalle.Estado);

            await conn.OpenAsync();
            return await cmd.ExecuteNonQueryAsync() > 0;
        }

        public async Task<bool> Update(int id, DetalleProducto detalle)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                UPDATE DetalleProducto SET 
                    Id_Producto = @Id_Producto,
                    Marca_Id = @Marca_Id,
                    Id_Categoria = @Id_Categoria,
                    Id_Modelo = @Id_Modelo,
                    Estado = @Estado
                WHERE Id_DetalleProducto = @id", conn);

            cmd.Parameters.AddWithValue("@id", id);
            cmd.Parameters.AddWithValue("@Id_Producto", detalle.Id_Producto);
            cmd.Parameters.AddWithValue("@Marca_Id", detalle.Marca_Id);
            cmd.Parameters.AddWithValue("@Id_Categoria", detalle.Id_Categoria);
            cmd.Parameters.AddWithValue("@Id_Modelo", detalle.Id_Modelo);
            cmd.Parameters.AddWithValue("@Estado", detalle.Estado);

            await conn.OpenAsync();
            return await cmd.ExecuteNonQueryAsync() > 0;
        }

        public async Task<bool> Delete(int id)
        {
            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(
                "UPDATE DetalleProducto SET Estado = 0 WHERE Id_DetalleProducto = @id", conn);

            cmd.Parameters.AddWithValue("@id", id);
            await conn.OpenAsync();
            return await cmd.ExecuteNonQueryAsync() > 0;
        }

        public async Task<List<DetalleProductoConNombres>> GetActiveAscendingPaged(int pageIndex, int pageSize)
        {
            var lista = new List<DetalleProductoConNombres>();
            int offset = (pageIndex - 1) * pageSize;

            using var conn = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand(@"
                SELECT dp.Id_DetalleProducto, dp.Id_Producto, p.Nombre AS NombreProducto,
                       dp.Marca_Id, m.Marca_Nombre AS NombreMarca,
                       dp.Id_Categoria, c.NombreCategoria AS NombreCategoria,
                       dp.Id_Modelo, mo.Nombre AS NombreModelo,
                       dp.Estado, dp.FechaRegistro
                FROM DetalleProducto dp
                INNER JOIN PRODUCTO p ON dp.Id_Producto = p.IdProducto
                INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
                INNER JOIN CATEGORIA c ON dp.Id_Categoria = c.IdCategoria
                INNER JOIN MODELO mo ON dp.Id_Modelo = mo.IdModelo
                WHERE dp.Estado = 1
                ORDER BY dp.FechaRegistro DESC
                OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY", conn);

            cmd.Parameters.AddWithValue("@Offset", offset);
            cmd.Parameters.AddWithValue("@PageSize", pageSize);

            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
                lista.Add(MapDetalle(reader));

            return lista;
        }
    }
}
