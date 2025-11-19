using System.Data;
using WebApi.Models;
using WebApi.Services.Interface;
using System.Xml.Linq;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace WebApi.Services.Implementation
{
    public class CompraService : ICompraService
    {
        private readonly string _connectionString;

        public CompraService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // ✅ Listar todas las compras
        public async Task<List<Compra>> GetComprasAsync()
        {
            var lista = new List<Compra>();

            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_ListarCompras", con);
            cmd.CommandType = CommandType.StoredProcedure;

            await con.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                lista.Add(new Compra
                {
                    Id_Compra = (int)reader["Id_Compra"],
                    ProveedorNombre = reader["Proveedor"].ToString(),
                    EmpleadoNombre = reader["Empleado"].ToString(),
                    MontoTotal = (decimal)reader["MontoTotal"],
                    FechaCompra = (DateTime)reader["FechaCompra"],
                    Estado = (bool)reader["Estado"]
                });
            }

            return lista;
        }

        // ✅ Obtener compra por ID con nombres de productos
        public async Task<Compra?> GetCompraByIdAsync(int id)
        {
            Compra? compra = null;

            using var con = new SqlConnection(_connectionString);
            using var cmd = new SqlCommand("sp_ObtenerCompraPorId", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@IdCompra", id);

            await con.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();

            // Leer la compra
            if (await reader.ReadAsync())
            {
                compra = new Compra
                {
                    Id_Compra = (int)reader["Id_Compra"],
                    ProveedorNombre = reader["Proveedor"].ToString(),
                    EmpleadoNombre = reader["Empleado"].ToString(),
                    MontoTotal = (decimal)reader["MontoTotal"],
                    FechaCompra = (DateTime)reader["FechaCompra"],
                    Estado = (bool)reader["Estado"],
                    Detalles = new List<DetalleCompra>()
                };
            }

            // Leer los detalles
            if (compra != null && await reader.NextResultAsync())
            {
                while (await reader.ReadAsync())
                {
                    compra.Detalles.Add(new DetalleCompra
                    {
                        Id_DetalleProducto = (int)reader["Id_DetalleProducto"],
                        PrecioCompra = (decimal)reader["PrecioCompra"],
                        Cantidad = (int)reader["Cantidad"],
                        Subtotal = (decimal)reader["Subtotal"],
                        ProductoNombre = reader["Producto"] != DBNull.Value ? reader["Producto"].ToString() : null
                    });
                }
            }

            return compra;
        }

        // ✅ Registrar compra
        public async Task<bool> RegistrarCompraAsync(Compra compra)
        {
            try
            {
                using var con = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("sp_RegistrarCompra", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@IdProveedor", compra.Id_Proveedor);
                cmd.Parameters.AddWithValue("@IdEmpleado", compra.Id_Empleado);

                // Convertir detalles a XML
                var xml = new XElement("Detalles",
                    compra.Detalles.Select(d =>
                        new XElement("Detalle",
                            new XElement("Id_DetalleProducto", d.Id_DetalleProducto),
                            new XElement("PrecioCompra", d.PrecioCompra),
                            new XElement("Cantidad", d.Cantidad)
                        )
                    )
                );

                cmd.Parameters.AddWithValue("@Detalles", xml.ToString());

                await con.OpenAsync();
                await cmd.ExecuteNonQueryAsync();
                return true;
            }
            catch
            {
                return false;
            }
        }

        // ✅ Eliminar compra
        public async Task<bool> EliminarCompraAsync(int id)
        {
            try
            {
                using var con = new SqlConnection(_connectionString);
                using var cmd = new SqlCommand("sp_EliminarCompra", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdCompra", id);

                await con.OpenAsync();
                var filas = await cmd.ExecuteNonQueryAsync();
                return filas > 0;
            }
            catch
            {
                return false;
            }
        }
    }
}
