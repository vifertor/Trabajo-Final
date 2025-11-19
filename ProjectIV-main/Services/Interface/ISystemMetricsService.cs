using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface ISystemMetricsService
    {
                Task<SystemCpuMetrics> GetCpuUsageAsync();

    }
}