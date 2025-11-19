using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
namespace WebApi.Api.Middleware
{
   public static class ResponseTimeExtensions
    {
        public static IApplicationBuilder UseResponseTimeMiddleware(this IApplicationBuilder app)
        {
            return app.UseMiddleware<ResponseTimeMiddleware>();
        }
    }
}