using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;

namespace WebApi.ETL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ETLClienteController : ControllerBase
    {
        private readonly ETLClienteService _etlService;

        public ETLClienteController(ETLClienteService etlService)
        {
            _etlService = etlService;
        }

        [HttpPost("transferir")]
        public async Task<IActionResult> TransferirClientes()
        {
            var resultado = await _etlService.TransferirClientesAsync();
            return Ok(new { mensaje = resultado });
        }
    }
}
