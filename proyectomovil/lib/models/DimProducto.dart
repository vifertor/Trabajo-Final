import 'domain_model.dart';

class DimProducto extends DomainModel {
  final int idDetalleProducto;
  final String nombreProducto;
  final String marca;
  final String modelo;
  final String categoria;

  DimProducto({
    required this.idDetalleProducto,
    required this.nombreProducto,
    required this.marca,
    required this.modelo,
    required this.categoria,
  });

  @override
  int get id => idDetalleProducto;

  factory DimProducto.fromJson(Map<String, dynamic> json) {
    return DimProducto(
      idDetalleProducto: (json['idDetalleProducto'] as num?)?.toInt() ?? 0,
      nombreProducto: json['nombreProducto'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      categoria: json['categoria'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'idDetalleProducto': idDetalleProducto,
        'nombreProducto': nombreProducto,
        'marca': marca,
        'modelo': modelo,
        'categoria': categoria,
      };

  @override
  String getDomain() => 'DimProducto';
}
