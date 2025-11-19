using System.Threading.Tasks;

namespace WebApi.ETL.Interface
{
    public interface IETLProductoService
    {
        Task<string> TransferirProductosAsync();
    }
}
