public class VentaModel
{
    public int IdVenta { get; set; }
    public string Nomb_Cliente { get; set; }
    public int IdEmpleado { get; set; }
    public string NombreEmpleado { get; set; }
    public string ApellidoEmpleado { get; set; }
    public DateTime FechaVenta { get; set; }
    public string Observaciones { get; set; }
    public decimal MontoTotal { get; set; }
    public bool EstadoVenta { get; set; }
}

public class DetalleVentaModel
{
    public int IdDetalleVenta { get; set; }
    public int IdVenta { get; set; }
    public int IdInventarioAsociado { get; set; }
    public int Id_Producto { get; set; }
    public int Marca_Id { get; set; }
    public int Id_Categoria { get; set; }
    public int Id_Modelo { get; set; }
    public decimal PrecioUnitarioProducto { get; set; }
    public int Cantidad { get; set; }
    public decimal PrecioVenta { get; set; }
    public decimal MontoTotalDetalle { get; set; }
    public bool EstadoDetalleVenta { get; set; }
    public string NombreProducto { get; set; }
    public string NombreMarca { get; set; }
}

public class RegistrarVentaRequest
{
    public string Nomb_Cliente { get; set; }
    public int IdEmpleado { get; set; }
    public string Observaciones { get; set; }
    public List<DetalleVentaRequest> DetallesVenta { get; set; }
}

public class DetalleVentaRequest
{
    public int IdInventario { get; set; }
    public int Cantidad { get; set; }
    public decimal PrecioVenta { get; set; }
}

public class DetalleVentaConNombresModel
{
    public int IdVenta { get; set; }
    public int Id_Producto { get; set; }
    public string NombreProducto { get; set; }
    public int Marca_Id { get; set; }
    public string NombreMarca { get; set; }
    public int Cantidad { get; set; }
    public decimal PrecioVenta { get; set; }
    public decimal MontoTotalDetalle { get; set; }
}
