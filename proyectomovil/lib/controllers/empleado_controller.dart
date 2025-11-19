// lib/controllers/empleado_controller.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/empleado.dart';
import '../services/api_services.dart';

class EmpleadoController extends ChangeNotifier {
  final ApiServices _api = ApiServices();

  List<Empleado> empleados = [];
  bool loading = false;
  String? error;

  Future<void> loadEmpleados() async {
    loading = true;
    notifyListeners();
    try {
      empleados = await _api.getList<Empleado>(
        model: Empleado(
          idEmpleado: 0,
          nombres: "",
          apellidos: "",
          correo: "",
          cedula: "",
          telefono: "",
          genero: "",
          fechaNacimiento: null,
          estado: true,
          fechaRegistro: null,
        ),
      );
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> addEmpleado(Empleado e) async {
    loading = true;
    notifyListeners();
    await _api.post<Empleado>(model: e);
    await loadEmpleados();
  }

  Future<void> updateEmpleado(Empleado e) async {
    loading = true;
    notifyListeners();
    await _api.put(model: e, id: e.idEmpleado.toString());
    await loadEmpleados();
  }

  Future<void> deleteEmpleado(int id) async {
    loading = true;
    notifyListeners();
    await _api.delete(
      model: Empleado(
          idEmpleado: id,
          nombres: '', apellidos: '', correo: '',
          cedula: '', telefono: '', genero: '',
          estado: false, fechaNacimiento: null, fechaRegistro: null),
      id: id.toString(),
    );
    await loadEmpleados();
  }

  Future<void> activate(int id) async {
    loading = true;
    notifyListeners();
    final url = Uri.parse("${ApiServices.baseUrl}/Empleado/activate/$id");
    await http.put(url, headers: {"Content-Type": "application/json"});
    await loadEmpleados();
  }
}
