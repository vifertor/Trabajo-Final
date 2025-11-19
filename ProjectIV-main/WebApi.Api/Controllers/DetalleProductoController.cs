using Microsoft.AspNetCore.Mvc;
using Interface;
using WebApi.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DetalleProductoController : ControllerBase
    {
        private readonly IDetalleProductoService _service;

        public DetalleProductoController(IDetalleProductoService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<ActionResult<List<DetalleProductoConNombres>>> Get() =>
            Ok(await _service.GetAll());

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var detalle = await _service.GetById(id);
            if (detalle == null) return NotFound();
            return Ok(detalle);
        }

        [HttpGet("activos-paged")]
        public async Task<ActionResult<List<DetalleProductoConNombres>>> GetActivosPaginados(
            [FromQuery] int pageIndex = 1,
            [FromQuery] int pageSize = 10)
        {
            var detalles = await _service.GetActiveAscendingPaged(pageIndex, pageSize);
            return Ok(detalles);
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] DetalleProducto detalle)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var creado = await _service.Create(detalle);
            if (!creado) return BadRequest("Error al crear el detalle de producto.");
            return Ok(new { mensaje = "Detalle de producto creado correctamente." });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, [FromBody] DetalleProducto detalle)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var actualizado = await _service.Update(id, detalle);
            if (!actualizado) return NotFound("No se pudo actualizar el detalle.");
            return Ok(new { mensaje = "Detalle actualizado correctamente." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var desactivado = await _service.Delete(id);
            if (!desactivado) return NotFound("No se pudo desactivar el detalle.");
            return Ok(new { mensaje = "Detalle desactivado correctamente." });
        }
    }
}
