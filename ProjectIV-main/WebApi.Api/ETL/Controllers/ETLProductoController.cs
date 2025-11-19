using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;

namespace WebApi.ETL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ETLProductoController : ControllerBase
    {
        private readonly ETLProductoService _etlService;

        public ETLProductoController(ETLProductoService etlService)
        {
            _etlService = etlService;
        }

        [HttpPost("transferir")]
        public async Task<IActionResult> TransferirProductos()
        {
            var resultado = await _etlService.TransferirProductosAsync();
            return Ok(new { mensaje = resultado });
        }
    }
}
