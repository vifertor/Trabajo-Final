using System;

namespace WebApi.Model
{
    public class Compra
    {
        public int Id_Compra { get; set; }
        public int Id_Proveedor { get; set; }
        public int Id_Empleado { get; set; }
        public decimal MontoTotal { get; set; }
        public DateTime FechaCompra { get; set; }
        public bool Estado { get; set; }
    }
}