// lib/models/venta.dart
import 'domain_model.dart';
import 'detalle_venta.dart';

class Venta extends DomainModel {
  final int idVenta;
  final int idEmpleado;
  final String nombreEmpleado;
  final String apellidoEmpleado;
  final String nombCliente;
  final String observaciones;
  final DateTime fechaVenta;
  final double montoTotal;
  final bool estadoVenta;
  final List<DetalleVenta> detallesVenta;

  Venta({
    required this.idVenta,
    required this.idEmpleado,
    required this.nombreEmpleado,
    required this.apellidoEmpleado,
    required this.nombCliente,
    required this.observaciones,
    required this.fechaVenta,
    required this.montoTotal,
    required this.estadoVenta,
    required this.detallesVenta,
  });

  @override
  int get id => idVenta;

  factory Venta.fromJson(Map<String, dynamic> json) {
  final map = json.map((k, v) => MapEntry(k.toString().toLowerCase(), v));
  return Venta(
    idVenta: map['idventa'] ?? 0,
    idEmpleado: map['idempleado'] ?? 0,
    nombreEmpleado: map['nombreempleado'] ?? '',
    apellidoEmpleado: map['apellidoempleado'] ?? '',
    nombCliente: map['nomb_cliente'] ?? map['nombcliente'] ?? '',
    observaciones: map['observaciones'] ?? '',
    fechaVenta: DateTime.tryParse(map['fechaventa'] ?? '') ?? DateTime.now(),
    montoTotal: (map['montototal'] ?? 0).toDouble(),
    estadoVenta: map['estadoventa'] ?? false,
    detallesVenta: (json['DetallesVenta'] as List<dynamic>?)
            ?.map((e) => DetalleVenta.fromJson(e))
            .toList() ??
        [],
  );
}

  // 🔹 toJson solo con los campos que la API espera
  @override
  Map<String, dynamic> toJson() => {
        'nomb_Cliente': nombCliente,
        'idEmpleado': idEmpleado,
        'observaciones': observaciones,
        'detallesVenta': detallesVenta.map((d) => d.toJson()).toList(),
      };

  @override
  String getDomain() => 'Venta';

  Venta copyWith({
    List<DetalleVenta>? detallesVenta,
    String? observaciones,
  }) {
    return Venta(
      idVenta: idVenta,
      idEmpleado: idEmpleado,
      nombreEmpleado: nombreEmpleado,
      apellidoEmpleado: apellidoEmpleado,
      nombCliente: nombCliente,
      observaciones: observaciones ?? this.observaciones,
      fechaVenta: fechaVenta,
      montoTotal: montoTotal,
      estadoVenta: estadoVenta,
      detallesVenta: detallesVenta ?? this.detallesVenta,
    );
  }
}
