import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final UserController _controller = UserController();
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _future = _controller.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: FutureBuilder<List<User>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final users = snap.data ?? [];
          if (users.isEmpty) return const Center(child: Text('No hay usuarios'));
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.nombreCompleto),
                subtitle: Text(u.correo),
                trailing: Text(u.roles.join(', ')), // Mostrar roles
              );
            },
          );
        },
      ),
    );
  }
}