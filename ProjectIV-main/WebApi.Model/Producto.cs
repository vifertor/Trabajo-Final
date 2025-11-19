using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Producto
    {
          public int      IdProducto    { get; set; }
        public string   Nombre        { get; set; }
        public string   Descripcion   { get; set; }
        public bool     Estado        { get; set; }     // true = activo, false = inactivo
        public DateTime FechaCreacion { get; set; } 
    }
}
