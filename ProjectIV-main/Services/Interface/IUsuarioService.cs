using WebApi.Model;
using WebApi.Model.DTO;

namespace Interface
{
    public interface IUsuarioService
    {
        Task<Usuario> Registrar(string nombreCompleto, string correo, string password, int rolId);

        Task<Usuario> Autenticar(string correo, string contrasena);
        Task<IEnumerable<UsuarioConRolDTO>> GetAllAsync();
        Task<IEnumerable<Usuario>> GetAllWithRolesAsync();

        Task<UsuarioDto> GetByIdAsync(int usuarioId);

        string GenerateJwtToken(Usuario usuario);
        Task<bool> Actualizar(Usuario usuario);
        Task<bool> Eliminar(int usuarioId);

    }
}


