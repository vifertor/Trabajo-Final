import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../layout/main_layout.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/logo.png', height: 35),
                const Text(
                  "Inicio",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Card de resumen rápido ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "¡Bienvenido de nuevo!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Hoy vendiste 15 productos\nTienes 3 alertas pendientes",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const FaIcon(FontAwesomeIcons.chartPie,
                      size: 40, color: Colors.black87),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Analítica ---
            const Text(
              "Analítica",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _analyticCard(
              icon: FontAwesomeIcons.chartLine,
              color: Colors.blue.shade100,
              title: "Ventas realizadas",
              subtitle: "Últimos 7 días: \$8,750",
              buttonText: "Ver",
            ),
            _analyticCard(
              icon: FontAwesomeIcons.star,
              color: Colors.orange.shade100,
              title: "Productos Populares",
              subtitle: "Top 3: Phone Cases, Protectores, Cargadores",
              buttonText: "Ver",
            ),
            _analyticCard(
              icon: FontAwesomeIcons.boxOpen,
              color: Colors.red.shade100,
              title: "Productos con bajo stock",
              subtitle: "5 items debajo del mínimo",
              buttonText: "Gestionar stock",
            ),

            const SizedBox(height: 25),

            // --- Alertas y Notificaciones ---
            const Text(
              "Alertas y Notificaciones",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _alertItem(Icons.warning_amber_rounded, "Alerta de bajo stock"),
            _alertItem(Icons.shopping_bag_outlined, "Nuevas compras"),
          ],
        ),
      ),
    );
  }

  // --- Widgets reutilizables ---
  static Widget _analyticCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: FaIcon(icon, size: 30, color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC4EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 8),
                  ),
                  child: Text(buttonText,
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _alertItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
