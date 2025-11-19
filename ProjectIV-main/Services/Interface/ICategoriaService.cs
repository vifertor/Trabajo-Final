using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface ICategoriaService
    {
        Task AgregarCategoria(Categoria categoria);
        Task ActualizarCategoria(Categoria categoria);
        Task<List<Categoria>> ListarCategorias();
        Task<Categoria> MostrarCategoria(int id);
        Task EliminarCategoria(int id);
        Task ActivarCategoria(int id);

        Task<List<Categoria>> ListarCategoriasInactivas();
          Task<Categoria> ObtenerCategoriaInactivaPorId(int idCategoria);
    }
}
