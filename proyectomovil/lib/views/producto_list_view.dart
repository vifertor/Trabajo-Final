// lib/views/producto_list_view.dart
import 'package:flutter/material.dart';
import '../controllers/producto_controller.dart';
import '../models/producto.dart';
import 'package:proyectomovil/layout/main_layout.dart';

class ProductoListViewWrapper extends StatelessWidget {
  const ProductoListViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 0,
      body: ProductoListView(),
    );
  }
}

class ProductoListView extends StatefulWidget {
  const ProductoListView({super.key});

  @override
  State<ProductoListView> createState() => _ProductoListViewState();
}

class _ProductoListViewState extends State<ProductoListView> {
  late final ProductoController controller;

  @override
  void initState() {
    super.initState();
    controller = ProductoController();
    controller.addListener(_refresh);
    controller.loadProductos();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    super.dispose();
  }

  Future<Map<String, String>?> _showAddDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, {'nombre': nameCtrl.text, 'descripcion': descCtrl.text}),
              child: const Text('Guardar')),
        ],
      ),
    );
  }

  Widget _buildCard(Producto p) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(p.estado ? Icons.check_circle : Icons.block, color: p.estado ? Colors.green : Colors.red),
        title: Text(p.nombre),
        subtitle: Text(p.descripcion ?? 'Sin descripción'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'delete') await controller.deleteProducto(p.idProducto);
            if (value == 'activate') await controller.activateProducto(p.idProducto);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'activate', child: Text('Activar')),
            const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Productos')),
      body: ListView.builder(
        itemCount: controller.productos.length,
        itemBuilder: (context, i) => _buildCard(controller.productos[i]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await _showAddDialog();
          if (res != null && res['nombre']!.isNotEmpty) {
            await controller.addProducto(res['nombre']!, res['descripcion']);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
