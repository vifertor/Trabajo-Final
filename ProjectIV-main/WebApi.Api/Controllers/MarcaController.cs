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
    public class MarcaController : Controller
    {
         private readonly IMarcaService _marcaService;

        public MarcaController(IMarcaService marcaService)
        {
            _marcaService = marcaService;
        }

        // GET: api/marca

       
                //api/proveedor
     [HttpPost]
    public async Task<ActionResult> Add([FromBody] Marca marca)
        {
            await _marcaService.AgregarMarca(marca);
            return Ok();
        }


    [Authorize(Roles = "admin")]
   [HttpGet]
        public async Task<ActionResult<IEnumerable<Marca>>> Get()
        {
            var marcas = await _marcaService.ListarMarcasActivas();
            return Ok(marcas);
        }
       
    


       [HttpGet("{id}")]
        public async Task<ActionResult<Marca>> Get(int id)
        {
            var marca = await _marcaService.MostrarMarca(id);
            if (marca == null)
            {
                return NotFound();
            }
            return Ok(marca);
        }
        [HttpGet("Inactivos/{id}")]
        public async Task<ActionResult<Marca>> Gett(int id)
        {
            var marca = await _marcaService.MostrarMarcaINACTIVA(id);
            if (marca == null)
            {
                return NotFound();
            }
            return Ok(marca);
        }
   

           [HttpPut("{id}")]
        public async Task<ActionResult> Update(int id, [FromBody] Marca marca)
        {
            var existingMarca = await _marcaService.MostrarMarca(id);
            if (existingMarca == null) return NotFound();

            marca.Marca_Id = id;
            await _marcaService.ActualizarMarca(marca);
            return Ok();
        }



         [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _marcaService.EliminarMarca(id);
            return Ok(new { message = "Marca eliminada lógicamente (estado cambiado a 0)." });
        }
// Activar marca por ID
[HttpPut("activar/{id}")]
public async Task<ActionResult> Activar(int id)
{
    await _marcaService.ActivarMarca(id);
    return Ok(new { message = "Marca activada correctamente (estado cambiado a 1)." });
}

// Listar marcas inactivas
[HttpGet("inactivas")]
public async Task<ActionResult<IEnumerable<Marca>>> GetInactivas()
{
    var marcas = await _marcaService.ListarMarcasInactivas();
    return Ok(marcas);
}


    }
    




}