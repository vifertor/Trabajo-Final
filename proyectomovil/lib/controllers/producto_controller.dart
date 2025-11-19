// lib/controllers/producto_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/producto.dart';
import '../services/api_services.dart';

class ProductoController extends ChangeNotifier {
  final ApiServices _api = ApiServices();
  List<Producto> productos = [];
  bool loading = false;
  String? error;

  Future<void> loadProductos() async {
    loading = true;
    notifyListeners();
    try {
      productos = await _api.getList<Producto>(
        model: Producto(
          idProducto: 0,
          nombre: '',
          descripcion: '',
          estado: true,
          fechaCreacion: DateTime.now(),
        ),
      );
    } catch (e) {
      error = e.toString();
      productos = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addProducto(String nombre, String? descripcion) async {
    try {
      final nuevo = Producto(
        idProducto: 0,
        nombre: nombre,
        descripcion: descripcion,
        estado: true,
        fechaCreacion: DateTime.now(),
      );
      await _api.post<Producto>(model: nuevo);
      await loadProductos();
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  Future<void> updateProducto(int id, String nombre, String? descripcion) async {
    try {
      final producto = Producto(
        idProducto: id,
        nombre: nombre,
        descripcion: descripcion,
        estado: true,
        fechaCreacion: DateTime.now(),
      );
      await _api.put(model: producto, id: id.toString());
      await loadProductos();
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteProducto(int id) async {
    try {
      final p = Producto(
        idProducto: id,
        nombre: '',
        descripcion: null,
        estado: false,
        fechaCreacion: DateTime.now(),
      );
      await _api.delete(model: p, id: id.toString());
      await loadProductos();
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }

  Future<void> activateProducto(int id) async {
    try {
      final uri = Uri.parse('${ApiServices.baseUrl}/Producto/activate/$id');
      final res = await http.put(uri);
      if (res.statusCode != 200) {
        throw Exception('Error al activar producto: ${res.statusCode}');
      }
      await loadProductos();
    } catch (e) {
      error = e.toString();
      rethrow;
    }
  }
}
