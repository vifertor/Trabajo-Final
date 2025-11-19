using System;
using System.Text;
using System.Threading.Tasks;
using WebApi.ETL.Implementation;

namespace WebApi.ETL.Implementation
{
    public class ETLMasterService
    {
        private readonly ETLClienteService _clienteService;
        private readonly ETLEmpleadoService _empleadoService;
        private readonly ETLProductoService _productoService;
        private readonly ETLTiempoService _tiempoService;
        private readonly ETLVentasService _ventasService;

        public ETLMasterService(
            ETLClienteService clienteService,
            ETLEmpleadoService empleadoService,
            ETLProductoService productoService,
            ETLTiempoService tiempoService,
            ETLVentasService ventasService)
        {
            _clienteService = clienteService;
            _empleadoService = empleadoService;
            _productoService = productoService;
            _tiempoService = tiempoService;
            _ventasService = ventasService;
        }

        public async Task<string> EjecutarTodoAsync()
        {
            var sb = new StringBuilder();

            try
            {
                sb.AppendLine("Iniciando ETL completo...");

                // 1️⃣ DimCliente
                var resultadoCliente = await _clienteService.TransferirClientesAsync();
                sb.AppendLine($"DimCliente: {resultadoCliente}");

                // 2️⃣ DimEmpleado
                var resultadoEmpleado = await _empleadoService.TransferirEmpleadosAsync();
                sb.AppendLine($"DimEmpleado: {resultadoEmpleado}");

                // 3️⃣ DimProducto
                var resultadoProducto = await _productoService.TransferirProductosAsync();
                sb.AppendLine($"DimProducto: {resultadoProducto}");

                // 4️⃣ DimTiempo
                // Definir rango de fechas (puede ajustarse según tus datos)
                DateTime fechaMin = new DateTime(2024, 1, 1);
                DateTime fechaMax = DateTime.Today;
                var resultadoTiempo = await _tiempoService.GenerarDimTiempoAsync(fechaMin, fechaMax);
                sb.AppendLine($"DimTiempo: {resultadoTiempo}");

                // 5️⃣ HechosVentas
                var resultadoVentas = await _ventasService.TransferirHechosVentasAsync();
                sb.AppendLine($"HechosVentas: {resultadoVentas}");

                sb.AppendLine("ETL completo finalizado correctamente.");
            }
            catch (Exception ex)
            {
                sb.AppendLine($"Error durante ETL: {ex.Message}");
            }

            return sb.ToString();
        }
    }
}
