using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmpleadoController : ControllerBase
    {
        private readonly IEmpleadoService _empleadoService;

        public EmpleadoController(IEmpleadoService empleadoService)
        {
            _empleadoService = empleadoService;
        }

        // POST: api/empleado
        [HttpPost]
        public async Task<ActionResult> Add([FromBody] Empleado empleado)
        {
            await _empleadoService.AgregarEmpleado(empleado);
            return Ok();
        }

        // GET: api/empleado
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Empleado>>> Get()
        {
            var empleados = await _empleadoService.ListarEmpleados();
            return Ok(empleados);
        }

        // GET: api/empleado/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Empleado>> Get(int id)
        {
            var empleado = await _empleadoService.MostrarEmpleado(id);
            if (empleado == null)
                return NotFound();
            return Ok(empleado);
        }

        // PUT: api/empleado/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] Empleado empleado)
        {
            var existingEmpleado = await _empleadoService.MostrarEmpleado(id);
            if (existingEmpleado == null)
                return NotFound();

            empleado.IdEmpleado = id;
            await _empleadoService.ActualizarEmpleado(empleado);
            return Ok();
        }

        // DELETE: api/empleado/{id} (eliminación lógica)
        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _empleadoService.EliminarEmpleado(id);
            return Ok(new { message = "Empleado eliminado correctamente (estado cambiado)." });
        }

        // PUT: api/empleado/activate/{id} (reactivar empleado)
        [HttpPut("activate/{id}")]
        public async Task<ActionResult> Activate(int id)
        {
            var existingEmpleado = await _empleadoService.MostrarEmpleado(id);
            if (existingEmpleado == null)
                return NotFound();

            await _empleadoService.ReactivarEmpleado(id);
            return Ok(new { message = "Empleado reactivado correctamente." });
        }
         [HttpGet("inactivos")]
        public async Task<ActionResult<List<Empleado>>> GetInactivos()
        {
            var lista = await _empleadoService.ListarEmpleadosInactivos();
            return Ok(lista);
        }

        // GET: api/empleado/inactivo/{id}
        [HttpGet("inactivo/{id}")]
        public async Task<ActionResult<Empleado>> GetInactivo(int id)
        {
            var empleado = await _empleadoService.ObtenerEmpleadoInactivoPorId(id);
            if (empleado == null)
                return NotFound();
            return Ok(empleado);
        }
    }
}
