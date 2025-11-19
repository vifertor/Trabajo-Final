// lib/controllers/detalle_producto_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/detalle_producto.dart';
import '../services/api_services.dart'; // para ApiBaseUrls.apiBase
import '../services/auth_service.dart'; // tu AuthService para obtener token

class OptionItem {
  final int id;
  final String nombre;
  OptionItem({required this.id, required this.nombre});
}

class DetalleProductoController extends ChangeNotifier {
  final String baseUrl = ApiBaseUrls.apiBase; // usa tu ApiServices.baseUrl
  final AuthService _auth = AuthService();

  List<DetalleProducto> detalles = [];
  List<OptionItem> marcas = [];
  List<OptionItem> modelos = [];
  List<OptionItem> productos = [];
  List<OptionItem> categorias = [];

  bool loading = false;
  bool loadingMore = false;
  String? error;

  int currentPage = 1;
  int pageSize = 10;
  bool hasMore = true;

  Uri _uri(String path) => Uri.parse('$baseUrl/$path');

  Future<Map<String, String>> _getHeaders() async {
    final token = await _auth.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  // --------------------------
  // CATALOGOS (marcas, modelos, productos, categorias)
  // --------------------------
  Future<void> loadCatalogos() async {
    try {
      loading = true;
      notifyListeners();
      final headers = await _getHeaders();

      final responses = await Future.wait([
        http.get(_uri('Marca'), headers: headers),
        http.get(_uri('Modelo'), headers: headers),
        http.get(_uri('Producto'), headers: headers),
        http.get(_uri('Categoria'), headers: headers),
      ]);

      if (responses.any((r) => r.statusCode >= 400)) {
        throw Exception('Error cargando catálogos: ${responses.map((r) => r.statusCode).toList()}');
      }

      final marcaList = json.decode(responses[0].body) as List;
      final modeloList = json.decode(responses[1].body) as List;
      final productoList = json.decode(responses[2].body) as List;
      final categoriaList = json.decode(responses[3].body) as List;

      marcas = marcaList.map((j) {
        return OptionItem(
          id: (j['marca_Id'] is int) ? j['marca_Id'] : int.tryParse((j['marca_Id'] ?? '0').toString()) ?? 0,
          nombre: (j['marca_Nombre'] ?? '').toString(),
        );
      }).toList();

      modelos = modeloList.map((j) {
        return OptionItem(
          id: (j['idModelo'] is int) ? j['idModelo'] : int.tryParse((j['idModelo'] ?? '0').toString()) ?? 0,
          nombre: (j['nombre'] ?? '').toString(),
        );
      }).toList();

      productos = productoList.map((j) {
        return OptionItem(
          id: (j['idProducto'] is int) ? j['idProducto'] : int.tryParse((j['idProducto'] ?? '0').toString()) ?? 0,
          nombre: (j['nombre'] ?? '').toString(),
        );
      }).toList();

      categorias = categoriaList.map((j) {
        return OptionItem(
          id: (j['categoria_Id'] is int) ? j['categoria_Id'] : int.tryParse((j['categoria_Id'] ?? '0').toString()) ?? 0,
          nombre: (j['categoria_Nombre'] ?? '').toString(),
        );
      }).toList();

      // opcional: ordenar
      marcas.sort((a, b) => a.nombre.compareTo(b.nombre));
      modelos.sort((a, b) => a.nombre.compareTo(b.nombre));
      productos.sort((a, b) => a.nombre.compareTo(b.nombre));
      categorias.sort((a, b) => a.nombre.compareTo(b.nombre));

    } catch (e) {
      error = e.toString();
      debugPrint('loadCatalogos error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // --------------------------
  // LIST / PAGINADO (activos-paged)
  // --------------------------
  Future<void> loadPage({bool reset = false, int? pageSize}) async {
    if (pageSize != null) this.pageSize = pageSize;
    if ((loading && reset) || (loadingMore && !reset)) return;

    if (reset) {
      loading = true;
      currentPage = 1;
      detalles.clear();
      hasMore = true;
      error = null;
      notifyListeners();
    } else {
      loadingMore = true;
      notifyListeners();
    }

    try {
      final headers = await _getHeaders();
      final uri = _uri('DetalleProducto/activos-paged?pageIndex=$currentPage&pageSize=${this.pageSize}');
      final res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        if (body is List) {
          final page = body.map<DetalleProducto>((e) => DetalleProducto.fromJson(e as Map<String, dynamic>)).toList();
          if (reset) detalles = page;
          else detalles.addAll(page);

          if (page.isEmpty) hasMore = false;
          else {
            currentPage++;
            if (page.length < this.pageSize) hasMore = false;
          }
        } else {
          throw Exception('Respuesta inesperada (se esperaba lista): ${res.body}');
        }
      } else {
        throw Exception('GET paginado falló: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      error = e.toString();
      debugPrint('loadPage error: $error');
    } finally {
      loading = false;
      loadingMore = false;
      notifyListeners();
    }
  }

  // --------------------------
  // GET ALL (sin paginar)
  // --------------------------
  Future<void> loadAll() async {
    try {
      loading = true;
      notifyListeners();
      final headers = await _getHeaders();
      final uri = _uri('DetalleProducto');
      final res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        if (body is List) {
          detalles = body.map<DetalleProducto>((e) => DetalleProducto.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Respuesta inesperada al obtener todos: ${res.body}');
        }
      } else {
        throw Exception('GET all failed: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      error = e.toString();
      debugPrint('loadAll error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // --------------------------
  // CREATE
  // --------------------------
  Future<bool> createDetalle(DetalleProducto detalle) async {
    try {
      final headers = await _getHeaders();
      final uri = _uri('DetalleProducto');
      final body = json.encode({
        'Id_Producto': detalle.idProducto,
        'Marca_Id': detalle.marcaId,
        'Id_Categoria': detalle.idCategoria,
        'Id_Modelo': detalle.idModelo,
        'Estado': detalle.estado,
      });
      final res = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200 || res.statusCode == 201) {
        await loadPage(reset: true);
        return true;
      } else {
        error = 'create failed: ${res.statusCode} ${res.body}';
        debugPrint(error);
        return false;
      }
    } catch (e) {
      error = e.toString();
      debugPrint('createDetalle error: $error');
      return false;
    }
  }

  // --------------------------
  // UPDATE
  // --------------------------
  Future<bool> updateDetalle(int id, DetalleProducto detalle) async {
    try {
      final headers = await _getHeaders();
      final uri = _uri('DetalleProducto/$id');
      final body = json.encode({
        'Id_Producto': detalle.idProducto,
        'Marca_Id': detalle.marcaId,
        'Id_Categoria': detalle.idCategoria,
        'Id_Modelo': detalle.idModelo,
        'Estado': detalle.estado,
      });
      final res = await http.put(uri, headers: headers, body: body).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        await loadPage(reset: true);
        return true;
      } else {
        error = 'update failed: ${res.statusCode} ${res.body}';
        debugPrint(error);
        return false;
      }
    } catch (e) {
      error = e.toString();
      debugPrint('updateDetalle error: $error');
      return false;
    }
  }

  // --------------------------
  // DELETE (soft-delete)
  // --------------------------
  Future<bool> deleteDetalle(int id) async {
    try {
      final headers = await _getHeaders();
      final uri = _uri('DetalleProducto/$id');
      final res = await http.delete(uri, headers: headers).timeout(const Duration(seconds: 15));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        await loadPage(reset: true);
        return true;
      } else {
        error = 'delete failed: ${res.statusCode} ${res.body}';
        debugPrint(error);
        return false;
      }
    } catch (e) {
      error = e.toString();
      debugPrint('deleteDetalle error: $error');
      return false;
    }
  }

  // helper para UI: obtener listas si están vacías
  Future<List<OptionItem>> getMarcas() async {
    if (marcas.isEmpty) await loadCatalogos();
    return marcas;
  }

  Future<List<OptionItem>> getModelos() async {
    if (modelos.isEmpty) await loadCatalogos();
    return modelos;
  }

  Future<List<OptionItem>> getProductos() async {
    if (productos.isEmpty) await loadCatalogos();
    return productos;
  }

  Future<List<OptionItem>> getCategorias() async {
    if (categorias.isEmpty) await loadCatalogos();
    return categorias;
  }
}
