// Archivo: lib/views/category_list_view.dart (AppBar estilizado)

import 'package:flutter/material.dart';
import 'package:proyectomovil/layout/main_layout.dart';
import '../controllers/category_controller.dart';
import '../models/category.dart';

// Definimos el color azul para la AppBar, similar al BottomNav o a la imagen
const Color _kAppBarColor = Color(0xFF4FC4EE); 

class CategoryListViewWrapper extends StatelessWidget {
  const CategoryListViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      // 0 es el índice de 'Catálogos' en el CustomBottomNav
      currentIndex: 0, 
      // El body es la vista real de la gestión de categorías
      body: CategoryListView(), 
    );
  }
}


class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  // Inicializamos el controller con late y lo instanciamos en initState
  late final CategoryController controller; 

  // Definimos la altura del espacio extra para el botón flotante (ej: 80.0)
  static const double _fabBottomPadding = 80.0; 

  @override
  void initState() {
    super.initState();
    controller = CategoryController();
    controller.addListener(_refresh); 
    controller.loadCategories(); 
  }

  void _refresh() {
    if (mounted) setState(() {}); 
  }

  @override
  void dispose() {
    controller.removeListener(_refresh); 
    super.dispose();
  }

  Future<String?> _showAddDialog() {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva categoría'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(Category c) {
    final ctrl = TextEditingController(text: c.categoriaNombre);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar categoría'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, ctrl.text.trim()), child: const Text('Actualizar')),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: error ? Colors.red : null));
  }

  // Nuevo método para construir el ítem de la tarjeta de categoría
  Widget _buildCategoryCard(Category c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 2, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(c.categoriaEstado ? Icons.check_circle_outline : Icons.block, color: c.categoriaEstado ? Colors.green : Colors.red),
          title: Text(
            c.categoriaNombre,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), 
            onSelected: (value) async {
              try {
                if (value == 'delete') {
                  await controller.removeCategory(c.categoriaId);
                  _showSnack('Eliminado');
                } else if (value == 'activate') {
                  await controller.updateCategory(c.categoriaId, c.categoriaNombre, !c.categoriaEstado); 
                  _showSnack(c.categoriaEstado ? 'Desactivado' : 'Activado');
                } else if (value == 'edit') {
                  final newName = await _showEditDialog(c);
                  if (newName != null && newName.isNotEmpty) {
                    await controller.updateCategory(c.categoriaId, newName, c.categoriaEstado); 
                    _showSnack('Actualizado');
                  }
                }
              } catch (e) {
                _showSnack(e.toString(), error: true);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Editar')),
              //PopupMenuItem(
                 // value: 'activate', 
                  //child: Text(c.categoriaEstado ? 'Desactivar' : 'Activar')
              //), 
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
      // 🚨 CAMBIO CLAVE: Estilo de la AppBar
      appBar: AppBar(
        title: const Text(
          'Catálogo de Categorías', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Letra blanca y negrita
        ),
        backgroundColor: _kAppBarColor, // Fondo azul
        foregroundColor: Colors.white,   // Íconos y texto en blanco
        elevation: 0,
        centerTitle: true,
        
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadCategories,
        child: controller.categories.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(), 
                children: const [SizedBox(height: 200), Center(child: Text('No hay categorías'))]
              )
            : ListView.builder(
                itemCount: controller.categories.length + 1, // 🚨 Aumentamos el conteo en 1
                itemBuilder: (context, i) {
                  // 🚨 Si es el último ítem, devolvemos el espacio (Padding)
                  if (i == controller.categories.length) {
                    return const SizedBox(height: _fabBottomPadding);
                  }
                  
                  // Si no es el último, devolvemos la tarjeta de categoría
                  final c = controller.categories[i];
                  return _buildCategoryCard(c);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await _showAddDialog();
          if (name != null && name.isNotEmpty) {
            try {
              await controller.addCategory(name);
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