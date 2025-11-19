using Interface;
using Microsoft.AspNetCore.Mvc;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserActivityController : ControllerBase
    {
        private readonly IUserActivityService _service;

        public UserActivityController(IUserActivityService service)
        {
            _service = service;
        }

        [HttpGet("active")]
        public async Task<IActionResult> GetActive()
        {
            return Ok(await _service.GetActiveUsersAsync());
        }

        [HttpGet("history/{userId}")]
        public async Task<IActionResult> GetHistory(int userId)
        {
            return Ok(await _service.GetUserHistoryAsync(userId));
        }
    }
}
