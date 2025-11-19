import 'package:flutter/material.dart';
import 'package:proyectomovil/layout/main_layout.dart';
import 'package:proyectomovil/models/detalle_producto.dart';
import 'package:proyectomovil/views/ModeloListView.dart';
import 'package:proyectomovil/views/detalle_producto_list_view.dart';
import 'package:proyectomovil/views/empleado_list_view.dart';
import 'package:proyectomovil/views/marca_list_view.dart';
import 'package:proyectomovil/views/producto_list_view.dart';
import 'package:proyectomovil/views/proveedor_list_view.dart';
import 'category_list_view.dart';
import 'package:proyectomovil/views/detalle_producto_list_view.dart';
import 'sales_chart_view.dart';

// 🎨 Colores base
const Color _kAppBarColor = Color(0xFF4FC4EE);
const Color _kIconColor = Color(0xFF4FC4EE);
const Color _kScaffoldColor = Color(0xFFF8FAFC);

class CatalogosView extends StatelessWidget {
  const CatalogosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 0,
      body: CatalogosBody(),
    );
  }
}

class CatalogosBody extends StatelessWidget {
  const CatalogosBody({Key? key}) : super(key: key);

  // 🟦 Botón tipo cuadro (2 por fila)
  Widget _buildCatalogCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _kIconColor, size: 36),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  // 🔔 Alertas (igual que antes)
  Widget _buildAlertsAndNotifications(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alertas y Notificaciones",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(Icons.warning_amber, color: Colors.orange.shade700),
              title: const Text("Alerta de Stock bajo"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.shopping_cart_checkout, color: Colors.green),
              title: const Text("Nuevas compras registradas"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kScaffoldColor,
      child: Column(
        children: [
          // 🔷 AppBar con logo y engranaje
          AppBar(
            backgroundColor: _kAppBarColor,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              "Catálogos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/logo.png',
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

          // 📋 Cuerpo principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // 🌈 Cuadros en formato Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildCatalogCard(
                        icon: Icons.label,
                        title: "Marcas",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MarcaListViewWrapper()),
                        ),
                      ),
                      _buildCatalogCard(
                        icon: Icons.category,
                        title: "Categorías",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CategoryListViewWrapper()),
                        ),
                      ),
                      _buildCatalogCard(
                        icon: Icons.people,
                        title: "Empleados",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EmpleadoListViewWrapper()),
                        ),
                      ),
                      _buildCatalogCard(
                        icon: Icons.devices,
                        title: "Modelos",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ModeloListViewWrapper()),
                        ),
                      ),
                      _buildCatalogCard(
                        icon: Icons.shopping_bag,
                        title: "Productos",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProductoListViewWrapper()),
                        ),
                      ),
                      _buildCatalogCard(
    icon: Icons.bar_chart,
    title: "Diagramas",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SalesChartViewWrapper()),
    ),
  ),

_buildCatalogCard(
  icon: Icons.layers,
  title: "Detalle Producto",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const DetalleProductoView()),
  ),
),



                      _buildCatalogCard(
                        icon: Icons.local_shipping,
                        title: "Proveedores",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProveedorListViewWrapper()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildAlertsAndNotifications(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}