using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
    public class SystemCpuMetrics
    {
            public double CpuUsagePercentage { get; set; }
        public DateTime Timestamp { get; set; }
    }
}