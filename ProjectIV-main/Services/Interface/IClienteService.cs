using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IClienteService
    {
        Task AgregarCliente(Cliente cliente);
        Task ActualizarCliente(Cliente cliente);
        Task<List<Cliente>> ListarClientes(); // Listar todos los clientes
        Task<Cliente> MostrarCliente(int idCliente); // Mostrar un cliente por ID
        Task EliminarCliente(int idCliente);
    }
}
