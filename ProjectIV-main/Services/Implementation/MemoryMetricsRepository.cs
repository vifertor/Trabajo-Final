using MongoDB.Driver;
using Microsoft.Extensions.Options;
using WebApi.Model;

using Interface;

namespace Implementation
{
    public class MemoryMetricsRepository : IMemoryMetricsRepository
    {
        private readonly IMongoCollection<MemoryMetric> _metrics;

        public MemoryMetricsRepository(IOptions<MongoDbSettings> settings)
        {
            var client = new MongoClient(settings.Value.ConnectionString);
            var database = client.GetDatabase(settings.Value.DatabaseName);
            _metrics = database.GetCollection<MemoryMetric>("MemoryMetrics");
        }

        public async Task AddAsync(MemoryMetric metric)
        {
            await _metrics.InsertOneAsync(metric);
        }

        public async Task<IEnumerable<MemoryMetric>> GetRecentMetricsAsync(int limit = 100)
        {
            return await _metrics.Find(_ => true)
                .SortByDescending(x => x.Timestamp)
                .Limit(limit)
                .ToListAsync();
        }
    }

    public class MongoDbSettings
    {
        public string ConnectionString { get; set; } = string.Empty;
        public string DatabaseName { get; set; } = string.Empty;
    }
}
