import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyectomovil/services/api_services.dart';

class AuthService {
  // AJUSTA según tu entorno (igual que ApiServices.baseUrl)
  final String baseUrl = ApiBaseUrls.apiBase;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String nombreCompleto, String contrasena) async {
    final uri = Uri.parse('$baseUrl/Usuario/autenticar');
    final res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'NombreCompleto': nombreCompleto, 'Contrasena': contrasena}));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final token = data['token'];
      if (token != null) {
        await _storage.write(key: 'jwt', value: token);
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
  }

  Future<String?> getToken() async => await _storage.read(key: 'jwt');

  Map<String, dynamic>? decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}