using Interface;
using MongoDB.Driver;
using WebApi.Model;

namespace Implementation
{
    public class UserActivityService : IUserActivityService
    {
        private readonly IMongoCollection<UserActivity> _collection;

        public UserActivityService(IMongoClient mongo)
        {
            var db = mongo.GetDatabase("MetricsDB");
            _collection = db.GetCollection<UserActivity>("UserActivity");
        }

        public async Task RegisterActivityAsync(UserActivity activity)
        {
            await _collection.InsertOneAsync(activity);
        }

        public async Task<List<UserActivity>> GetActiveUsersAsync()
        {
            return await _collection.Find(a => a.IsActive).ToListAsync();
        }

        public async Task<List<UserActivity>> GetUserHistoryAsync(int userId)
        {
            return await _collection.Find(a => a.UserId == userId)
                                    .SortByDescending(a => a.LastActivity)
                                    .ToListAsync();
        }

        public async Task MarkUserInactiveAsync(int userId)
        {
            var update = Builders<UserActivity>.Update.Set(a => a.IsActive, false);
            await _collection.UpdateManyAsync(a => a.UserId == userId, update);
        }
    }
}
