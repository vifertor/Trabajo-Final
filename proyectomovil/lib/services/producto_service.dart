import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductoService {
  final String baseUrl = 'https://localhost:5005/api/Productos'; // Reemplaza con tu URL real

  Future<List<String>> obtenerProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['nombre'].toString()).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}