using System;

namespace WebApi.Models
{
    public class CompraDetalleView
    {
        public int Id_Compra { get; set; }
        public string? Proveedor { get; set; }
        public string? Empleado { get; set; }
        public decimal MontoTotal { get; set; }
        public DateTime FechaCompra { get; set; }
        public string? EstadoTexto { get; set; }

        public int Id_DetalleCompra { get; set; }
        public string? Producto { get; set; }
        public decimal PrecioCompra { get; set; }
        public int Cantidad { get; set; }
        public decimal Subtotal { get; set; }
    }
}
