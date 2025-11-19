using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IMarcaService
    {
        Task AgregarMarca(Marca marca);
        Task ActualizarMarca(Marca marcaa);
        Task<List<Marca>> ListarMarcasActivas();
        Task<Marca> MostrarMarca(int Id);
        Task EliminarMarca(int idMarca);

        Task ActivarMarca(int idMarca);
        Task<List<Marca>> ListarMarcasInactivas();

 Task<Marca> MostrarMarcaINACTIVA(int idMarca);
    }
}