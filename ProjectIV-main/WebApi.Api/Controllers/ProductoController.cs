using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductoController : ControllerBase
    {
        private readonly IProductoService _service;

        public ProductoController(IProductoService service)
        {
            _service = service;
        }

        // GET: api/producto
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Producto>>> Get()
            => Ok(await _service.ListarProductos());

        // GET: api/producto/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Producto>> Get(int id)
        {
            var prod = await _service.MostrarProducto(id);
            return prod == null ? NotFound() : Ok(prod);
        }

        // POST: api/producto
        [HttpPost]
        public async Task<ActionResult> Post([FromBody] Producto producto)
        {
            await _service.AgregarProducto(producto);
            return Ok();
        }

        // PUT: api/producto/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult> Put(int id, [FromBody] Producto producto)
        {
            var existing = await _service.MostrarProducto(id);
            if (existing == null) return NotFound();
            producto.IdProducto = id;
            await _service.ActualizarProducto(producto);
            return Ok();
        }

        // DELETE: api/producto/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _service.EliminarProducto(id);
            return Ok(new { message = "Producto desactivado (Estado = 0)." });
        }

        // PUT: api/producto/activate/{id}
        [HttpPut("activate/{id}")]
        public async Task<ActionResult> Activate(int id)
        {
            await _service.ActivarProducto(id);
            return Ok(new { message = "Producto activado correctamente (Estado = 1)." });
        }

        // GET: api/producto/inactivos
        [HttpGet("inactivos")]
        public async Task<ActionResult<IEnumerable<Producto>>> GetInactivos()
            => Ok(await _service.ListarProductosInactivos());

        // GET: api/producto/inactivo/{id}
        [HttpGet("inactivo/{id}")]
        public async Task<ActionResult<Producto>> GetInactivo(int id)
        {
            var prod = await _service.ObtenerProductoInactivoPorId(id);
            return prod == null ? NotFound() : Ok(prod);
        }
    }
}

