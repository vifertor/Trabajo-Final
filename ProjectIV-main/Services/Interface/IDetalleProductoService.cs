using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IDetalleProductoService
    {
       Task<List<DetalleProductoConNombres>> GetAll();
        Task<DetalleProductoConNombres?> GetById(int id);
        Task<bool> Create(DetalleProducto detalle);
        Task<bool> Update(int id, DetalleProducto detalle);
        Task<bool> Delete(int id);
        Task<List<DetalleProductoConNombres>> GetActiveAscendingPaged(int pageIndex, int pageSize);    }
}
