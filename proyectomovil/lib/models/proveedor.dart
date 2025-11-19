// lib/models/proveedor.dart
import 'domain_model.dart';

class Proveedor extends DomainModel {
  final int idProveedor;
  final String nombreEmpresa;
  final String? descripcion;
  final String? encargadoNombre;
  final String? encargadoApellido1;
  final String? encargadoApellido2;
  final String? correo;
  final String? telefono;
  final bool estado;
  final DateTime? fechaRegistro;

  Proveedor({
    required this.idProveedor,
    required this.nombreEmpresa,
    this.descripcion,
    this.encargadoNombre,
    this.encargadoApellido1,
    this.encargadoApellido2,
    this.correo,
    this.telefono,
    required this.estado,
    this.fechaRegistro,
  });
  int get id => idProveedor;

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProveedor: json['idProveedor'] ?? 0,
      nombreEmpresa: json['nombreEmpresa'] ?? '',
      descripcion: json['descripcion'],
      encargadoNombre: json['encargadoNombre'],
      encargadoApellido1: json['encargadoApellido1'],
      encargadoApellido2: json['encargadoApellido2'],
      correo: json['correo'],
      telefono: json['telefono'],
      estado: json['estado'] ?? false,
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "idProveedor": idProveedor,
        "nombreEmpresa": nombreEmpresa,
        "descripcion": descripcion,
        "encargadoNombre": encargadoNombre,
        "encargadoApellido1": encargadoApellido1,
        "encargadoApellido2": encargadoApellido2,
        "correo": correo,
        "telefono": telefono,
        "estado": estado,
        "fechaRegistro": fechaRegistro?.toIso8601String(),
      };

  @override
  String getDomain() => "Proveedor";
}
