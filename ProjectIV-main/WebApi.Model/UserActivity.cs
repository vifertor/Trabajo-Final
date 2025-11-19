using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace WebApi.Model
{
    public class UserActivity
    {
          [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }

        public int UserId { get; set; }
        public string Username { get; set; }

        public DateTime LastActivity { get; set; }
        public string Action { get; set; }  // "Login", "Request", "Logout"

        public string Ip { get; set; }
        public string UserAgent { get; set; }

        public bool IsActive { get; set; }
    }
}