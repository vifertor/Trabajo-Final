using Microsoft.AspNetCore.Mvc;
using WebApi.Api.Services;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/SystemMetrics")]
    public class DatabaseMetricsController : ControllerBase
    {
        private readonly DatabaseMetricsService _metricsService;

        public DatabaseMetricsController(DatabaseMetricsService metricsService)
        {
            _metricsService = metricsService;
        }

        [HttpGet("database")]
        public async Task<IActionResult> GetDatabaseMetrics(CancellationToken cancellationToken)
        {
            var result = await _metricsService.GetMetricsAsync(cancellationToken);
            return Ok(result);
        }
    }
}
