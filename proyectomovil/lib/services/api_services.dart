import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/domain_model.dart';
import '../models/type_registry.dart';

class ApiServices {
  // AJUSTA ESTA URL según tu entorno:
  // - Flutter Web / Escritorio: http://localhost:5005/api
  // - Emulador Android: http://10.0.2.2:5005/api <-- ¡El más común!
  // - Dispositivo físico (misma red): http://<TU_IP_LOCAL>:5005/api
  static const String baseUrl = 'http://localhost:5005/api'; // Asegúrate de que esta URL sea accesible

  final Map<String, String> defaultHeaders = {'Content-Type': 'application/json'};

  Future<List<T>> getList<T extends DomainModel>({required T model}) async {
    // FIX: El TypeRegistry.create ahora funcionará gracias a la corrección en main.dart
    final uri = Uri.parse('$baseUrl/${model.getDomain()}');
    final res = await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded is List) {
        return decoded
            .map<T>((e) => TypeRegistry.create<T>(model.runtimeType.toString(), e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Se esperaba lista en getList: ${res.body}');
      }
    } else {
      throw Exception('GET ${model.getDomain()} failed: ${res.statusCode} ${res.body}');
    }
  }

  Future<T> get<T extends DomainModel>({required T model, required String id}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}/$id');
    final res = await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body) as Map<String, dynamic>;
      return TypeRegistry.create<T>(model.runtimeType.toString(), decoded);
    } else {
      throw Exception('GET by id failed: ${res.statusCode} ${res.body}');
    }
  }


  Future<void> put({required DomainModel model, required String id}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}/$id');
    final res = await http.put(uri, headers: defaultHeaders, body: json.encode(model.toJson())).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('PUT failed: ${res.statusCode} ${res.body}');
    }
  }

 Future<T?> post<T extends DomainModel>({required T model}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}');
    final res = await http.post(uri, headers: defaultHeaders, body: json.encode(model.toJson())).timeout(const Duration(seconds: 15));
    if (res.statusCode == 200 || res.statusCode == 201) {
      // Manejar respuesta exitosa sin cuerpo
      if (res.body.isEmpty) return null; 
      
      final decoded = json.decode(res.body);
      if (decoded is Map<String, dynamic>) {
        return TypeRegistry.create<T>(model.runtimeType.toString(), decoded);
      } else {
        return null;
      }
    } else {
      throw Exception('POST failed: ${res.statusCode} ${res.body}');
    }
  }


  Future<void> delete({required DomainModel model, required String id}) async {
    final uri = Uri.parse('$baseUrl/${model.getDomain()}/$id');
    final res = await http.delete(uri, headers: defaultHeaders).timeout(const Duration(seconds: 15));
    // Manejo de códigos de estado exitosos (200, 202, 204)
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return; 
    } else {
      // Maneja errores como el 405 Method Not Allowed
      throw Exception('DELETE failed: ${res.statusCode} ${res.body}');
    }

    
  }

    /// Obtiene una lista paginada de un dominio con soporte para pageIndex y pageSize.
  /// Ejemplo de endpoint esperado: /api/DetalleProducto/activos-paged?pageIndex=1&pageSize=10
  Future<List<T>> getPagedList<T extends DomainModel>({
    required T model,
    int pageIndex = 1,
    int pageSize = 10,
    String endpoint = 'activos-paged',
  }) async {
    final uri = Uri.parse(
        '$baseUrl/${model.getDomain()}/$endpoint?pageIndex=$pageIndex&pageSize=$pageSize');
    final res =
        await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded is List) {
        return decoded
            .map<T>((e) => TypeRegistry.create<T>(
                model.runtimeType.toString(), e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Respuesta inesperada (esperaba lista): ${res.body}');
      }
    } else {
      throw Exception(
          'GET paginado falló: ${res.statusCode} ${res.reasonPhrase} -> ${res.body}');
    }
  }

}




/// small helper for base url to reuse in services/views
class ApiBaseUrls {
  static const apiBase = ApiServices.baseUrl; // reuse
}