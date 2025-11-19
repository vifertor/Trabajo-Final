// lib/controllers/modelo_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/modelo.dart';
import '../services/api_services.dart';

class ModeloController extends ChangeNotifier {
  final ApiServices _api = ApiServices();

  List<Modelo> modelos = [];
  bool loading = false;
  String? error;

  Future<void> loadModelos() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      modelos = await _api.getList<Modelo>(model: Modelo(
        idModelo: 0,
        nombre: '',
        descripcion: null,
        estado: true,
        fechaRegistro: DateTime.now(),
      ));
    } catch (e) {
      error = e.toString();
      modelos = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addModelo(String nombre, String? descripcion) async {
    loading = true;
    notifyListeners();
    try {
      final m = Modelo(
        idModelo: 0,
        nombre: nombre,
        descripcion: descripcion,
        estado: true,
        fechaRegistro: DateTime.now(),
      );
      await _api.post<Modelo>(model: m);
      await loadModelos();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateModelo(int id, String nombre, String? descripcion, bool estado) async {
    loading = true;
    notifyListeners();
    try {
      final m = Modelo(
        idModelo: id,
        nombre: nombre,
        descripcion: descripcion,
        estado: estado,
        fechaRegistro: DateTime.now(),
      );
      await _api.put(model: m, id: id.toString());
      await loadModelos();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> removeModelo(int id) async {
    loading = true;
    notifyListeners();
    try {
      final m = Modelo(idModelo: id, nombre: '', descripcion: null, estado: false, fechaRegistro: DateTime.now());
      await _api.delete(model: m, id: id.toString());
      await loadModelos();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> activate(int id) async {
    loading = true;
    notifyListeners();
    try {
      final uri = Uri.parse('${ApiServices.baseUrl}/Modelo/activate/$id');
      final res = await http.put(uri, headers: {'Content-Type': 'application/json'}).timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) throw Exception('Activate failed ${res.statusCode}: ${res.body}');
      await loadModelos();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
