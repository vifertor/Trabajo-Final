using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;
using WebApi.Models.ETL;

namespace WebApi.ETL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ETLVentasController : ControllerBase
    {
        private readonly ETLVentasService _etlService;

        public ETLVentasController(ETLVentasService etlService)
        {
            _etlService = etlService;
        }

        // POST: api/ETLVentas/transferir
        [HttpPost("transferir")]
        public async Task<IActionResult> TransferirHechosVentas()
        {
            var resultado = await _etlService.TransferirHechosVentasAsync();
            return Ok(new { mensaje = resultado });
        }

        // GET: api/ETLVentas
        [HttpGet]
        public async Task<ActionResult<List<HechosVentas>>> ObtenerHechosVentas()
        {
            var lista = await _etlService.ObtenerHechosVentasAsync();
            return Ok(lista);
        }
    }
}
