import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../services/api_services.dart';
// import '../models/domain_model.dart'; // No necesario si solo usas Category

class CategoryController extends ChangeNotifier {
  final ApiServices _api = ApiServices();

  List<Category> categories = [];
  bool loading = false;
  String? error;

  Future<void> loadCategories() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      // Ahora el getList funcionará gracias a TypeRegistry
      categories = await _api.getList<Category>(model: Category(categoriaId: 0, categoriaNombre: '', categoriaEstado: false));
    } catch (e) {
      error = e.toString();
      categories = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(String name) async {
    loading = true;
    notifyListeners();
    try {
      final cat = Category(categoriaId: 0, categoriaNombre: name, categoriaEstado: true);
      await _api.post<Category>(model: cat);
      await loadCategories();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(int id, String newName, bool estado) async {
    loading = true;
    notifyListeners();
    try {
      final cat = Category(categoriaId: id, categoriaNombre: newName, categoriaEstado: estado);
      await _api.put(model: cat, id: id.toString());
      await loadCategories();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> removeCategory(int id) async {
    loading = true;
    notifyListeners();
    try {
      final cat = Category(categoriaId: id, categoriaNombre: '', categoriaEstado: false);
      await _api.delete(model: cat, id: id.toString());
      await loadCategories();
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
      // endpoint PUT api/Categoria/activate/{id}
      final uri = Uri.parse('${ApiServices.baseUrl}/Categoria/activate/$id');
      final res = await http.put(uri, headers: {'Content-Type': 'application/json'}).timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) throw Exception('Activate failed ${res.statusCode}: ${res.body}');
      await loadCategories();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}