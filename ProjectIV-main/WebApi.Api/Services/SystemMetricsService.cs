using System.Diagnostics;
using Interface;
using WebApi.Model;

namespace WebApi.Services
{
    public class SystemMetricsService : ISystemMetricsService
    {
        private TimeSpan _lastTotalProcessorTime;
        private DateTime _lastCheckTime;

        public SystemMetricsService()
        {
            var process = Process.GetCurrentProcess();
            _lastTotalProcessorTime = process.TotalProcessorTime;
            _lastCheckTime = DateTime.UtcNow;
        }

        public Task<SystemCpuMetrics> GetCpuUsageAsync()
        {
            var process = Process.GetCurrentProcess();
            
            // CPU tiempo total
            var cpuNow = process.TotalProcessorTime;
            var now = DateTime.UtcNow;

            var cpuUsedMs = (cpuNow - _lastTotalProcessorTime).TotalMilliseconds;
            var timePassedMs = (now - _lastCheckTime).TotalMilliseconds;

            int processorCount = Environment.ProcessorCount;

            double cpuUsage = (cpuUsedMs / (timePassedMs * processorCount)) * 100.0;

            _lastTotalProcessorTime = cpuNow;
            _lastCheckTime = now;

            if (cpuUsage < 0) cpuUsage = 0;
            if (cpuUsage > 100) cpuUsage = 100;

            var result = new SystemCpuMetrics
            {
                CpuUsagePercentage = Math.Round(cpuUsage, 2),
                Timestamp = DateTime.UtcNow
            };

            return Task.FromResult(result);
        }
    }
}
