import 'domain_model.dart';

class User extends DomainModel {
  final int usuarioId;
  final String nombreCompleto;
  final String correo;
  final List<String> roles; // si tu API devuelve roles en token o en DTO

  User({
    required this.usuarioId,
    required this.nombreCompleto,
    required this.correo,
    required this.roles,
  });
  int get id => usuarioId;

  factory User.fromJson(Map<String, dynamic> json) {
    List<String> rolesList = [];
    if (json['roles'] != null && json['roles'] is List) {
      rolesList = (json['roles'] as List).map((e) => e.toString()).toList();
    }
    return User(
      usuarioId: json['usuario_Id'] is int
          ? json['usuario_Id']
          : (int.tryParse(json['usuario_Id']?.toString() ?? '') ?? 0),
      nombreCompleto: json['nombreCompleto']?.toString() ??
          json['NombreCompleto']?.toString() ??
          '',
      correo: json['correo']?.toString() ?? json['Correo']?.toString() ?? '',
      roles: rolesList,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'Usuario_Id': usuarioId,
        'NombreCompleto': nombreCompleto,
        'Correo': correo,
      };

  @override
  String getDomain() => 'Usuario';
}