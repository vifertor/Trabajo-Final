namespace WebApi.Model
{
    public class DetalleCompra
    {
        public int Id_DetalleCompra { get; set; }
        public int Id_Compra { get; set; }
        public int Id_DetalleProducto { get; set; }
        public decimal PrecioCompra { get; set; }
        public int Cantidad { get; set; }
        public decimal Subtotal { get; set; }
        public bool Estado { get; set; }
    }
}