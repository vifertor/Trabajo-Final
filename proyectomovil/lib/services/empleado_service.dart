import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/empleado.dart';

class EmpleadoService {
  final String baseUrl = "http://localhost:5005/api/Empleado";

  Future<List<Empleado>> getEmpleados() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {"accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Empleado.fromJson(json)).toList();
    } else {
      throw Exception(
          "Error al obtener empleados: ${response.statusCode}");
    }
  }
}
