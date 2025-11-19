import 'package:flutter/material.dart';
import '../layout/main_layout.dart'; // 🔹 Importamos tu layout de navegación
import '../controllers/compra_controller.dart';
import '../models/compra.dart';
import 'nueva_compra_view.dart'; // 🔹 Importamos la nueva vista

const Color _kAppBarColor = Color(0xFF4FC4EE);

class ComprasView extends StatefulWidget {
  const ComprasView({super.key});

  @override
  State<ComprasView> createState() => _ComprasViewState();
}

class _ComprasViewState extends State<ComprasView> {
  late final CompraController controller;

  @override
  void initState() {
    super.initState();
    controller = CompraController();
    controller.addListener(_refresh);
    _loadData();
  }

  Future<void> _loadData() async {
    await controller.loadCompras();
    controller.compras = controller.compras.reversed.toList();
    _refresh();
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(_refresh);
    super.dispose();
  }

  Widget _buildCompraCard(Compra compra) {
    final Color estadoColor = compra.estado ? Colors.green : Colors.redAccent;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: estadoColor.withOpacity(0.2),
          child: Icon(Icons.shopping_cart, color: estadoColor),
        ),
        title: Text("Compra #${compra.idCompra}",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Proveedor: ${compra.proveedorNombre ?? compra.idProveedor}"),
            Text("Empleado: ${compra.empleadoNombre ?? compra.idEmpleado}"),
            Text("Fecha: ${compra.fechaCompra.toLocal().toString().split(' ')[0]}"),
            Text("Total: \$${compra.montoTotal.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (value) {
            if (value == 'eliminar') controller.eliminarCompra(compra.idCompra);
            if (value == 'detalle') _mostrarDetalleCompra(compra.idCompra);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'detalle', child: Text('Ver Detalle')),
            PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalleCompra(int idCompra) async {
    Compra? compra;
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      compra = await controller.obtenerCompraPorId(idCompra);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al obtener detalle: $e')));
      }
      return;
    }

    if (context.mounted) Navigator.pop(context);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Compra #${compra!.idCompra}",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text("Proveedor: ${compra.proveedorNombre ?? compra.idProveedor}"),
            Text("Empleado: ${compra.empleadoNombre ?? compra.idEmpleado}"),
            Text("Fecha: ${compra.fechaCompra.toLocal()}"),
            Text("Monto total: \$${compra.montoTotal.toStringAsFixed(2)}"),
            const Divider(),
            const Text("Detalles", style: TextStyle(fontWeight: FontWeight.bold)),
            ...compra.detalles.map((d) => ListTile(
                  leading: const Icon(Icons.widgets_outlined),
                  title: Text("Producto: ${d.productoNombre ?? d.idDetalleProducto}"),
                  subtitle: Text("Cantidad: ${d.cantidad}  •  Precio: \$${d.precioCompra}"),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1, // 🔹 Marca el tab actual (Compras)
      body: Scaffold(
        appBar: AppBar(
          title: const Text("Compras registradas"),
          backgroundColor: _kAppBarColor,
          foregroundColor: Colors.white,
        ),
        body: controller.loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.loadCompras,
                child: ListView.builder(
                  reverse: true,
                  itemCount: controller.compras.length,
                  itemBuilder: (c, i) => _buildCompraCard(controller.compras[i]),
                ),
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            // 🔹 Ir a la vista de nueva compra y recargar al volver
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NuevaCompraView()),
            );
            await controller.loadCompras(); // refrescar lista al regresar
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text("Nueva Compra"),
        ),
      ),
    );
  }
}
