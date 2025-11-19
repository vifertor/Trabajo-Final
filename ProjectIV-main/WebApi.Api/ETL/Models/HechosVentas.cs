

namespace WebApi.Models.ETL
{
    public class HechosVentas
    {
        public int IdVenta { get; set; }
        public int IdDetalleProducto { get; set; }
        public int IdCliente { get; set; }
        public int IdEmpleado { get; set; }
        public DateTime Fecha { get; set; }
        public double TotalVenta { get; set; }
        public int CantidadVendida { get; set; }
        public double PrecioUnitario { get; set; }
    }
}
