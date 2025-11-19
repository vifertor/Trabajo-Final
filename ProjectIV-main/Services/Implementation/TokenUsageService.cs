using Interface;
using MongoDB.Driver;
using WebApi.Model;
using WebApi.Services.Interface;

namespace Implementation
{
    public class TokenUsageService : ITokenUsageService
    {
        private readonly IMongoCollection<TokenUsage> _collection;

        public TokenUsageService(IMongoClient mongoClient)
        {
            var database = mongoClient.GetDatabase("MetricsDB");
            _collection = database.GetCollection<TokenUsage>("TokenUsage");
        }

        public async Task RegisterTokenAsync(TokenUsage usage)
        {
            await _collection.InsertOneAsync(usage);
        }

        public async Task<List<TokenUsage>> GetAllAsync()
        {
            return await _collection.Find(_ => true).ToListAsync();
        }

        public async Task<List<TokenUsage>> GetByUserAsync(string userId)
        {
            return await _collection.Find(t => t.UserId == userId).ToListAsync();
        }

        public async Task UpdateStatusAsync(string token, string newStatus)
        {
            var update = Builders<TokenUsage>.Update.Set(t => t.Status, newStatus);
            await _collection.UpdateOneAsync(t => t.Token == token, update);
        }
        public async Task<IEnumerable<TokenUsage>> GetAllTokensAsync()
        {
            return await _collection.Find(_ => true).ToListAsync();
        }

        public async Task<TokenUsage?> GetTokenByIdAsync(string id)
        {
            return await _collection.Find(x => x.Id == id).FirstOrDefaultAsync();
        }
    }
}
