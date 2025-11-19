using Interface;
using System.Security.Claims;

namespace WebApi.Api.Middleware
{
    public class UserActivityMiddleware
    {
        private readonly RequestDelegate _next;

        public UserActivityMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, IUserActivityService activityService)
        {
            var userId = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (userId != null)
            {
                var activity = new WebApi.Model.UserActivity
                {
                    UserId = int.Parse(userId),
                    Username = context.User.Identity.Name ?? "N/A",
                    LastActivity = DateTime.UtcNow,
                    Action = "Request",
                    Ip = context.Connection.RemoteIpAddress?.ToString(),
                    UserAgent = context.Request.Headers["User-Agent"].ToString(),
                    IsActive = true
                };

                await activityService.RegisterActivityAsync(activity);
            }

            await _next(context);
        }
    }
}
