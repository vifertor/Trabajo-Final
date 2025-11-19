using Interface;
using Microsoft.AspNetCore.Mvc;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TokenUsageController : ControllerBase
    {
        private readonly ITokenUsageService _tokenService;

        public TokenUsageController(ITokenUsageService tokenService)
        {
            _tokenService = tokenService;
        }

        // GET: api/TokenUsage
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var tokens = await _tokenService.GetAllTokensAsync();
            return Ok(tokens);
        }
        
    }
}
