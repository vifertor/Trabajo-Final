using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Categoria
    {
        public int Categoria_Id { get; set; }
        public string Categoria_Nombre { get; set; }
        public bool Categoria_Estado { get; set; }
    }
}
