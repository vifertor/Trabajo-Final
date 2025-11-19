using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Modelo
    {
         public int    IdModelo      { get; set; }
        public string Nombre        { get; set; }
        public string Descripcion   { get; set; }
        public bool   Estado        { get; set; }   // true = activo, false = inactivo
        public DateTime FechaRegistro { get; set; } // generado por la BD
    }
}