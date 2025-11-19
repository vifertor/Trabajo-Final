using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Interface;
using WebApi.Model;

namespace Implementation
{
    public class VistaDetalleProductoService : IVistaDetalleProductoService
    {
        private readonly string _connectionString;

        public VistaDetalleProductoService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public List<VistaDetalleProducto> ListarVistaDetalleProducto()
        {
            var lista = new List<VistaDetalleProducto>();

            using (var conn = new SqlConnection(_connectionString))
            using (var cmd = new SqlCommand("sp_ListarVistaDetalleProducto", conn)) // Reemplaza por tu SP o consulta
            {
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();

                var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    lista.Add(new VistaDetalleProducto
                    {
                        Id_DetalleProducto = Convert.ToInt32(reader["Id_DetalleProducto"]),
                        NombreProducto = reader["Nombre"].ToString(),
                        DescripcionProducto = reader["Descripcion"].ToString(),
                        Marca = reader["Marca"].ToString(),
                        Categoria = reader["Categoria"].ToString(),
                        Modelo = reader["Modelo"].ToString(),
                        PrecioUnitario = Convert.ToDecimal(reader["PrecioUnitario"]),
                        Estado = Convert.ToBoolean(reader["Estado"]),
                        FechaRegistro = Convert.ToDateTime(reader["FechaRegistro"])
    
                    });
                }
            }

            return lista;
        }
    }
}
