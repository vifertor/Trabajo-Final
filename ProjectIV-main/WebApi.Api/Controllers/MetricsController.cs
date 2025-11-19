using Microsoft.AspNetCore.Mvc;
using Interface;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/metrics")]
    public class MetricsController : ControllerBase
    {
        private readonly IMemoryMetricsRepository _repository;

        public MetricsController(IMemoryMetricsRepository repository)
        {
            _repository = repository;
        }

        [HttpGet("memory")]
        public async Task<IActionResult> GetRecent()
        {
            var metrics = await _repository.GetRecentMetricsAsync();
            return Ok(metrics);
        }
    }
}
