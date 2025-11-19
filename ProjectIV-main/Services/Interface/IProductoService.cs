using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IProductoService
    {
        Task AgregarProducto(Producto producto);
        Task ActualizarProducto(Producto producto);
        Task<List<Producto>> ListarProductos();
        Task<Producto> MostrarProducto(int id);
        Task EliminarProducto(int id);                     // soft-delete (Estado = 0)
        Task ActivarProducto(int id);                      // reactivar (Estado = 1)

        Task<List<Producto>> ListarProductosInactivos();
        Task<Producto> ObtenerProductoInactivoPorId(int id);
    }
}

