using MongoDB.Bson;
using MongoDB.Driver;
using System.Diagnostics;

using WebApi.Model;

namespace WebApi.Api.Services
{
    public class DatabaseMetricsService
    {
        private readonly IMongoClient _client;
        private readonly string _adminDbName = "admin";

        public DatabaseMetricsService(IMongoClient client)
        {
            _client = client;
        }

        public async Task<DatabaseMetrics> GetMetricsAsync(CancellationToken cancellationToken = default)
        {
            var metrics = new DatabaseMetrics
            {
                Server = "MongoDB",
                ActiveConnections = 0,
                AvailableConnections = 0,
                WaitingConnections = 0,
                PingMs = 0
            };

            try
            {
                // 1) Ejecutar serverStatus para leer conexiones
                var adminDb = _client.GetDatabase(_adminDbName);
                var command = new BsonDocument("serverStatus", 1);
                var serverStatus = await adminDb.RunCommandAsync<BsonDocument>(command, cancellationToken: cancellationToken);

                if (serverStatus != null && serverStatus.Contains("connections"))
                {
                    var connectionsDoc = serverStatus["connections"].AsBsonDocument;

                    if (connectionsDoc.Contains("current"))
                        metrics.ActiveConnections = connectionsDoc["current"].ToInt32();

                    if (connectionsDoc.Contains("available"))
                        metrics.AvailableConnections = connectionsDoc["available"].ToInt32();

                    // totalCreated es acumulativo, no representa "en espera", pero lo dejamos por si interesa
                    if (connectionsDoc.Contains("totalCreated"))
                        ; // opcional: leer si lo deseas
                }

                // 2) (Opcional) obtener info de conexiones en cola / wait queue vía opcionales de serverStatus
                // Algunos builds muestran "globalLock" u otros subdocumentos, pero no hay siempre "waitQueueSize".
                // Dejamos WaitingConnections en 0 si no está disponible.

                // 3) Medir ping (latencia)
                var sw = Stopwatch.StartNew();
                await adminDb.RunCommandAsync<BsonDocument>(new BsonDocument("ping", 1), cancellationToken: cancellationToken);
                sw.Stop();
                metrics.PingMs = sw.ElapsedMilliseconds;
            }
            catch (Exception)
            {
                // si falla (permiso, no admin, etc.) devolvemos 0s y PingMs = -1 para indicar fallo
                metrics.PingMs = -1;
            }

            return metrics;
        }
    }
}
