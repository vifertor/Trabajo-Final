using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Threading.Tasks;
using WebApi.Model;
namespace Interface
{
    public interface IModeloService
    {
        
         Task AgregarModelo(Modelo modelo);
        Task ActualizarModelo(Modelo modelo);
        Task<List<Modelo>> ListarModelos();
        Task<Modelo> MostrarModelo(int id);
        Task EliminarModelo(int id);                       // soft-delete (Estado = 0)
        Task ActivarModelo(int id);                        // reactivar

        Task<List<Modelo>> ListarModelosInactivos();
        Task<Modelo> ObtenerModeloInactivoPorId(int id);
    }
}