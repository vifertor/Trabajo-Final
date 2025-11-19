namespace WebApi.Model.DTO
{
    public class UsuarioEditarDTO
    {
        public string NombreCompleto { get; set; }
        public string Correo { get; set; }
        public List<int> Roles { get; set; } // IDs de los roles seleccionados
    }
}