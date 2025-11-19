// lib/controllers/marca_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/marca.dart';
import '../services/api_services.dart';

class MarcaController extends ChangeNotifier {
  final ApiServices _api = ApiServices();

  List<Marca> marcas = [];
  bool loading = false;
  String? error;

  Future<void> loadMarcas() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      marcas = await _api.getList<Marca>(model: Marca(
        marca_Id: 0,
        marca_Nombre: '',
        marca_Estado: true,
      ));
    } catch (e) {
      error = e.toString();
      marcas = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addMarca(String nombre) async {
    loading = true;
    notifyListeners();
    try {
      final m = Marca(marca_Id: 0, marca_Nombre: nombre, marca_Estado: true);
      await _api.post<Marca>(model: m);
      await loadMarcas();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateMarca(int id, String nombre) async {
    loading = true;
    notifyListeners();
    try {
      final m = Marca(marca_Id: id, marca_Nombre: nombre, marca_Estado: true);
      await _api.put(model: m, id: id.toString());
      await loadMarcas();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMarca(int id) async {
    loading = true;
    notifyListeners();
    try {
      final m = Marca(marca_Id: id, marca_Nombre: '', marca_Estado: false);
      await _api.delete(model: m, id: id.toString());
      await loadMarcas();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> activarMarca(int id) async {
    loading = true;
    notifyListeners();
    try {
      final uri = Uri.parse('${ApiServices.baseUrl}/Marca/activar/$id');
      final res = await http.put(uri);
      if (res.statusCode != 200) throw Exception('Error al activar');
      await loadMarcas();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
