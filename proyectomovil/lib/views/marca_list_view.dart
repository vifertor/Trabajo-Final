// lib/views/marca_list_view.dart
import 'package:flutter/material.dart';
import '../controllers/marca_controller.dart';
import '../models/marca.dart';
import 'package:proyectomovil/layout/main_layout.dart';

const Color _kAppBarColor = Color(0xFF4FC4EE);
const double _fabBottomPadding = 80.0;

class MarcaListViewWrapper extends StatelessWidget {
  const MarcaListViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 0,
      body: MarcaListView(),
    );
  }
}

class MarcaListView extends StatefulWidget {
  const MarcaListView({super.key});

  @override
  State<MarcaListView> createState() => _MarcaListViewState();
}

class _MarcaListViewState extends State<MarcaListView> {
  late final MarcaController controller;

  @override
  void initState() {
    super.initState();
    controller = MarcaController();
    controller.addListener(_refresh);
    controller.loadMarcas();
  }

  void _refresh() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(_refresh);
    super.dispose();
  }

  Future<String?> _showAddDialog() {
    final nameCtrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva Marca'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, nameCtrl.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
  }

  Widget _buildCard(Marca m) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(m.marca_Estado ? Icons.check_circle_outline : Icons.block, color: m.marca_Estado ? Colors.green : Colors.red),
          title: Text(m.marca_Nombre, style: const TextStyle(fontWeight: FontWeight.w500)),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') await controller.deleteMarca(m.marca_Id);
              else if (value == 'activate') await controller.activarMarca(m.marca_Id);
              else if (value == 'edit') {
                final nuevo = await _showAddDialog();
                if (nuevo != null && nuevo.isNotEmpty) {
                  await controller.updateMarca(m.marca_Id, nuevo);
                }
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
              const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              const PopupMenuItem(value: 'activate', child: Text('Activar')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Marcas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _kAppBarColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadMarcas,
        child: controller.marcas.isEmpty
            ? const Center(child: Text('No hay marcas registradas'))
            : ListView.builder(
                itemCount: controller.marcas.length + 1,
                itemBuilder: (context, i) {
                  if (i == controller.marcas.length) return const SizedBox(height: _fabBottomPadding);
                  final m = controller.marcas[i];
                  return _buildCard(m);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nombre = await _showAddDialog();
          if (nombre != null && nombre.isNotEmpty) await controller.addMarca(nombre);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
