using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class Proveedor
    {
         public int    IdProveedor        { get; set; }
        public string NombreEmpresa      { get; set; }
        public string Descripcion        { get; set; }
        public string EncargadoNombre    { get; set; }
        public string EncargadoApellido1 { get; set; }
        public string EncargadoApellido2 { get; set; }
        public string Correo             { get; set; }
        public string Telefono           { get; set; }
        public bool   Estado             { get; set; }
        public DateTime FechaRegistro    { get; set; }
    }
}