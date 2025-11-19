namespace WebApi.Api.Middleware
{
    public static class UserActivityMiddlewareExtensions
    {
        public static IApplicationBuilder UseUserActivityMiddleware(this IApplicationBuilder app)
        {
            return app.UseMiddleware<UserActivityMiddleware>();
        }
    }
}
