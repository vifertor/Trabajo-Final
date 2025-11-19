using System;

namespace WebApi.Model
{
    public class Empleado
    {
        public int IdEmpleado { get; set; }
    public string Nombres { get; set; }
    public string Apellidos { get; set; }
    public string Correo { get; set; }
    public string Cedula { get; set; }
    public string Telefono { get; set; }
    public string Genero { get; set; }
    public DateTime? FechaNacimiento { get; set; }  // ← Acepta nulos
    public bool Estado { get; set; }
    public DateTime? FechaRegistro { get; set; }    // ← Acepta nulos
    }
}
