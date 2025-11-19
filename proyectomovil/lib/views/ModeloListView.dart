// lib/views/modelo_list_view.dart
import 'package:flutter/material.dart';
import 'package:proyectomovil/controllers/ModeloController.dart';
import 'package:proyectomovil/layout/main_layout.dart';
import '../models/modelo.dart';

const Color _kAppBarColor = Color(0xFF4FC4EE);
const double _fabBottomPadding = 80.0;

class ModeloListViewWrapper extends StatelessWidget {
  const ModeloListViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 0,
      body: ModeloListView(),
    );
  }
}

class ModeloListView extends StatefulWidget {
  const ModeloListView({super.key});

  @override
  State<ModeloListView> createState() => _ModeloListViewState();
}

class _ModeloListViewState extends State<ModeloListView> {
  late final ModeloController controller;

  @override
  void initState() {
    super.initState();
    controller = ModeloController();
    controller.addListener(_refresh);
    controller.loadModelos();
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
        title: const Text('Nuevo Modelo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, {'nombre': nameCtrl.text.trim(), 'descripcion': descCtrl.text.trim()}), child: const Text('Guardar')),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _showEditDialog(Modelo m) {
    final nameCtrl = TextEditingController(text: m.nombre);
    final descCtrl = TextEditingController(text: m.descripcion ?? '');
    bool estado = m.estado;
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setState) => AlertDialog(
        title: const Text('Editar Modelo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),
            Row(
              children: [
                const Text('Activo'),
                Switch(value: estado, onChanged: (v) => setState(() => estado = v)),
              ],
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, {'nombre': nameCtrl.text.trim(), 'descripcion': descCtrl.text.trim(), 'estado': estado}), child: const Text('Actualizar')),
        ],
      )),
    );
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: error ? Colors.red : null));
  }

  Widget _buildCard(Modelo m) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(m.estado ? Icons.check_circle_outline : Icons.block, color: m.estado ? Colors.green : Colors.red),
          title: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: m.descripcion != null ? Text(m.descripcion!) : null,
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              try {
                if (value == 'delete') {
                  await controller.removeModelo(m.idModelo);
                  _showSnack('Eliminado');
                } else if (value == 'activate') {
                  await controller.activate(m.idModelo);
                  _showSnack('Activado');
                } else if (value == 'edit') {
                  final res = await _showEditDialog(m);
                  if (res != null) {
                    await controller.updateModelo(m.idModelo, res['nombre'] as String, (res['descripcion'] as String), res['estado'] as bool);
                    _showSnack('Actualizado');
                  }
                }
              } catch (e) {
                _showSnack(e.toString(), error: true);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'activate', child: Text(m.estado ? 'Re-activar' : 'Activar')), // you can change label
              const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (controller.error != null) return Scaffold(body: Center(child: Text('Error: ${controller.error}')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Modelos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _kAppBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadModelos,
        child: controller.modelos.isEmpty
            ? ListView(physics: const AlwaysScrollableScrollPhysics(), children: const [SizedBox(height: 200), Center(child: Text('No hay modelos'))])
            : ListView.builder(
                itemCount: controller.modelos.length + 1,
                itemBuilder: (context, i) {
                  if (i == controller.modelos.length) return const SizedBox(height: _fabBottomPadding);
                  final m = controller.modelos[i];
                  return _buildCard(m);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await _showAddDialog();
          if (data != null && (data['nombre']?.isNotEmpty ?? false)) {
            try {
              await controller.addModelo(data['nombre']!, data['descripcion'] == '' ? null : data['descripcion']);
              _showSnack('Creado');
            } catch (e) {
              _showSnack(e.toString(), error: true);
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
