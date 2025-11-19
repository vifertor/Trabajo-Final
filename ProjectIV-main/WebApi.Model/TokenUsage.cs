using System;
using System.Text.Json.Serialization;

namespace WebApi.Model
{
    public class TokenUsage
    {
        public string Id { get; set; } = string.Empty;

        public string UserId { get; set; } = string.Empty;

        // ❌ No exponer el token en JSON
        [JsonIgnore]
        public string Token { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; }
        public DateTime? Expiration { get; set; }
        public string? IpAddress { get; set; }
        public string Status { get; set; } = string.Empty;

        // 🔥 NUEVO: mostrar nombre en JSON
        public string Username { get; set; } = string.Empty;
    }
}
