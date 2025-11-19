using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IEmpleadoService
    {
        Task AgregarEmpleado(Empleado empleado);
        Task ActualizarEmpleado(Empleado empleado);
        Task<List<Empleado>> ListarEmpleados();               // Listar todos los empleados
        Task<Empleado> MostrarEmpleado(int idEmpleado);       // Obtener un empleado por ID
        Task EliminarEmpleado(int idEmpleado);                // Eliminación lógica
        Task ReactivarEmpleado(int idEmpleado);    
        
      Task<List<Empleado>> ListarEmpleadosInactivos();
        Task<Empleado> ObtenerEmpleadoInactivoPorId(int idEmpleado);
    }
}
