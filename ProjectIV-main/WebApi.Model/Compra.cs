namespace WebApi.Models
{
    public class DetalleCompra
    {
        public int Id_DetalleProducto { get; set; }
        public string? ProductoNombre { get; set; }
        public decimal PrecioCompra { get; set; }
        public int Cantidad { get; set; }
        public decimal Subtotal { get; set; } // Se calcula en el SP
    }

    public class Compra
    {
        public int Id_Compra { get; set; }
        public int Id_Proveedor { get; set; }
        public string? ProveedorNombre { get; set; }
        public int Id_Empleado { get; set; }
        public string? EmpleadoNombre { get; set; }
        public decimal MontoTotal { get; set; } // Se calcula en el SP
        public DateTime FechaCompra { get; set; }
        public bool Estado { get; set; }
        public List<DetalleCompra> Detalles { get; set; } = new List<DetalleCompra>();
    }
}
