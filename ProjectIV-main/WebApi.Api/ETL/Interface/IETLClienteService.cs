using System.Threading.Tasks;

namespace WebApi.ETL.Interface
{
    public interface IETLClienteService
    {
        Task<string> TransferirClientesAsync();
    }
}
