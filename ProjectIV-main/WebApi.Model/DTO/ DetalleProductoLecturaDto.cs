using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class  DetalleProductoLecturaDto
    {
         public int IdDetalleProducto { get; set; }
        public int IdProducto { get; set; }
        public string NombreProducto { get; set; } = string.Empty; // Asumiendo que se carga

        public int MarcaId { get; set; }
        public string NombreMarca { get; set; } = string.Empty; // Asumiendo que se carga

        public int IdCategoria { get; set; }
        public string NombreCategoria { get; set; } = string.Empty; // Asumiendo que se carga

        public int IdModelo { get; set; }
        public string NombreModelo { get; set; } = string.Empty; // Asumiendo que se carga

        public bool Estado { get; set; }
        public DateTime FechaRegistro { get; set; }
    }
}