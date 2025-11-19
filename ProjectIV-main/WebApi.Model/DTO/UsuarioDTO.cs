namespace WebApi.Model.DTO
{
    public class UsuarioDto
    {
        public int Usuario_Id { get; set; }
        public string NombreCompleto { get; set; }
        public string Correo { get; set; }
        public List<string> Roles { get; set; } // O List<RolDto> si querés más info
    }
}
