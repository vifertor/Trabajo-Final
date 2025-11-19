import 'domain_model.dart';

class Producto extends DomainModel {
  final int idProducto;
  final String nombre;
  final String? descripcion;
  final bool estado;
  final DateTime fechaCreacion;

  Producto({
    required this.idProducto,
    required this.nombre,
    this.descripcion,
    required this.estado,
    required this.fechaCreacion,
  });

  @override
  int get id => idProducto;

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'] is int
          ? json['idProducto']
          : int.tryParse(json['idProducto'].toString()) ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      estado: json['estado'] == true ||
          json['estado'] == 1 ||
          json['estado'] == 'true',
      fechaCreacion: DateTime.tryParse(json['fechaCreacion'] ?? '') ??
          DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'idProducto': idProducto,
        'nombre': nombre,
        'descripcion': descripcion,
        'estado': estado,
        'fechaCreacion': fechaCreacion.toIso8601String(),
      };

  @override
  String getDomain() => 'Producto';
}
