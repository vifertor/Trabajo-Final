// lib/controllers/proveedor_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/proveedor.dart';
import '../services/api_services.dart';

class ProveedorController extends ChangeNotifier {
  final ApiServices _api = ApiServices();

  List<Proveedor> proveedores = [];
  bool loading = false;

  Future<void> loadProveedores() async {
    loading = true;
    notifyListeners();

    proveedores = await _api.getList<Proveedor>(
      model: Proveedor(
        idProveedor: 0,
        nombreEmpresa: "",
        estado: true,
      ),
    );

    loading = false;
    notifyListeners();
  }

  Future<void> addProveedor(Proveedor p) async {
    await _api.post<Proveedor>(model: p);
    await loadProveedores();
  }

  Future<void> updateProveedor(Proveedor p) async {
    await _api.put(model: p, id: p.idProveedor.toString());
    await loadProveedores();
  }

  Future<void> deleteProveedor(int id) async {
    await _api.delete(
      model: Proveedor(idProveedor: id, nombreEmpresa: "", estado: false),
      id: id.toString(),
    );
    await loadProveedores();
  }

  Future<void> activateProveedor(int id) async {
    final url = Uri.parse("${ApiServices.baseUrl}/Proveedor/activar/$id");
    await http.put(url);
    await loadProveedores();
  }
}
