using System.Threading.Tasks;
using WebApi.Models.ETL;

namespace WebApi.ETL.Interface
{
    public interface IETLVentasService
    {
        Task<string> TransferirHechosVentasAsync();
        Task<List<HechosVentas>> ObtenerHechosVentasAsync();
    }
}
