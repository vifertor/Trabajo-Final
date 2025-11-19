import 'domain_model.dart';

class DimEmpleado extends DomainModel {
  final int idEmpleado;
  final String nombreEmpleado;
  final String telefono;
  final String correo;
  final String direccion;

  DimEmpleado({
    required this.idEmpleado,
    required this.nombreEmpleado,
    required this.telefono,
    required this.correo,
    required this.direccion,
  });

  @override
  int get id => idEmpleado;

  factory DimEmpleado.fromJson(Map<String, dynamic> json) {
    return DimEmpleado(
      idEmpleado: (json['idEmpleado'] as num?)?.toInt() ?? 0,
      nombreEmpleado: json['nombreEmpleado'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      direccion: json['direccion'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'idEmpleado': idEmpleado,
        'nombreEmpleado': nombreEmpleado,
        'telefono': telefono,
        'correo': correo,
        'direccion': direccion,
      };

  @override
  String getDomain() => 'DimEmpleado';
}
