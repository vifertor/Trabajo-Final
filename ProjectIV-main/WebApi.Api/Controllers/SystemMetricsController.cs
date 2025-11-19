using Interface;
using Microsoft.AspNetCore.Mvc;
using WebApi.Services;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SystemMetricsController : ControllerBase
    {
        private readonly ISystemMetricsService _metricsService;

        public SystemMetricsController(ISystemMetricsService metricsService)
        {
            _metricsService = metricsService;
        }

        [HttpGet("cpu")]
        public async Task<IActionResult> GetCpuUsage()
        {
            var result = await _metricsService.GetCpuUsageAsync();
            return Ok(result);
        }
    }
}
