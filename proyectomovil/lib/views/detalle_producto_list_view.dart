
import 'package:flutter/material.dart';
import '../controllers/detalle_producto_controller.dart';
import '../models/detalle_producto.dart';

class DetalleProductoView extends StatefulWidget {
  const DetalleProductoView({Key? key}) : super(key: key);

  @override
  State<DetalleProductoView> createState() => _DetalleProductoViewState();
}

class _DetalleProductoViewState extends State<DetalleProductoView> {
  late final DetalleProductoController controller;
  int _selectedPageSize = 10;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    controller = DetalleProductoController();
    controller.addListener(_onChange);
    _init();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  Future<void> _init() async {
    await controller.loadCatalogos();
    await controller.loadPage(reset: true, pageSize: _selectedPageSize);
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    controller.removeListener(_onChange);
    super.dispose();
  }

  Future<void> _openForm({DetalleProducto? existing}) async {
    // pre-cargar catálogos si no están
    await controller.loadCatalogos();

    int? marcaId = existing?.marcaId;
    int? modeloId = existing?.idModelo;
    int? productoId = existing?.idProducto;
    int? categoriaId = existing?.idCategoria;
    bool estado = existing?.estado ?? true;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Nuevo Detalle' : 'Editar #${existing.idDetalleProducto}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: marcaId,
                decoration: const InputDecoration(labelText: 'Marca'),
                items: controller.marcas.map((m) => DropdownMenuItem(value: m.id, child: Text(m.nombre))).toList(),
                onChanged: (v) => marcaId = v,
              ),
              DropdownButtonFormField<int>(
                value: modeloId,
                decoration: const InputDecoration(labelText: 'Modelo'),
                items: controller.modelos.map((m) => DropdownMenuItem(value: m.id, child: Text(m.nombre))).toList(),
                onChanged: (v) => modeloId = v,
              ),
              DropdownButtonFormField<int>(
                value: productoId,
                decoration: const InputDecoration(labelText: 'Producto'),
                items: controller.productos.map((p) => DropdownMenuItem(value: p.id, child: Text(p.nombre))).toList(),
                onChanged: (v) => productoId = v,
              ),
              DropdownButtonFormField<int>(
                value: categoriaId,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: controller.categorias.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
                onChanged: (v) => categoriaId = v,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Activo'),
                  Switch(value: estado, onChanged: (v) => estado = v),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (marcaId == null || modeloId == null || productoId == null || categoriaId == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa todos los campos')));
                return;
              }
              Navigator.pop(context, {
                'marcaId': marcaId,
                'idModelo': modeloId,
                'idProducto': productoId,
                'idCategoria': categoriaId,
                'estado': estado,
              });
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      final det = DetalleProducto(
        idDetalleProducto: existing?.idDetalleProducto ?? 0,
        idProducto: result['idProducto'] as int,
        nombreProducto: null,
        marcaId: result['marcaId'] as int,
        nombreMarca: null,
        idCategoria: result['idCategoria'] as int,
        nombreCategoria: null,
        idModelo: result['idModelo'] as int,
        nombreModelo: null,
        estado: result['estado'] as bool,
        fechaRegistro: DateTime.now(),
      );

      bool ok;
      if (existing == null) {
        ok = await controller.createDetalle(det);
      } else {
        ok = await controller.updateDetalle(existing.idDetalleProducto, det);
      }

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Operación OK')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.error ?? 'Error')));
      }

      await controller.loadPage(reset: true, pageSize: _selectedPageSize);
    }
  }

  Future<void> _onDelete(DetalleProducto d) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar?'),
        content: const Text('Esto desactivará el detalle (soft-delete).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await controller.deleteDetalle(d.idDetalleProducto);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Eliminado')));
        await controller.loadPage(reset: true, pageSize: _selectedPageSize);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.error ?? 'Error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo Detalle Producto')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text('Mostrar:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedPageSize,
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10')),
                    DropdownMenuItem(value: 20, child: Text('20')),
                    DropdownMenuItem(value: 50, child: Text('50')),
                    DropdownMenuItem(value: 0, child: Text('Todos')),
                  ],
                  onChanged: (v) async {
                    if (v == null) return;
                    setState(() => _selectedPageSize = v);
                    await controller.loadPage(reset: true, pageSize: v == 0 ? 9999 : v);
                  },
                ),
                const Spacer(),
                IconButton(onPressed: () => controller.loadPage(reset: true, pageSize: _selectedPageSize), icon: const Icon(Icons.refresh)),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.loadPage(reset: true, pageSize: _selectedPageSize),
              child: ListView.builder(
                itemCount: controller.detalles.length,
                itemBuilder: (_, i) {
                  final d = controller.detalles[i];
                  final marca = controller.marcas.firstWhere((m) => m.id == d.marcaId, orElse: () => OptionItem(id: 0, nombre: 'N/D'));
                  final producto = controller.productos.firstWhere((p) => p.id == d.idProducto, orElse: () => OptionItem(id: 0, nombre: 'N/D'));
                  final modelo = controller.modelos.firstWhere((m) => m.id == d.idModelo, orElse: () => OptionItem(id: 0, nombre: 'N/D'));
                  final categoria = controller.categorias.firstWhere((c) => c.id == d.idCategoria, orElse: () => OptionItem(id: 0, nombre: 'N/D'));

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Icon(d.estado ? Icons.check_circle_outline : Icons.block, color: d.estado ? Colors.green : Colors.red),
                      title: Text(producto.nombre),
                      subtitle: Text('Marca: ${marca.nombre} • Modelo: ${modelo.nombre} • Categoria: ${categoria.nombre}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _openForm(existing: d)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _onDelete(d)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // paginación simple (prev/next)
          if (controller.pageSize != 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: controller.currentPage > 1 ? () { controller.currentPage = controller.currentPage - 1; controller.loadPage(); } : null,
                  ),
                  Text('Página ${controller.currentPage}'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: controller.hasMore ? () { controller.loadPage(); } : null,
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
