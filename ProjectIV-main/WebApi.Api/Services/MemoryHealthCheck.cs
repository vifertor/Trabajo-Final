using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace WebApi.Api.Services
{
   public class MemoryHealthCheck : IHealthCheck
    {
        private const long MemoryThresholdBytes = 1024L * 1024L * 512L; // 512 MB

        public Task<HealthCheckResult> CheckHealthAsync(
            HealthCheckContext context,
            CancellationToken cancellationToken = default)
        {
            long usedMemory = GC.GetTotalMemory(forceFullCollection: false);

            if (usedMemory < MemoryThresholdBytes)
            {
                return Task.FromResult(
                    HealthCheckResult.Healthy($"Uso de memoria dentro del límite: {usedMemory / 1024 / 1024} MB"));
            }
            else
            {
                return Task.FromResult(
                    HealthCheckResult.Degraded($"Uso alto de memoria: {usedMemory / 1024 / 1024} MB"));
            }
        }
    }
}
