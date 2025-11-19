using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class DetalleProductoConNombres
    {
          public int Id_DetalleProducto { get; set; }

        public int Id_Producto { get; set; }
        public string? NombreProducto { get; set; }

        public int Marca_Id { get; set; }
        public string? NombreMarca { get; set; }

        public int Id_Categoria { get; set; }
        public string? NombreCategoria { get; set; }

        public int Id_Modelo { get; set; }
        public string? NombreModelo { get; set; }

        public bool Estado { get; set; }
        public DateTime FechaRegistro { get; set; }
    }
}