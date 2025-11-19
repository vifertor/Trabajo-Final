using System.Threading.Tasks;

namespace WebApi.ETL.Interface
{
    public interface IETLMasterService
    {
        Task<string> EjecutarTodoAsync();
    }
}
