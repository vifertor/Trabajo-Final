import 'domain_model.dart';

class SalesData extends DomainModel {
  final int idVenta;
  final int idCliente;
  final int idEmpleado;
  final int idDetalleProducto;
  final int cantidadVendida;
  final double totalVenta;
  final double precioUnitario;

  final DateTime fecha;

  // Opcionales por si tu API devuelve JOIN con dimensiones
  final String? nombreCliente;
  final String? nombreEmpleado;
  final String? nombreProducto;

  SalesData({
    required this.idVenta,
    required this.idCliente,
    required this.idEmpleado,
    required this.idDetalleProducto,
    required this.cantidadVendida,
    required this.totalVenta,
    required this.precioUnitario,
    required this.fecha,
    this.nombreCliente,
    this.nombreEmpleado,
    this.nombreProducto,
  });

  @override
  int get id => idVenta;

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      idVenta: (json['idVenta'] as num?)?.toInt() ?? 0,
      idCliente: (json['idCliente'] as num?)?.toInt() ?? 0,
      idEmpleado: (json['idEmpleado'] as num?)?.toInt() ?? 0,
      idDetalleProducto: (json['idDetalleProducto'] as num?)?.toInt() ?? 0,
      cantidadVendida: (json['cantidadVendida'] as num?)?.toInt() ?? 0,
      totalVenta: (json['totalVenta'] as num?)?.toDouble() ?? 0.0,
      precioUnitario: (json['precioUnitario'] as num?)?.toDouble() ?? 0.0,
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toString()),
      nombreCliente: json['nombreCliente'],
      nombreEmpleado: json['nombreEmpleado'],
      nombreProducto: json['nombreProducto'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'idVenta': idVenta,
      'idCliente': idCliente,
      'idEmpleado': idEmpleado,
      'idDetalleProducto': idDetalleProducto,
      'cantidadVendida': cantidadVendida,
      'totalVenta': totalVenta,
      'precioUnitario': precioUnitario,
      'fecha': fecha.toIso8601String(),
      'nombreCliente': nombreCliente,
      'nombreEmpleado': nombreEmpleado,
      'nombreProducto': nombreProducto,
    };
  }

  @override
  String getDomain() => 'ETLVentas'; // <-- Ajustado al endpoint real
}
