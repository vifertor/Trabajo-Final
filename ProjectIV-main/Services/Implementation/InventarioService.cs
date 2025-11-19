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
    public class InventarioService : IInventarioService
    {
        private readonly string _connectionString;

        public InventarioService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // ===============================
        // GET INVENTARIO COMPLETO
        // ===============================
        public List<Inventario> GetInventario()
{
    var lista = new List<Inventario>();

    using (var conn = new SqlConnection(_connectionString))
    using (var cmd = new SqlCommand(@"
        SELECT 
    i.IdInventario,
    i.Id_DetalleProducto,
    p.Nombre AS NombreProducto,
    m.Marca_Nombre AS Marca,
    mo.Nombre AS Modelo,
    c.NombreCategoria AS Categoria,
    i.PrecioUnitario,  -- ⚡ ahora correcto
    i.Cantidad,
    i.Estado,
    i.FechaRegistro
FROM Inventario i
INNER JOIN DetalleProducto dp ON i.Id_DetalleProducto = dp.Id_DetalleProducto
INNER JOIN Producto p ON dp.Id_Producto = p.IdProducto
INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
INNER JOIN Modelo mo ON dp.Id_Modelo = mo.IdModelo
INNER JOIN Categoria c ON dp.Id_Categoria = c.IdCategoria
WHERE i.Estado = 1
ORDER BY i.IdInventario DESC", conn))
    {
        conn.Open();
        var reader = cmd.ExecuteReader();

        while (reader.Read())
        {
            lista.Add(new Inventario
            {
                IdInventario = Convert.ToInt32(reader["IdInventario"]),
                IdDetalleProducto = Convert.ToInt32(reader["Id_DetalleProducto"]),
                NombreProducto = reader["NombreProducto"].ToString(),
                Marca = reader["Marca"].ToString(),
                Modelo = reader["Modelo"].ToString(),
                Categoria = reader["Categoria"].ToString(),
PrecioUnitario = reader["PrecioUnitario"] != DBNull.Value 
                          ? Convert.ToDecimal(reader["PrecioUnitario"]) 
                          : 0,
                Cantidad = Convert.ToInt32(reader["Cantidad"]),
                Estado = Convert.ToBoolean(reader["Estado"]),
                FechaRegistro = Convert.ToDateTime(reader["FechaRegistro"])
            });
        }
    }

    return lista;
}
        // ===============================
        // BUSCAR INVENTARIO (por nombre o categoría)
        // ===============================
        public List<Inventario> BuscarInventario(string filtro)
        {
            var lista = new List<Inventario>();

            string query = @"
                SELECT 
                    i.IdInventario,
                    i.Id_DetalleProducto,
                    p.Nombre AS NombreProducto,
                    m.Marca_Nombre AS Marca,
                    mo.Nombre AS Modelo,
                    c.NombreCategoria AS Categoria,
                    dp.PrecioUnitario,
                    i.Cantidad,
                    i.Estado,
                    i.FechaRegistro
                FROM Inventario i
                INNER JOIN DetalleProducto dp ON i.Id_DetalleProducto = dp.Id_DetalleProducto
                INNER JOIN Producto p ON dp.Id_Producto = p.IdProducto
                INNER JOIN Marca m ON dp.Marca_Id = m.Marca_Id
                INNER JOIN Modelo mo ON dp.Id_Modelo = mo.IdModelo
                INNER JOIN Categoria c ON dp.Id_Categoria = c.IdCategoria
                WHERE i.Estado = 1
                  AND (
                      p.Nombre LIKE '%' + @Filtro + '%' OR
                      m.Marca_Nombre LIKE '%' + @Filtro + '%' OR
                      c.NombreCategoria LIKE '%' + @Filtro + '%'
                  )
                ORDER BY i.IdInventario DESC";

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Filtro", filtro ?? "");
                conn.Open();
                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    lista.Add(new Inventario
                    {
                        IdInventario = Convert.ToInt32(reader["IdInventario"]),
                        IdDetalleProducto = Convert.ToInt32(reader["Id_DetalleProducto"]),
                        NombreProducto = reader["NombreProducto"].ToString(),
                        Marca = reader["Marca"].ToString(),
                        Modelo = reader["Modelo"].ToString(),
                        Categoria = reader["Categoria"].ToString(),
                        PrecioUnitario = reader["PrecioUnitario"] != DBNull.Value ? Convert.ToDecimal(reader["PrecioUnitario"]) : 0,
                        Cantidad = Convert.ToInt32(reader["Cantidad"]),
                        Estado = Convert.ToBoolean(reader["Estado"]),
                        FechaRegistro = Convert.ToDateTime(reader["FechaRegistro"])
                    });
                }
            }

            return lista;
        }

        // ===============================
        // RESUMEN DE INVENTARIO
        // ===============================
        public async Task<ResumenInventario> ObtenerResumenInventarioAsync()
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                string query = @"
                    SELECT
                         (SELECT COUNT(*) FROM Inventario WHERE Cantidad <= 5 AND Estado = 1) AS StockBajo,
                         (SELECT COUNT(*) FROM Producto WHERE Estado = 1) AS TotalProductos";

                using (SqlCommand command = new SqlCommand(query, connection))
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        return new ResumenInventario
                        {
                            StockBajo = Convert.ToInt32(reader["StockBajo"]),
                            TotalProductos = Convert.ToInt32(reader["TotalProductos"])
                        };
                    }
                }
            }
            return null;
        }

        // ===============================
        // PRODUCTOS CON STOCK BAJO
        // ===============================
        public async Task<List<ProductoStockBajoModel>> ObtenerProductosStockBajoAsync()
        {
            var productos = new List<ProductoStockBajoModel>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                string query = @"
                    SELECT 
                        P.Nombre AS NombreProducto,
                        I.Cantidad
                    FROM Inventario I
                    INNER JOIN DetalleProducto DP ON I.Id_DetalleProducto = DP.Id_DetalleProducto
                    INNER JOIN Producto P ON DP.Id_Producto = P.IdProducto
                    WHERE I.Cantidad <= 5 AND I.Estado = 1 AND P.Estado = 1;";

                using (SqlCommand command = new SqlCommand(query, connection))
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        productos.Add(new ProductoStockBajoModel
                        {
                            NombreProducto = reader["NombreProducto"].ToString(),
                            Cantidad = Convert.ToInt32(reader["Cantidad"])
                        });
                    }
                }
            }

            return productos;
        }
    }
}