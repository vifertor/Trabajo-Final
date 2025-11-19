import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/venta.dart';
import '../models/detalle_venta.dart';

class VentaController {
  final String baseUrl = 'http://localhost:5005/api/Venta';

  // Obtener todas las ventas, o una venta específica por idVenta
  Future<List<Venta>> getVentas({int? idVenta}) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      if (idVenta != null) 'idVenta': idVenta.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Venta.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar ventas: ${response.statusCode}');
    }
  }

  // Obtener detalle de una venta
  Future<List<DetalleVenta>> getDetalleVenta(int idVenta) async {
    final response = await http.get(Uri.parse('$baseUrl/Detalle/$idVenta'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DetalleVenta.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar detalle: ${response.statusCode}');
    }
  }

  // Crear nueva venta
  Future<Venta> crearVenta(Venta venta) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(venta.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Venta.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear venta: ${response.body}');
    }
  }

  // Crear detalle de venta
  Future<void> crearDetalleVenta(int idVenta, DetalleVenta detalle) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Detalle'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "idVenta": idVenta,
        "IdInventario": detalle.idInventario,
        "Cantidad": detalle.cantidad,
        "PrecioVenta": detalle.precioVenta,
        "MontoTotal": detalle.montoTotalDetalle,
        "nombreProducto": detalle.nombreProducto,
        "marcaId": detalle.marcaId,
        "nombreMarca": detalle.nombreMarca,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear detalle: ${response.body}');
    }
  }
}
