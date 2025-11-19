using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model
{
      public class DatabaseMetrics
    {
        public string Server { get; set; } = "MongoDB";
        public int ActiveConnections { get; set; }
        public int AvailableConnections { get; set; }
        public int WaitingConnections { get; set; }
        public long PingMs { get; set; }
    }
}