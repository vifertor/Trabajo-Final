import 'domain_model.dart';

class Marca extends DomainModel {
  final int marca_Id;
  final String marca_Nombre;
  final bool marca_Estado;

  Marca({
    required this.marca_Id,
    required this.marca_Nombre,
    required this.marca_Estado,
  });

  @override
  int get id => marca_Id;

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      marca_Id: json['marca_Id'] is int
          ? json['marca_Id']
          : int.tryParse(json['marca_Id']?.toString() ?? '0') ?? 0,
      marca_Nombre: json['marca_Nombre']?.toString() ?? '',
      marca_Estado: json['marca_Estado'] is bool
          ? json['marca_Estado']
          : (json['marca_Estado'] == 1 ||
              json['marca_Estado'] == '1' ||
              json['marca_Estado'] == 'true'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'marca_Id': marca_Id,
        'marca_Nombre': marca_Nombre,
        'marca_Estado': marca_Estado,
      };

  @override
  String getDomain() => 'Marca';
}
