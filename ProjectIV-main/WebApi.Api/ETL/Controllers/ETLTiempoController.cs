using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;

namespace WebApi.ETL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ETLTiempoController : ControllerBase
    {
        private readonly ETLTiempoService _etlService;

        public ETLTiempoController(ETLTiempoService etlService)
        {
            _etlService = etlService;
        }

        [HttpPost("generar")]
        public async Task<IActionResult> GenerarDimTiempo([FromQuery] DateTime fechaInicio, [FromQuery] DateTime fechaFin)
        {
            var resultado = await _etlService.GenerarDimTiempoAsync(fechaInicio, fechaFin);
            return Ok(new { mensaje = resultado });
        }
    }
}
