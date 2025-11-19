import '../services/api_services.dart';
import '../models/user.dart';

class UserController {
  final ApiServices _api = ApiServices();

  Future<List<User>> getAllUsers() async {
    return await _api.getList<User>(model: User(usuarioId: 0, nombreCompleto: '', correo: '', roles: []));
  }

  Future<User?> getById(int id) async {
    return await _api.get<User>(model: User(usuarioId: 0, nombreCompleto: '', correo: '', roles: []), id: id.toString());
  }

  Future<void> createUser(User user) async {
    await _api.post<User>(model: user);
  }

  Future<void> updateUser(int id, User user) async {
    await _api.put(model: user, id: id.toString());
  }

  Future<void> deleteUser(int id) async {
    await _api.delete(model: userPlaceholder(id), id: id.toString());
  }

  User userPlaceholder(int id) => User(usuarioId: id, nombreCompleto: '', correo: '', roles: []);
}