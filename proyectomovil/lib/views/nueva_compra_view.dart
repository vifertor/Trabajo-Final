// lib/views/nueva_compra_view.dart
import 'package:flutter/material.dart';
import '../controllers/compra_controller.dart';
import '../models/compra.dart';

class NuevaCompraView extends StatefulWidget {
  const NuevaCompraView({super.key});

  @override
  State<NuevaCompraView> createState() => _NuevaCompraViewState();
}

class _NuevaCompraViewState extends State<NuevaCompraView> {
  final CompraController controller = CompraController();
  final _formKey = GlobalKey<FormState>();

  int? selectedProveedor;
  int? selectedEmpleado;
  List<DetalleCompra> detalles = [];
  DateTime fechaCompra = DateTime.now();

  bool _isLoadingCatalogos = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerUpdate);
    _loadViewData();
  }
  
  void _onControllerUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  Future<void> _loadViewData() async {
    setState(() => _isLoadingCatalogos = true);
    await controller.loadCatalogos();
    setState(() => _isLoadingCatalogos = false);
  }

  Future<DetalleCompra?> _agregarDetalle() async {
    // Si la lista de productos está vacía, no abrimos el modal
    if (controller.productos.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay productos disponibles para agregar.')),
        );
      }
      return null;
    }

    int? selectedProducto;
    String? selectedProductoNombre;
    int cantidad = 1;
    double precio = 0.0;

    DetalleCompra? detalle;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Agregar Producto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              
              // Dropdown para Producto
              DropdownButtonFormField<int>(
                value: selectedProducto,
                hint: const Text('Seleccione un producto'),
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Producto'),
                items: controller.productos.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: Text(item['nombre']!), 
                  );
                }).toList(),
                onChanged: (value) {
                  setStateModal(() {
                    selectedProducto = value;
                    selectedProductoNombre = controller.productos
                        .firstWhere((p) => p['id'] == value)['nombre'];
                  });
                },
                validator: (v) => v == null ? 'Seleccione un producto' : null,
              ),
              
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                initialValue: '1',
                onChanged: (v) => cantidad = int.tryParse(v) ?? 1,
                validator: (v) => (int.tryParse(v ?? '0') ?? 0) <= 0 ? 'Mínimo 1' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                initialValue: '0',
                onChanged: (v) => precio = double.tryParse(v) ?? 0,
                validator: (v) => (double.tryParse(v ?? '0') ?? 0) < 0 ? 'No negativo' : null,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  if (selectedProducto != null) {
                    detalle = DetalleCompra(
                      idDetalleProducto: selectedProducto!,
                      productoNombre: selectedProductoNombre,
                      cantidad: cantidad,
                      precioCompra: precio,
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
        ),
      ),
    );

    return detalle;
  }

  void _guardarCompra() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedProveedor == null || selectedEmpleado == null) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione proveedor y empleado')),
        );
      }
      return;
    }

    if (detalles.isEmpty) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agregue al menos un producto')),
        );
      }
      return;
    }

    final total = detalles.fold(0.0, (sum, d) => sum + d.subtotal);

    final compra = Compra(
      idCompra: 0,
      idProveedor: selectedProveedor!,
      idEmpleado: selectedEmpleado!,
      montoTotal: total,
      fechaCompra: fechaCompra,
      detalles: detalles,
    );

    try {
      await controller.addCompra(compra);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al guardar: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Compra'),
      ),
      body: _isLoadingCatalogos
          ? const Center(child: CircularProgressIndicator())
          // ❗ AÑADIMOS ESTE BLOQUE PARA MOSTRAR EL ERROR ❗
          : controller.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          'Error al cargar catálogos. Revisa tu conexión o la URL del API.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        Text(controller.error!, textAlign: TextAlign.center), 
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadViewData,
                          child: const Text('Reintentar Carga'),
                        ),
                      ],
                    ),
                  ),
                )
              // ❗ FIN BLOQUE DE ERROR ❗
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        
                        // Dropdown para Proveedor
                        DropdownButtonFormField<int>(
                          value: selectedProveedor,
                          hint: const Text('Seleccione un proveedor'),
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Proveedor'),
                          items: controller.proveedores.map((item) {
                            return DropdownMenuItem<int>(
                              value: item['id'],
                              child: Text(item['nombre']!),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => selectedProveedor = value),
                          validator: (v) => v == null ? 'Seleccione un proveedor' : null,
                        ),

                        const SizedBox(height: 16),

                        // Dropdown para Empleado
                        DropdownButtonFormField<int>(
                          value: selectedEmpleado,
                          hint: const Text('Seleccione un empleado'),
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Empleado'),
                          items: controller.empleados.map((item) {
                            return DropdownMenuItem<int>(
                              value: item['id'],
                              child: Text(item['nombre']!),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => selectedEmpleado = value),
                          validator: (v) => v == null ? 'Seleccione un empleado' : null,
                        ),

                        const SizedBox(height: 24),
                        const Text('Detalles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        
                        ...detalles.map((d) => ListTile(
                              title: Text(d.productoNombre ?? 'Producto ID: ${d.idDetalleProducto}'),
                              subtitle:
                                  Text('Cant: ${d.cantidad} | Precio: \$${d.precioCompra} | Subtotal: \$${d.subtotal.toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => setState(() => detalles.remove(d)),
                              ),
                            )),
                            
                        OutlinedButton.icon(
                          onPressed: controller.productos.isEmpty ? null : () async {
                            final d = await _agregarDetalle();
                            if (d != null) setState(() => detalles.add(d));
                          },
                          icon: const Icon(Icons.add),
                          label: Text(controller.productos.isEmpty ? 'No hay productos' : 'Agregar Producto'),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        FilledButton(
                          onPressed: controller.loading || _isLoadingCatalogos ? null : _guardarCompra,
                          child: controller.loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Guardar Compra'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}