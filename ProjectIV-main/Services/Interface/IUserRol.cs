using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
namespace Interface
{
    public interface IUserRol
    {
          Task<IEnumerable<Rol>> GetRolesByUsuarioIdAsync(int usuarioId);
        Task<bool> AsignarRolAUsuarioAsync(int usuarioId, int rolId);
        Task<bool> RemoverRolDeUsuarioAsync(int usuarioId, int rolId);
    }
}