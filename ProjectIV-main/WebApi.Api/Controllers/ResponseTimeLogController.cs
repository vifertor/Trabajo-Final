using Interface;
using Microsoft.AspNetCore.Mvc;


namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ResponseTimeLogController : ControllerBase
    {
        private readonly IResponseTimeLogRepository _repository;

        public ResponseTimeLogController(IResponseTimeLogRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var logs = await _repository.GetAllAsync();
            return Ok(logs);
        }
    }
}
