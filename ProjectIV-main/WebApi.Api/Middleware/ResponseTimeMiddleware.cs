using System.Diagnostics;
using Interface;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;


using WebApi.Model;

namespace WebApi.Api.Middleware
{
    public class ResponseTimeMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ResponseTimeMiddleware> _logger;
        private readonly long _threshold = 500;

        public ResponseTimeMiddleware(RequestDelegate next, ILogger<ResponseTimeMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context, IResponseTimeLogRepository repository)
        {
            var watch = Stopwatch.StartNew();

            context.Response.OnStarting(() =>
            {
                context.Response.Headers["X-Response-Time"] = $"{watch.ElapsedMilliseconds}ms";
                return Task.CompletedTask;
            });

            await _next(context);

            watch.Stop();

            var duration = watch.ElapsedMilliseconds;

            var log = new ResponseTimeLog
            {
                Path = context.Request.Path,
                Method = context.Request.Method,
                QueryString = context.Request.QueryString.Value,
                DurationMs = duration,
                StatusCode = context.Response.StatusCode,
                Timestamp = DateTime.UtcNow,
                IsSlowRequest = duration > _threshold,
                UserAgent = context.Request.Headers["User-Agent"],
                ClientIp = context.Connection.RemoteIpAddress?.ToString()
            };

            await repository.AddAsync(log);
        }
    }
}
