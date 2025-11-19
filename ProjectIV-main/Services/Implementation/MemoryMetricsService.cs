using System.Diagnostics;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using WebApi.Model;
using Interface;
using Microsoft.Extensions.DependencyInjection;

namespace Implementation
{
    public class MemoryMetricsSettings
    {
        public int CollectionIntervalSeconds { get; set; } = 30;
        public double WarningThresholdMB { get; set; } = 500;
        public double CriticalThresholdMB { get; set; } = 800;
    }

    public class MemoryMetricsService : BackgroundService
    {
        private readonly ILogger<MemoryMetricsService> _logger;
        private readonly MemoryMetricsSettings _settings;
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly PerformanceCounter _cpuCounter;

        public MemoryMetricsService(
            ILogger<MemoryMetricsService> logger,
            IOptions<MemoryMetricsSettings> settings,
            IServiceScopeFactory scopeFactory)
        {
            _logger = logger;
            _settings = settings.Value;
            _scopeFactory = scopeFactory;
            _cpuCounter = new PerformanceCounter("Processor", "% Processor Time", "_Total");
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("✅ Servicio de métricas de memoria iniciado");

            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    var process = Process.GetCurrentProcess();
                    var memoryMB = process.WorkingSet64 / 1024.0 / 1024.0;
                    var gcMemory = GC.GetTotalMemory(false) / 1024.0 / 1024.0;
                    var cpuUsage = await GetCpuUsage();

                    var status = memoryMB >= _settings.CriticalThresholdMB
                        ? "Critical"
                        : memoryMB >= _settings.WarningThresholdMB
                            ? "Warning"
                            : "Normal";

                    // ✅ Crear un nuevo scope para usar el repositorio
                    using (var scope = _scopeFactory.CreateScope())
                    {
                        var repository = scope.ServiceProvider.GetRequiredService<IMemoryMetricsRepository>();

                        await repository.AddAsync(new MemoryMetric
                        {
                            ProcessMemoryMB = memoryMB,
                            GCMemoryMB = gcMemory,
                            CpuUsage = cpuUsage,
                            Status = status
                        });
                    }

                   _logger.LogDebug(
                        "Uso de memoria: {ProcessMemory} MB | GC: {GCMemory} MB | CPU: {CpuUsage}% | Estado: {Status}",
                        memoryMB, gcMemory, cpuUsage, status);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "❌ Error al recolectar métricas");
                }

                await Task.Delay(TimeSpan.FromSeconds(_settings.CollectionIntervalSeconds), stoppingToken);
            }
        }

        private async Task<float> GetCpuUsage()
        {
            _cpuCounter.NextValue();
            await Task.Delay(500);
            return _cpuCounter.NextValue();
        }
    }
}
