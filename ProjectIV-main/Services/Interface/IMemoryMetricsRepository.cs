using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;
namespace Interface
{
    public interface IMemoryMetricsRepository
    {
        Task AddAsync(MemoryMetric metric);
        Task<IEnumerable<MemoryMetric>> GetRecentMetricsAsync(int limit = 100);
    }
}