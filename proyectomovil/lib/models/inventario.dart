// lib/models/inventario.dart
class Inventario {
  final int idInventario;
  final int idDetalleProducto;
  final String nombreProducto;
  final String marca;
  final String modelo;
  final String categoria;
  final double precioUnitario;
  int cantidad; // editable para la venta
  final bool estado;

  Inventario({
    required this.idInventario,
    required this.idDetalleProducto,
    required this.nombreProducto,
    required this.marca,
    required this.modelo,
    required this.categoria,
    required this.precioUnitario,
    required this.cantidad,
    required this.estado,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      idInventario: json['idInventario'],
      idDetalleProducto: json['idDetalleProducto'],
      nombreProducto: json['nombreProducto'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      categoria: json['categoria'] ?? '',
      precioUnitario: (json['precioUnitario'] ?? 0).toDouble(),
      cantidad: json['cantidad'] ?? 0,
      estado: json['estado'] ?? true,
    );
  }
}
