using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Interface;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using WebApi.Model;

namespace Implementation
{
  
    public class MongoResponseTimeLogRepository : IResponseTimeLogRepository
    {
        private readonly IMongoCollection<ResponseTimeLog> _collection;

        public MongoResponseTimeLogRepository(IOptions<MongoDbSettings> settings)
        {
            var client = new MongoClient(settings.Value.ConnectionString);
            var db = client.GetDatabase(settings.Value.DatabaseName);

            _collection = db.GetCollection<ResponseTimeLog>("response_time_logs");
        }

        public async Task AddAsync(ResponseTimeLog log)
        {
            await _collection.InsertOneAsync(log);
        }
        public async Task<List<ResponseTimeLog>> GetAllAsync()
{
    return await _collection.Find(_ => true).ToListAsync();
}

     
    }
}