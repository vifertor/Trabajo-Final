// lib/services/inventario_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/inventario.dart';

class InventarioService {
  final String baseUrl = "http://localhost:5005/api/Inventario";

  Future<List<Inventario>> getInventario() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Inventario.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar inventario: ${response.statusCode}');
    }
  }
}
