using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Rol
    {
        public int    Rol_Id     { get; set; }
        public string Nombre_rol { get; set; } = null!;
        public string? Descripcion { get; set; }
    }
}