using Microsoft.AspNetCore.Mvc;
using WebApi.Model;
using Interface;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RolController : ControllerBase
    {
        private readonly IRolService _rolService;

        public RolController(IRolService rolService)
        {
            _rolService = rolService;
        }

        // GET: api/Rol
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var roles = await _rolService.GetAllAsync();
            return Ok(roles);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var rol = await _rolService.GetByIdAsync(id);
            if (rol == null) return NotFound();
            return Ok(rol);
        }

        [HttpPost("crear")]
        public async Task<IActionResult> Crear([FromBody] Rol rol)
        {
            try
            {
                var nuevoRol = await _rolService.CreateAsync(rol.Nombre_rol, rol.Descripcion);
                return Ok(nuevoRol);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = "Error al crear rol", detalle = ex.Message });
            }
        }
    }
}
