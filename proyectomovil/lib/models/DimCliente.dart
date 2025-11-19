import 'domain_model.dart';

class DimCliente extends DomainModel {
  final int idCliente;
  final String nombreCliente;

  DimCliente({
    required this.idCliente,
    required this.nombreCliente,
  });

  @override
  int get id => idCliente;

  factory DimCliente.fromJson(Map<String, dynamic> json) {
    return DimCliente(
      idCliente: (json['idCliente'] as num?)?.toInt() ?? 0,
      nombreCliente: json['nombreCliente'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'idCliente': idCliente,
        'nombreCliente': nombreCliente,
      };

  @override
  String getDomain() => 'DimCliente';
}
