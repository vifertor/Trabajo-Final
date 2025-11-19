using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;


namespace WebApi.ETL.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ETLMasterController : ControllerBase
    {
        private readonly ETLMasterService _etlMasterService;

        public ETLMasterController(ETLMasterService etlMasterService)
        {
            _etlMasterService = etlMasterService;
        }

        [HttpPost("ejecutar")]
        public async Task<IActionResult> EjecutarETLCompleto()
        {
            var resultado = await _etlMasterService.EjecutarTodoAsync();
            return Ok(new { mensaje = resultado });
        }
    }
}

