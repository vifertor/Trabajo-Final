import 'domain_model.dart';

class DetalleProducto extends DomainModel {
  @override
  int get id => idDetalleProducto;

  final int idDetalleProducto;
  final int idProducto;
  final int marcaId;
  final int idCategoria;
  final int idModelo;
  final bool estado;
  final DateTime fechaRegistro;

  DetalleProducto({
    required this.idDetalleProducto,
    required this.idProducto,
    required this.marcaId,
    required this.idCategoria,
    required this.idModelo,
    required this.estado,
    required this.fechaRegistro,
  });

  factory DetalleProducto.fromJson(Map<String, dynamic> json) {
    return DetalleProducto(
      idDetalleProducto: json['idDetalleProducto'] ?? 0,
      idProducto: json['idProducto'] ?? 0,
      marcaId: json['marcaId'] ?? 0,
      idCategoria: json['idCategoria'] ?? 0,
      idModelo: json['idModelo'] ?? 0,
      estado: json['estado'] == true || json['estado'] == 1,
      fechaRegistro: DateTime.tryParse(json['fechaRegistro'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "idDetalleProducto": idDetalleProducto,
        "idProducto": idProducto,
        "marcaId": marcaId,
        "idCategoria": idCategoria,
        "idModelo": idModelo,
        "estado": estado,
        "fechaRegistro": fechaRegistro.toIso8601String(),
      };

  @override
  String getDomain() => "DetalleProducto";
}
