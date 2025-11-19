// lib/views/inventario_view.dart
import 'package:flutter/material.dart';
import '../models/inventario.dart';
import '../services/inventario_service.dart';
import '../layout/main_layout.dart';
import '../widgets/custom_bottom_nav.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({Key? key}) : super(key: key);

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  final InventarioService service = InventarioService();
  List<Inventario> inventario = [];
  List<Inventario> filteredInventario = [];
  bool loading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInventario();
  }

  Future<void> _loadInventario() async {
    setState(() => loading = true);
    try {
      final data = await service.getInventario();
      setState(() {
        inventario = data;
        _filterInventario(); // filtrar inicial
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar inventario: $e')),
      );
    }
  }

  void _filterInventario() {
    if (searchQuery.isEmpty) {
      filteredInventario = List.from(inventario);
    } else {
      filteredInventario = inventario
          .where((item) =>
              item.nombreProducto.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3, // posición de Inventario en tu barra
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Inventario'),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            // Buscador
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Buscar por nombre',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _filterInventario();
                  });
                },
              ),
            ),
            // Lista de inventario
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadInventario,
                      child: filteredInventario.isEmpty
                          ? const Center(child: Text('No hay productos'))
                          : ListView.builder(
                              itemCount: filteredInventario.length,
                              itemBuilder: (context, index) {
                                final item = filteredInventario[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  elevation: 2,
                                  child: ListTile(
                                    title: Text(item.nombreProducto),
                                    subtitle: Text(
                                      "Marca: ${item.marca}\n"
                                      "Modelo: ${item.modelo}\n"
                                      "Categoria: ${item.categoria}\n"
                                      "Precio unitario: \$${item.precioUnitario.toStringAsFixed(2)}\n"
                                      "Cantidad: ${item.cantidad}\n"
                                      "Estado: ${item.estado ? 'Activo' : 'Inactivo'}",
                                    ),
                                    trailing: const Icon(Icons.inventory_2),
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
