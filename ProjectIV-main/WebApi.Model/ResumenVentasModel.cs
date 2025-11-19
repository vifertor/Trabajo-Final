
namespace WebApi.Model
{
    public class ResumenVentasModel
    {
        public decimal VentasTotales { get; set; }
        public decimal VentasHoy { get; set; }
        public decimal VentasMes { get; set; }
        public int CantidadVentas { get; set; }
    }
}