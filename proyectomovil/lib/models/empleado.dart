// lib/models/empleado.dart
import 'domain_model.dart';

class Empleado extends DomainModel {
  final int idEmpleado;
  final String nombres;
  final String apellidos;
  final String correo;
  final String cedula;
  final String telefono;
  final String genero; // Masculino / Femenino
  final DateTime? fechaNacimiento;
  final bool estado;
  final DateTime? fechaRegistro;

  Empleado({
    required this.idEmpleado,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.cedula,
    required this.telefono,
    required this.genero,
    this.fechaNacimiento,
    required this.estado,
    this.fechaRegistro,
  });
  int get id => idEmpleado;

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      idEmpleado: json['idEmpleado'],
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      correo: json['correo'] ?? '',
      cedula: json['cedula'] ?? '',
      telefono: json['telefono'] ?? '',
      genero: json['genero'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.parse(json['fechaNacimiento'])
          : null,
      estado: json['estado'] == true,
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "idEmpleado": idEmpleado,
        "nombres": nombres,
        "apellidos": apellidos,
        "correo": correo,
        "cedula": cedula,
        "telefono": telefono,
        "genero": genero,
        "fechaNacimiento":
            fechaNacimiento != null ? fechaNacimiento!.toIso8601String() : null,
        "estado": estado,
        "fechaRegistro":
            fechaRegistro != null ? fechaRegistro!.toIso8601String() : null,
      };

  @override
  String getDomain() => "Empleado";
}
