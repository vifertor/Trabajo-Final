using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ClienteController : Controller
    {
        private readonly IClienteService _clienteService;

        public ClienteController(IClienteService clienteService)
        {
            _clienteService = clienteService;
        }

        // POST: api/cliente
        [HttpPost]
        public async Task<ActionResult> Add([FromBody] Cliente cliente)
        {
            await _clienteService.AgregarCliente(cliente);
            return Ok();
        }

        // GET: api/cliente
        [Authorize(Roles = "isi")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Cliente>>> Get()
        {
            var clientes = await _clienteService.ListarClientes();
            return Ok(clientes);
        }

        // GET: api/cliente/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Cliente>> Get(int id)
        {
            var cliente = await _clienteService.MostrarCliente(id);
            if (cliente == null)
            {
                return NotFound();
            }
            return Ok(cliente);
        }

        // PUT: api/cliente/5
        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] Cliente cliente)
        {
            var existingCliente = await _clienteService.MostrarCliente(id);
            if (existingCliente == null) return NotFound();

            cliente.IdCliente = id;
            await _clienteService.ActualizarCliente(cliente);
            return Ok();
        }

        // DELETE: api/cliente/5
        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _clienteService.EliminarCliente(id);
            return Ok(new { message = "Cliente eliminado correctamente." });
        }
    }
}
