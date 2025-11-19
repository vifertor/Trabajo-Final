using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IProveedorService
    {
        Task AgregarProveedor(Proveedor proveedor);
        Task ActualizarProveedor(Proveedor proveedor);
        Task<List<Proveedor>> ListarProveedores();
        Task<Proveedor> MostrarProveedor(int id);
        Task EliminarProveedor(int id);
        Task ActivarProveedor(int id);

        Task<List<Proveedor>> ListarProveedoresInactivos();
        Task<Proveedor> ObtenerProveedorInactivoPorId(int id);
    }
}