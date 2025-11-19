using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;

namespace WebApi.ETL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ETLEmpleadoController : ControllerBase
    {
        private readonly ETLEmpleadoService _etlService;

        public ETLEmpleadoController(ETLEmpleadoService etlService)
        {
            _etlService = etlService;
        }

        [HttpPost("transferir")]
        public async Task<IActionResult> TransferirEmpleados()
        {
            var resultado = await _etlService.TransferirEmpleadosAsync();
            return Ok(new { mensaje = resultado });
        }
    }
}
