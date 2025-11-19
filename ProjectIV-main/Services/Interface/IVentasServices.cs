public interface IVentaService
{
    Task<int> RegistrarVentaAsync(RegistrarVentaRequest venta);
    Task<List<VentaModel>> ObtenerVentasAsync(int? idVenta = null);
    Task<List<DetalleVentaConNombresModel>> ObtenerDetalleVentaAsync(int idVenta);
    Task<bool> ActualizarVentaAsync(VentaModel venta);
    Task<bool> AnularVentaAsync(int idVenta);
    Task<bool> ReactivarVentaAsync(int idVenta);
    Task<List<VentaModel>> ObtenerVentasInactivasAsync();
}
