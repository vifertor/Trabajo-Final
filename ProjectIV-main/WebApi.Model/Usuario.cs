using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Text.Json.Serialization;

namespace WebApi.Model
{
    public class Usuario
    {
        public int Usuario_Id { get; set; }
        public string NombreCompleto { get; set; }
        public string Correo { get; set; }
        public string Contrasena { get; set; }

        [JsonIgnore] // Esto lo oculta de Swagger y del frontend
        public byte[] UsuarioSalt { get; set; }
        public List<Rol> Roles { get; set; } = new List<Rol>();
    }

}