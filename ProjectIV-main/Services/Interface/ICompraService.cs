using WebApi.Models;

namespace WebApi.Services.Interface
{
    public interface ICompraService
    {
        Task<List<Compra>> GetComprasAsync();
        Task<Compra?> GetCompraByIdAsync(int id);
        Task<bool> RegistrarCompraAsync(Compra compra);
        Task<bool> EliminarCompraAsync(int id);
    }
}
