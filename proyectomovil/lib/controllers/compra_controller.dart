// lib/controllers/compra_controller.dart
import 'package:flutter/material.dart';
import '../models/compra.dart';
import '../services/api_services.dart';
import '../services/catalogo_services.dart'; 

class CompraController extends ChangeNotifier {
  final ApiServices _api = ApiServices();
  final CatalogoService _catalogoApi = CatalogoService(); 

  List<Compra> compras = [];
  bool loading = false; // Usado para el guardado/carga principal
  String? error;

  // 🔹 Listas para los catálogos
  List<Map<String, dynamic>> proveedores = [];
  List<Map<String, dynamic>> empleados = [];
  List<Map<String, dynamic>> productos = [];
  bool loadingCatalogos = false; // Usado para cargar la vista

  /// 🔹 Método para cargar catálogos (Proveedores, Empleados, Productos)
  Future<void> loadCatalogos() async {
    loadingCatalogos = true;
    error = null;
    notifyListeners();
    try {
      // Cargamos todo en paralelo
      final responses = await Future.wait([
        _catalogoApi.getProveedores(),
        _catalogoApi.getEmpleados(),
        _catalogoApi.getProductos(),
      ]);

      proveedores = responses[0];
      empleados = responses[1];
      productos = responses[2];
      
    } catch (e) {
      error = "Error al cargar catálogos: $e";
      proveedores = [];
      empleados = [];
      productos = [];
    } finally {
      loadingCatalogos = false;
      notifyListeners();
    }
  }


  /// Cargar todas las compras
  Future<void> loadCompras() async {
    loading = true;
    notifyListeners();
    try {
      compras = await _api.getList<Compra>(model: Compra.empty());
      compras = compras.reversed.toList();
    } catch (e) {
      error = e.toString();
      compras = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Obtener compra por ID
  Future<Compra> obtenerCompraPorId(int id) async {
    loading = true;
    notifyListeners();
    try {
      final compra = await _api.get<Compra>(model: Compra.empty(), id: id.toString());
      return compra;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Agregar nueva compra (envía JSON)
  Future<void> addCompra(Compra compra) async {
    loading = true;
    notifyListeners();
    try {
      // Enviar directamente como JSON al API
      await _api.post<Compra>(model: compra);

      // Recargar lista después de agregar
      await loadCompras();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Eliminar compra
  Future<void> eliminarCompra(int id) async {
    loading = true;
    notifyListeners();
    try {
      await _api.delete(model: Compra.empty(), id: id.toString());
      await loadCompras();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}