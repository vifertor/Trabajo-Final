// lib/models/compra.dart
import 'domain_model.dart'; 

class DetalleCompra {
  final int idDetalleProducto; 
  final double precioCompra;
  final int cantidad;
  final double subtotal;
  final bool estado;
  final String? productoNombre; 

  DetalleCompra({
    required this.idDetalleProducto,
    required this.precioCompra,
    required this.cantidad,
    double? subtotal,
    this.estado = true,
    this.productoNombre,
  }) : subtotal = subtotal ?? precioCompra * cantidad;

  factory DetalleCompra.fromJson(Map<String, dynamic> json) {
    int id = json['id_DetalleProducto'] ?? json['id_Producto'] ?? 0;
    
    return DetalleCompra(
      idDetalleProducto: id,
      precioCompra: (json['precioCompra'] ?? 0).toDouble(),
      cantidad: json['cantidad'] ?? 0,
      subtotal: (json['subtotal'] ?? (json['precioCompra'] ?? 0) * (json['cantidad'] ?? 0)).toDouble(),
      estado: json['estado'] == 1 || json['estado'] == true,
      productoNombre: json['nombreProducto'] ?? json['Producto'],
    );
  }

  // CRÍTICO para el SP
  Map<String, dynamic> toJson() => {
        'id_DetalleProducto': idDetalleProducto,
        'precioCompra': precioCompra,
        'cantidad': cantidad,
      };
}


class Compra extends DomainModel {
  final int idCompra;
  final int idProveedor;
  final int idEmpleado;
  final String? proveedorNombre;
  final String? empleadoNombre;
  final double montoTotal;
  final DateTime fechaCompra;
  final bool estado;
  final List<DetalleCompra> detalles;

  Compra({
    required this.idCompra,
    required this.idProveedor,
    required this.idEmpleado,
    this.proveedorNombre,
    this.empleadoNombre,
    required this.montoTotal,
    required this.fechaCompra,
    this.estado = true,
    required this.detalles,
  });

  factory Compra.empty() => Compra(
        idCompra: 0,
        idProveedor: 0,
        idEmpleado: 0,
        montoTotal: 0.0,
        fechaCompra: DateTime.now(),
        detalles: [],
      );

  factory Compra.fromJson(Map<String, dynamic> json) {
    var detallesJson = json['detalles'] as List? ?? [];
    return Compra(
      idCompra: json['id_Compra'] ?? json['idCompra'] ?? 0,
      idProveedor: json['id_Proveedor'] ?? json['idProveedor'] ?? 0,
      idEmpleado: json['id_Empleado'] ?? json['idEmpleado'] ?? 0,
      
      proveedorNombre: json['nombreEmpresa'] ?? json['proveedorNombre'] ?? json['Proveedor'],
      empleadoNombre: json['nombres'] ?? json['empleadoNombre'] ?? json['Empleado'],
      
      montoTotal: (json['montoTotal'] ?? 0).toDouble(),
      fechaCompra: DateTime.tryParse(json['fechaCompra'] ?? '') ?? DateTime.now(),
      estado: json['estado'] == 1 || json['estado'] == true,
      detalles: detallesJson.map((e) => DetalleCompra.fromJson(e)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        // ❗ REVERSIÓN A SNAKE_CASE para el POST para resolver el error 400
        'id_Proveedor': idProveedor,
        'id_Empleado': idEmpleado,
        
        // Mantenemos el resto en camelCase, ya que no son claves directas del SP
        'montoTotal': montoTotal,
        'fechaCompra': fechaCompra.toIso8601String(),
        'estado': estado,
        'detalles': detalles.map((d) => d.toJson()).toList(), 
      };

  @override
  String getDomain() => 'Compra';
}