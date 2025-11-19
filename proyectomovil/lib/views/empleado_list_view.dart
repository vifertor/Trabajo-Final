// lib/views/empleado_list_view.dart
import 'package:flutter/material.dart';
import 'package:proyectomovil/layout/main_layout.dart';
import '../controllers/empleado_controller.dart';
import '../models/empleado.dart';

class EmpleadoListViewWrapper extends StatelessWidget {
  const EmpleadoListViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 0,
      body: EmpleadoListView(),
    );
  }
}

class EmpleadoListView extends StatefulWidget {
  const EmpleadoListView({super.key});
  @override
  State<EmpleadoListView> createState() => _EmpleadoListViewState();
}

class _EmpleadoListViewState extends State<EmpleadoListView> {
  late final EmpleadoController controller;

  @override
  void initState() {
    super.initState();
    controller = EmpleadoController();
    controller.addListener(() => setState(() {}));
    controller.loadEmpleados();
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Empleados")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openForm(),
      ),
      body: ListView.builder(
        itemCount: controller.empleados.length,
        itemBuilder: (_, i) {
          final e = controller.empleados[i];
          return Card(
            child: ListTile(
              title: Text("${e.nombres} ${e.apellidos}"),
              subtitle: Text(e.correo),
              trailing: PopupMenuButton(
                itemBuilder: (_) => [
                  const PopupMenuItem(value: "edit", child: Text("Editar")),
                  const PopupMenuItem(value: "delete", child: Text("Eliminar")),
                  PopupMenuItem(value: "activate", child: Text(e.estado ? "Inactivo" : "Activar")),
                ],
                onSelected: (value) async {
                  if (value == "edit") _openForm(edit: e);
                  if (value == "delete") await controller.deleteEmpleado(e.idEmpleado);
                  if (value == "activate") await controller.activate(e.idEmpleado);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _openForm({Empleado? edit}) {
    final nombres = TextEditingController(text: edit?.nombres);
    final apellidos = TextEditingController(text: edit?.apellidos);
    final correo = TextEditingController(text: edit?.correo);
    final cedula = TextEditingController(text: edit?.cedula);
    final telefono = TextEditingController(text: edit?.telefono);
    final genero = TextEditingController(text: edit?.genero);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(edit == null ? "Nuevo Empleado" : "Editar Empleado"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nombres, decoration: const InputDecoration(labelText: "Nombres")),
              TextField(controller: apellidos, decoration: const InputDecoration(labelText: "Apellidos")),
              TextField(controller: correo, decoration: const InputDecoration(labelText: "Correo")),
              TextField(controller: cedula, decoration: const InputDecoration(labelText: "Cédula")),
              TextField(controller: telefono, decoration: const InputDecoration(labelText: "Teléfono")),
              TextField(controller: genero, decoration: const InputDecoration(labelText: "Género")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            child: const Text("Guardar"),
            onPressed: () async {
              final e = Empleado(
                idEmpleado: edit?.idEmpleado ?? 0,
                nombres: nombres.text,
                apellidos: apellidos.text,
                correo: correo.text,
                cedula: cedula.text,
                telefono: telefono.text,
                genero: genero.text,
                fechaNacimiento: edit?.fechaNacimiento,
                estado: edit?.estado ?? true,
                fechaRegistro: edit?.fechaRegistro,
              );
              if (edit == null) await controller.addEmpleado(e);
              else await controller.updateEmpleado(e);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
