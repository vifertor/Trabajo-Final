import 'package:flutter/material.dart';
import 'package:proyectomovil/layout/main_layout.dart';

const Color _kAppBarColor = Color(0xFF4FC4EE);
const Color _kCardColor = Color(0xFFF0F0F0);
const Color _kIconColor = Colors.black87;
const Color _kScaffoldColor = Color(0xFFFDFDFD);

class PerfilView extends StatelessWidget {
  const PerfilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 4,
      body: PerfilBody(),
    );
  }
}

class PerfilBody extends StatelessWidget {
  const PerfilBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kScaffoldColor,
      child: Column(
        children: [
          // 🔹 Encabezado fijo
          AppBar(
            backgroundColor: _kAppBarColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              "Mi Perfil",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/logo.png', // Tu logo principal
                height: 30,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: Colors.white),
              ),
            ],
          ),

          // 🔹 Contenido con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 🧑 Tarjeta principal del usuario
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: _kAppBarColor.withOpacity(0.2),
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: _kAppBarColor,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Angelo Miranda",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "angelo@cellshopcenter.com",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Rol: Administrador",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, color: _kAppBarColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ⚙️ Opciones de configuración
                  _buildOptionTile(
                    icon: Icons.lock_outline,
                    title: "Cambiar contraseña",
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    icon: Icons.notifications_active_outlined,
                    title: "Notificaciones",
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    icon: Icons.help_outline,
                    title: "Centro de ayuda",
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),

                  // 🔴 Botón de cerrar sesión
ElevatedButton.icon(
  onPressed: () {
    // Aquí podrías limpiar tokens o datos locales si los tienes, por ejemplo:
    // await SharedPreferences.getInstance().then((prefs) => prefs.clear());

    // Navegar al login reemplazando toda la pila
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // asegúrate que tu ruta de LoginView se llame '/login'
      (Route<dynamic> route) => false,
    );
  },
  icon: const Icon(Icons.logout),
  label: const Text("Cerrar sesión"),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para las opciones
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: _kCardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: _kIconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
