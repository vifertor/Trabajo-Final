// lib/services/producto_inventario_service.dart
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import '../models/producto_inventario.dart';

//class ProductoInventarioService {
//  final String baseUrl;

//  ProductoInventarioService({this.baseUrl = 'http://localhost:5005/api'});

//  Future<List<ProductoInventario>> getProductosDisponibles() async {
//    final response = await http.get(Uri.parse('$baseUrl/Inventario'));

//    if (response.statusCode == 200) {
//      final List<dynamic> data = jsonDecode(response.body);
//      return data.map((e) => ProductoInventario.fromJson(e)).toList();
//    } else {
//      throw Exception('Error al cargar productos de inventario');
 //   }
//  }
//}
