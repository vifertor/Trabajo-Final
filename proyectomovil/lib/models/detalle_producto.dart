// lib/models/detalle_producto.dart
import 'domain_model.dart'; // si tienes DomainModel; si no, quita esta herencia

class DetalleProducto /* extends DomainModel */ {
  final int idDetalleProducto;
  final int idProducto;
  final String? nombreProducto;
  final int marcaId;
  final String? nombreMarca;
  final int idCategoria;
  final String? nombreCategoria;
  final int idModelo;
  final String? nombreModelo;
  final bool estado;
  final DateTime fechaRegistro;

  DetalleProducto({
    required this.idDetalleProducto,
    required this.idProducto,
    this.nombreProducto,
    required this.marcaId,
    this.nombreMarca,
    required this.idCategoria,
    this.nombreCategoria,
    required this.idModelo,
    this.nombreModelo,
    required this.estado,
    required this.fechaRegistro,
  });

  factory DetalleProducto.fromJson(Map<String, dynamic> json) {
    return DetalleProducto(
      idDetalleProducto: json['id_DetalleProducto'] is int
          ? json['id_DetalleProducto']
          : int.tryParse((json['id_DetalleProducto'] ?? '0').toString()) ?? 0,
      idProducto: json['id_Producto'] is int
          ? json['id_Producto']
          : int.tryParse((json['id_Producto'] ?? '0').toString()) ?? 0,
      nombreProducto: json['nombreProducto']?.toString(),
      marcaId: json['marca_Id'] is int
          ? json['marca_Id']
          : int.tryParse((json['marca_Id'] ?? '0').toString()) ?? 0,
      nombreMarca: json['nombreMarca']?.toString(),
      idCategoria: json['id_Categoria'] is int
          ? json['id_Categoria']
          : int.tryParse((json['id_Categoria'] ?? '0').toString()) ?? 0,
      nombreCategoria: json['nombreCategoria']?.toString(),
      idModelo: json['id_Modelo'] is int
          ? json['id_Modelo']
          : int.tryParse((json['id_Modelo'] ?? '0').toString()) ?? 0,
      nombreModelo: json['nombreModelo']?.toString(),
      estado: (json['estado'] == true) || (json['estado'] == 1) || (json['estado'] == 'true'),
      fechaRegistro: DateTime.tryParse(json['fechaRegistro']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'Id_Producto': idProducto,
        'Marca_Id': marcaId,
        'Id_Categoria': idCategoria,
        'Id_Modelo': idModelo,
        'Estado': estado,
      };

  // si usas DomainModel en tu ApiServices, implementa getDomain
  String getDomain() => 'DetalleProducto';
}
