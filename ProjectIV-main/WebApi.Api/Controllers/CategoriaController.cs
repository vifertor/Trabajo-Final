using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CategoriaController : ControllerBase
    {
        private readonly ICategoriaService _categoriaService;

        public CategoriaController(ICategoriaService categoriaService)
        {
            _categoriaService = categoriaService;
        }

        // GET: api/categoria
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Categoria>>> Get()
        {
            var categorias = await _categoriaService.ListarCategorias();
            return Ok(categorias);
        }

        // GET: api/categoria/{id}
        [HttpGet ("{id}")]
        public async Task<ActionResult<Categoria>> Get(int id)
        {
            var categoria = await _categoriaService.MostrarCategoria(id);
            if (categoria == null)
                return NotFound();
            return Ok(categoria);
        }

        // POST: api/categoria  
        [HttpPost]
        public async Task<ActionResult> Post([FromBody] Categoria categoria)
        {
            await _categoriaService.AgregarCategoria(categoria);
            return Ok();
        }

        // PUT: api/categoria/{id}
        [HttpPut ("{id}")]
        public async Task<ActionResult> Put(int id, [FromBody] Categoria categoria)
        {
            var existingCategoria = await _categoriaService.MostrarCategoria(id);
            if (existingCategoria == null)
                return NotFound();

            categoria.Categoria_Id = id;
            await _categoriaService.ActualizarCategoria(categoria);
            return Ok();
        }

        // DELETE: api/categoria/{id} (eliminación lógica)
        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _categoriaService.EliminarCategoria(id);
            return Ok(new { message = "Categoría eliminada lógicamente (Estado cambiado a 0)." });
        }

        // PUT: api/categoria/activate/{id} (reactivar categoría)
        [HttpPut("activate/{id}")]
        public async Task<ActionResult> Activate(int id)
        {
             await _categoriaService.ActivarCategoria(id);
    return Ok(new { message = "Categoria activada correctamente (estado cambiado a 1)." });
        }

        [HttpGet("inactiva/{id}")]
        public async Task<IActionResult> ObtenerInactivaPorId(int id)
        {
            var categoria = await _categoriaService.ObtenerCategoriaInactivaPorId(id);
            if (categoria == null) return NotFound();
            return Ok(categoria);
        }
        [HttpGet("inactivas")]
        public async Task<IActionResult> ObtenerInactivas()
        {
            var lista = await _categoriaService.ListarCategoriasInactivas();
            return Ok(lista);
        }

    }
}
