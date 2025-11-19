using System;
using System.Collections.Generic;

namespace WebApi.Model
{
    public class CompraRequest
    {
        public int? Id_Compra { get; set; } // null para POST, valor para PUT
        public int Id_Proveedor { get; set; }
        public int Id_Empleado { get; set; }
        public DateTime FechaCompra { get; set; }
        public List<DetalleCompra> Detalles { get; set; }
    }
}