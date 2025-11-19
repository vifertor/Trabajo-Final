namespace WebApi.Model
{
    public class VistaDetalleProducto
    {
        public int Id_DetalleProducto { get; set; }
        public string NombreProducto { get; set; }
        public string DescripcionProducto { get; set; }
        public string Marca { get; set; }
        public string Categoria { get; set; }
        public string Modelo { get; set; }
        public decimal PrecioUnitario { get; set; }
        public bool Estado { get; set; }
        public DateTime FechaRegistro { get; set; }
    }
}
