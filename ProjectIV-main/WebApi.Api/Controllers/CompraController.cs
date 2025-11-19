using Microsoft.AspNetCore.Mvc;
using WebApi.Models;
using WebApi.Services.Interface;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CompraController : ControllerBase
    {
        private readonly ICompraService _service;

        public CompraController(ICompraService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetCompras()
        {
            var lista = await _service.GetComprasAsync();
            return Ok(lista);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCompraById(int id)
        {
            var compra = await _service.GetCompraByIdAsync(id);
            if (compra == null) return NotFound(new { message = "Compra no encontrada." });
            return Ok(compra);
        }

        [HttpPost]
        public async Task<IActionResult> RegistrarCompra([FromBody] Compra compra)
        {
            var result = await _service.RegistrarCompraAsync(compra);
            if (!result) return BadRequest(new { message = "No se pudo registrar la compra." });
            return Ok(new { message = "Compra registrada correctamente." });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> EliminarCompra(int id)
        {
            var result = await _service.EliminarCompraAsync(id);
            if (!result) return NotFound(new { message = "Compra no encontrada o no se pudo anular." });
            return Ok(new { message = "Compra anulada correctamente." });
        }
    }
}
