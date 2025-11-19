using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApi.Model;

namespace Interface
{
    public interface ITokenUsageService
    {
           Task RegisterTokenAsync(TokenUsage usage);
        Task<List<TokenUsage>> GetAllAsync();
        Task<List<TokenUsage>> GetByUserAsync(string userId);
        Task UpdateStatusAsync(string token, string newStatus);
         Task<IEnumerable<TokenUsage>> GetAllTokensAsync();
        Task<TokenUsage?> GetTokenByIdAsync(string id);
    }
}