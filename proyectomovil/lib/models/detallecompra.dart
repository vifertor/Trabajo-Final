class DetalleCompra {
  final int idDetalleProducto;
  final double precioCompra;
  final int cantidad;
  final bool estado;

  DetalleCompra({
    required this.idDetalleProducto,
    required this.precioCompra,
    required this.cantidad,
    required this.estado,
  });

  factory DetalleCompra.fromJson(Map<String, dynamic> json) => DetalleCompra(
    idDetalleProducto: json['id_DetalleProducto'],
    precioCompra: json['precioCompra'].toDouble(),
    cantidad: json['cantidad'],
    estado: json['estado'],
  );

  Map<String, dynamic> toJson() => {
    'id_DetalleProducto': idDetalleProducto,
    'precioCompra': precioCompra,
    'cantidad': cantidad,
    'estado': estado,
  };
  
}