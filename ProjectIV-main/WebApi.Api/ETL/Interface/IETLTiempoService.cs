using System;
using System.Threading.Tasks;

namespace WebApi.ETL.Interface
{
    public interface IETLTiempoService
    {
        Task<string> GenerarDimTiempoAsync(DateTime fechaInicio, DateTime fechaFin);
    }
}
