// lib/services/catalogo_services.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CatalogoService {
  // 🚨 VERIFICA ESTA URL: Usa 10.0.2.2 para Emulador de Android.
  final String baseUrl = 'http://localhost:5005/api';

  // --- Función genérica para filtrar duplicados y manejar nulos ---
  List<Map<String, dynamic>> _filtrarDuplicados(
      List data, String idKey, String nombreKey) {
    final uniqueMap = <int, Map<String, dynamic>>{};

    for (var item in data) {
      final id = item[idKey];
      if (id != null && id is int) {
        uniqueMap[id] = {
          'id': id,
          'nombre': item[nombreKey]?.toString() ?? 'Sin nombre',
        };
      }
    }
    return uniqueMap.values.toList();
  }
  // ---------------------------------------------

  Future<List<Map<String, dynamic>>> getProveedores() async {
    final res = await http.get(Uri.parse('$baseUrl/Proveedor'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      // ❗ CLAVES CORREGIDAS: 'idProveedor' y 'nombreEmpresa'
      return _filtrarDuplicados(data, 'idProveedor', 'nombreEmpresa');
    } else {
      throw Exception('Error al cargar proveedores (Código: ${res.statusCode})');
    }
  }

  Future<List<Map<String, dynamic>>> getEmpleados() async {
    final res = await http.get(Uri.parse('$baseUrl/Empleado'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      // ❗ CLAVES CORREGIDAS: 'idEmpleado' y 'nombres'
      return _filtrarDuplicados(data, 'idEmpleado', 'nombres');
    } else {
      throw Exception('Error al cargar empleados (Código: ${res.statusCode})');
    }
  }

  Future<List<Map<String, dynamic>>> getProductos() async {
    // Asumimos que esta API devuelve DetalleProducto como en tu JSON de ejemplo
    final res = await http.get(Uri.parse('$baseUrl/DetalleProducto')); 
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      // ❗ CLAVES CORREGIDAS: Usamos 'id_DetalleProducto' y 'nombreProducto' para el inventario
      return _filtrarDuplicados(data, 'id_DetalleProducto', 'nombreProducto');
    } else {
      throw Exception('Error al cargar productos (Código: ${res.statusCode})');
    }
  }
}