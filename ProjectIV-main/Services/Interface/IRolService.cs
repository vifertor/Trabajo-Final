using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
namespace Interface
{
    public interface IRolService
    {
        Task<List<Rol>> ObtenerRolesPorUsuarioAsync(int usuarioId);
        Task AsignarRolAsync(int usuarioId, int rolId);
        Task<bool> QuitarRolAsync(int usuarioId, int rolId);
        Task<List<Rol>> GetAllAsync();

        Task ActualizarRolesUsuario(int usuarioId, List<int> nuevosRoles);
        Task<Rol?> GetByIdAsync(int id);
        Task<Rol> CreateAsync(string nombreRol, string? descripcion = null);
    }
}