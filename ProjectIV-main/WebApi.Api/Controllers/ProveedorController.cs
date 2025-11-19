using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProveedorController : Controller
    {
        private readonly IProveedorService _service;

        public ProveedorController(IProveedorService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Proveedor>>> Get()
        {
            return Ok(await _service.ListarProveedores());
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Proveedor>> Get(int id)
        {
            var p = await _service.MostrarProveedor(id);
            if (p == null) return NotFound();
            return Ok(p);
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Proveedor p)
        {
            await _service.AgregarProveedor(p);
            return Ok();
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Put(int id, [FromBody] Proveedor p)
        {
            var exists = await _service.MostrarProveedor(id);
            if (exists == null) return NotFound();
            p.IdProveedor = id;
            await _service.ActualizarProveedor(p);
            return Ok();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.EliminarProveedor(id);
            return Ok(new { message = "Proveedor desactivado." });
        }

        [HttpPut("activar/{id}")]
        public async Task<IActionResult> Activate(int id)
        {
            await _service.ActivarProveedor(id);
            return Ok(new { message = "Proveedor activado." });
        }

        [HttpGet("inactivos")]
        public async Task<ActionResult<IEnumerable<Proveedor>>> GetInactivos()
        {
            return Ok(await _service.ListarProveedoresInactivos());
        }

        [HttpGet("inactivo/{id}")]
        public async Task<ActionResult<Proveedor>> GetInactivo(int id)
        {
            var p = await _service.ObtenerProveedorInactivoPorId(id);
            if (p == null) return NotFound();
            return Ok(p);
        }
    }
}