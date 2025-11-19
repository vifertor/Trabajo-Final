using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc;
using WebApi.Api.DTO;
using Microsoft.AspNetCore.Authorization;
using Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers
{

    [ApiController]
    [Route("api/[controller]")]
    public class InventarioController : ControllerBase
    {
        private readonly IInventarioService _inventarioService;

        public InventarioController(IInventarioService inventarioService)
        {
            _inventarioService = inventarioService;
        }

        [HttpGet]
        public ActionResult<List<Inventario>> Get()
        {
            return Ok(_inventarioService.GetInventario());
        }

        [HttpGet("buscar")]
        public ActionResult<List<Inventario>> Buscar([FromQuery] string filtro)
        {
            var resultado = _inventarioService.BuscarInventario(filtro);
            return Ok(resultado);
        }

        [HttpGet("resumen")]
        public async Task<IActionResult> ObtenerResumenInventario()
        {
            var resumen = await _inventarioService.ObtenerResumenInventarioAsync();
            if (resumen == null)
                return NotFound(new { mensaje = "No se pudo obtener el resumen de inventario." });

            return Ok(resumen);
        }

        [HttpGet("stock-bajo-lista")]
        public async Task<IActionResult> ObtenerProductosStockBajo()
        {
            var productos = await _inventarioService.ObtenerProductosStockBajoAsync();
            return Ok(productos);
        }

    
    }
}