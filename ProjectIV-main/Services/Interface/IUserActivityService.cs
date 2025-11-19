using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface IUserActivityService
    {
        Task RegisterActivityAsync(UserActivity activity);
        Task<List<UserActivity>> GetActiveUsersAsync();
        Task<List<UserActivity>> GetUserHistoryAsync(int userId);
        Task MarkUserInactiveAsync(int userId);
    }
}