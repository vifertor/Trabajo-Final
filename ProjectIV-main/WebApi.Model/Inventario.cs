namespace WebApi.Model
{

    public class Inventario
    {
        public int IdInventario { get; set; }
        public int IdDetalleProducto { get; set; }
        public string NombreProducto { get; set; }
        public string Marca { get; set; }
        public string Modelo { get; set; }
        public string Categoria { get; set; }
        public decimal PrecioUnitario { get; set; }
        public int Cantidad { get; set; }
        public bool Estado { get; set; }
        public DateTime FechaRegistro { get; set; }
    }

}