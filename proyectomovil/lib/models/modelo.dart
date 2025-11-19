import 'domain_model.dart';

class Modelo extends DomainModel {
  final int idModelo;
  final String nombre;
  final String? descripcion;
  final bool estado;
  final DateTime fechaRegistro;

  Modelo({
    required this.idModelo,
    required this.nombre,
    this.descripcion,
    required this.estado,
    required this.fechaRegistro,
  });

  @override
  int get id => idModelo;

  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
      idModelo: json['idModelo'] is int
          ? json['idModelo']
          : (int.tryParse(json['idModelo']?.toString() ?? '0') ?? 0),
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      estado: json['estado'] is bool
          ? json['estado']
          : (json['estado'] == 1 || json['estado'] == '1' || json['estado'] == 'true'),
      fechaRegistro: DateTime.tryParse(json['fechaRegistro']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'idModelo': idModelo,
        'nombre': nombre,
        'descripcion': descripcion,
        'estado': estado,
        'fechaRegistro': fechaRegistro.toIso8601String(),
      };

  @override
  String getDomain() => 'Modelo';
}
