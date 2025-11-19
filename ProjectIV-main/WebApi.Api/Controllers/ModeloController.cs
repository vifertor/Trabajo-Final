using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Interface;
using WebApi.Model;
namespace WebApi.Api.Controllers
{
   [ApiController]
    [Route("api/[controller]")]
    public class ModeloController : ControllerBase
    {
        private readonly IModeloService _modeloService;

        public ModeloController(IModeloService modeloService)
        {
            _modeloService = modeloService;
        }

         [HttpGet]
        public async Task<ActionResult<IEnumerable<Modelo>>> Get()
        {
            var lista = await _modeloService.ListarModelos();
            return Ok(lista);
        }

        // GET: api/modelo/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Modelo>> Get(int id)
        {
            var modelo = await _modeloService.MostrarModelo(id);
            if (modelo == null) return NotFound();
            return Ok(modelo);
        }

        // POST: api/modelo
        [HttpPost]
        public async Task<ActionResult> Post([FromBody] Modelo modelo)
        {
            await _modeloService.AgregarModelo(modelo);
            return Ok();
        }

        // PUT: api/modelo/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult> Put(int id, [FromBody] Modelo modelo)
        {
            var existente = await _modeloService.MostrarModelo(id);
            if (existente == null) return NotFound();

            modelo.IdModelo = id;
            await _modeloService.ActualizarModelo(modelo);
            return Ok();
        }

        // DELETE: api/modelo/{id} (soft-delete)
        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _modeloService.EliminarModelo(id);
            return Ok(new { message = "Modelo desactivado (Estado = 0)." });
        }

        // PUT: api/modelo/activate/{id}
        [HttpPut("activate/{id}")]
        public async Task<ActionResult> Activate(int id)
        {
            await _modeloService.ActivarModelo(id);
            return Ok(new { message = "Modelo activado correctamente (Estado = 1)." });
        }

        // GET: api/modelo/inactivos
        [HttpGet("inactivos")]
        public async Task<ActionResult<IEnumerable<Modelo>>> GetInactivos()
        {
            var lista = await _modeloService.ListarModelosInactivos();
            return Ok(lista);
        }

        // GET: api/modelo/inactivo/{id}
        [HttpGet("inactivo/{id}")]
        public async Task<ActionResult<Modelo>> GetInactivo(int id)
        {
            var modelo = await _modeloService.ObtenerModeloInactivoPorId(id);
            if (modelo == null) return NotFound();
            return Ok(modelo);
        }
    }
}