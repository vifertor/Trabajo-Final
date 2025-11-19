using WebApi.Model;

namespace Interface
{
    public interface IInventarioService
    {
        List<Inventario> GetInventario();
        List<Inventario> BuscarInventario(string filtro);
        Task<ResumenInventario> ObtenerResumenInventarioAsync();
        Task<List<ProductoStockBajoModel>> ObtenerProductosStockBajoAsync();
    }
}
