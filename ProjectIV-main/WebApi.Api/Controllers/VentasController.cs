using Microsoft.AspNetCore.Mvc;
using WebApi.Services.Interface;
using WebApi.Model;
using System.Threading.Tasks;
using System.Collections.Generic;
using System;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VentaController : ControllerBase
    {
        private readonly IVentaService _ventaService;

        public VentaController(IVentaService ventaService)
        {
            _ventaService = ventaService;
        }

        [HttpPost]
        public async Task<IActionResult> RegistrarVenta([FromBody] RegistrarVentaRequest venta)
        {
            if (venta == null) return BadRequest("Solicitud vacía.");

            var errores = new List<string>();
            if (string.IsNullOrWhiteSpace(venta.Nomb_Cliente)) errores.Add("Campo 'nomb_cliente' obligatorio.");
            if (venta.IdEmpleado <= 0) errores.Add("Campo 'idEmpleado' debe ser positivo.");
            if (venta.DetallesVenta == null || venta.DetallesVenta.Count == 0) errores.Add("Debe incluir al menos un detalle.");

            if (errores.Count > 0) return BadRequest(new { errores });

            try
            {
                int idVenta = await _ventaService.RegistrarVentaAsync(venta);
                return Ok(new { IdVenta = idVenta, Mensaje = "Venta registrada correctamente." });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> ObtenerVentas([FromQuery] int? idVenta = null)
            => Ok(await _ventaService.ObtenerVentasAsync(idVenta));

        [HttpGet("Detalle/{idVenta}")]
        public async Task<IActionResult> ObtenerDetalle(int idVenta)
            => Ok(await _ventaService.ObtenerDetalleVentaAsync(idVenta));

        [HttpPut]
        public async Task<IActionResult> ActualizarVenta([FromBody] VentaModel venta)
            => Ok(await _ventaService.ActualizarVentaAsync(venta));

        [HttpDelete("{idVenta}")]
        public async Task<IActionResult> AnularVenta(int idVenta)
            => Ok(await _ventaService.AnularVentaAsync(idVenta));

        [HttpPut("activar/{idVenta}")]
        public async Task<IActionResult> ReactivarVenta(int idVenta)
            => Ok(await _ventaService.ReactivarVentaAsync(idVenta));

        [HttpGet("inactivas")]
        public async Task<IActionResult> ObtenerVentasInactivas()
            => Ok(await _ventaService.ObtenerVentasInactivasAsync());
    }
}
