using System.Threading.Tasks;

namespace WebApi.ETL.Interface
{
    public interface IETLEmpleadoService
    {
        Task<string> TransferirEmpleadosAsync();
    }
}
