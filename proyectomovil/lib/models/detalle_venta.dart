// lib/models/detalle_venta.dart
import 'domain_model.dart';

class DetalleVenta extends DomainModel {
  final int idInventario; // ✅ cambio principal
  final int cantidad;
  final double precioVenta;
  final double montoTotalDetalle;
  final String nombreProducto;
  final int marcaId;
  final String nombreMarca;

  DetalleVenta({
    required this.idInventario,
    required this.cantidad,
    required this.precioVenta,
    required this.montoTotalDetalle,
    required this.nombreProducto,
    required this.marcaId,
    required this.nombreMarca,
  });

  @override
  int get id => idInventario;

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idInventario: json['Id_Producto'] ?? json['idInventario'] ?? 0,
      cantidad: json['cantidad'] ?? 0,
      precioVenta: (json['precioVenta'] ?? 0).toDouble(),
      montoTotalDetalle: (json['montoTotalDetalle'] ?? 0).toDouble(),
      nombreProducto: json['nombreProducto'] ?? '',
      marcaId: json['marca_Id'] ?? 0,
      nombreMarca: json['nombreMarca'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'IdInventario': idInventario, // ✅ coincide con el backend
        'Cantidad': cantidad,
        'PrecioVenta': precioVenta,
        'MontoTotal': montoTotalDetalle,
      };

  @override
  String getDomain() => 'DetalleVenta';
}
