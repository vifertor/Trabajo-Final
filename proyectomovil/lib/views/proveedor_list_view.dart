// lib/views/proveedor_list_view.dart
import 'package:flutter/material.dart';
import '../controllers/proveedor_controller.dart';
import '../models/proveedor.dart';
import '../layout/main_layout.dart';

class ProveedorListViewWrapper extends StatelessWidget {
  const ProveedorListViewWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return const MainLayout(currentIndex: 0, body: ProveedorListView());
  }
}

class ProveedorListView extends StatefulWidget {
  const ProveedorListView({super.key});
  @override
  State<ProveedorListView> createState() => _ProveedorListViewState();
}

class _ProveedorListViewState extends State<ProveedorListView> {
  late ProveedorController controller;

  @override
  void initState() {
    super.initState();
    controller = ProveedorController();
    controller.addListener(() => setState(() {}));
    controller.loadProveedores();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Proveedores")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: controller.proveedores.length,
        itemBuilder: (_, i) {
          final p = controller.proveedores[i];
          return Card(
            child: ListTile(
              title: Text(p.nombreEmpresa),
              subtitle: Text(p.correo ?? "Sin correo"),
              trailing: PopupMenuButton(
                onSelected: (value) async {
                  if (value == "edit") _openForm(edit: p);
                  if (value == "delete") await controller.deleteProveedor(p.idProveedor);
                  if (value == "activate") await controller.activateProveedor(p.idProveedor);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: "edit", child: Text("Editar")),
                  const PopupMenuItem(value: "delete", child: Text("Desactivar")),
                  PopupMenuItem(value: "activate", child: Text(p.estado ? "Inactivar" : "Activar")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openForm({Proveedor? edit}) {
    final nombreEmpresa = TextEditingController(text: edit?.nombreEmpresa);
    final descripcion = TextEditingController(text: edit?.descripcion);
    final encargadoNombre = TextEditingController(text: edit?.encargadoNombre);
    final encargadoApellido1 = TextEditingController(text: edit?.encargadoApellido1);
    final encargadoApellido2 = TextEditingController(text: edit?.encargadoApellido2);
    final correo = TextEditingController(text: edit?.correo);
    final telefono = TextEditingController(text: edit?.telefono);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(edit == null ? "Nuevo Proveedor" : "Editar Proveedor"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nombreEmpresa, decoration: const InputDecoration(labelText: "Empresa")),
              TextField(controller: descripcion, decoration: const InputDecoration(labelText: "Descripción")),
              TextField(controller: encargadoNombre, decoration: const InputDecoration(labelText: "Nombre Encargado")),
              TextField(controller: encargadoApellido1, decoration: const InputDecoration(labelText: "Apellido 1")),
              TextField(controller: encargadoApellido2, decoration: const InputDecoration(labelText: "Apellido 2")),
              TextField(controller: correo, decoration: const InputDecoration(labelText: "Correo")),
              TextField(controller: telefono, decoration: const InputDecoration(labelText: "Teléfono")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            child: const Text("Guardar"),
            onPressed: () async {
              final p = Proveedor(
                idProveedor: edit?.idProveedor ?? 0,
                nombreEmpresa: nombreEmpresa.text,
                descripcion: descripcion.text,
                encargadoNombre: encargadoNombre.text,
                encargadoApellido1: encargadoApellido1.text,
                encargadoApellido2: encargadoApellido2.text,
                correo: correo.text,
                telefono: telefono.text,
                estado: edit?.estado ?? true,
                fechaRegistro: edit?.fechaRegistro,
              );

              if (edit == null) await controller.addProveedor(p);
              else await controller.updateProveedor(p);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
