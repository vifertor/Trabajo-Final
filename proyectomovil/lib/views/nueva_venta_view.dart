// lib/views/nueva_venta_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/nueva_venta_controller.dart';
import '../models/empleado.dart';
import '../models/inventario.dart';
import '../layout/main_layout.dart';

class NuevaVentaView extends StatelessWidget {
  const NuevaVentaView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2, // Índice del tab de "Ventas"
      body: ChangeNotifierProvider(
        create: (_) {
          final controller = NuevaVentaController();
          controller.inicializar(); // Cargar empleados y productos
          return controller;
        },
        child: Consumer<NuevaVentaController>(
          builder: (context, controller, _) {
            if (controller.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text("Nueva Venta"),
                backgroundColor: const Color(0xFF4FC4EE),
                foregroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    // 🔹 Selección de empleado
                    const Text(
                      "Seleccionar Empleado",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ExpansionTile(
  title: Text(
    controller.empleadoSeleccionado == null
        ? "Seleccione un empleado"
        : "${controller.empleadoSeleccionado!.nombres} ${controller.empleadoSeleccionado!.apellidos}",
  ),
  children: controller.empleados.map((Empleado e) {
    return ListTile(
      title: Text("${e.nombres} ${e.apellidos}"),
      onTap: () {
        controller.seleccionarEmpleado(e);
        // ✅ No cerramos la vista, solo actualizamos selección
      },
    );
  }).toList(),
),
                    const SizedBox(height: 16),

                    // 🔹 Cliente
                    TextField(
                      controller: controller.nombreClienteCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nombre del Cliente",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Observaciones
                    TextField(
                      controller: controller.observacionesCtrl,
                      decoration: const InputDecoration(
                        labelText: "Observaciones",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Productos
                    const Text(
                      "Agregar Productos",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ExpansionTile(
                      title: const Text("Seleccionar Productos"),
                      children: controller.productos.map((Inventario producto) {
                        return ListTile(
                          title: Text(
                            "${producto.nombreProducto} - \$${producto.precioUnitario.toStringAsFixed(2)}",
                          ),
                          subtitle: Text("Stock: ${producto.cantidad}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              controller.agregarProducto(producto, 1);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Lista de productos seleccionados
                    if (controller.productosSeleccionados.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Productos seleccionados",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...controller.productosSeleccionados.map((p) {
                            return Card(
                              child: ListTile(
                                title: Text(p.nombreProducto),
                                subtitle: Text(
                                  "Cantidad: ${p.cantidad} • Precio: \$${p.precioUnitario}",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (p.cantidad > 1) {
                                          controller.agregarProducto(
                                              p, p.cantidad - 1);
                                        } else {
                                          controller.eliminarProducto(p);
                                        }
                                      },
                                    ),
                                    Text("${p.cantidad}"),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        controller.agregarProducto(
                                            p, p.cantidad + 1);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    const SizedBox(height: 20),

                    // 🔹 Total
                    Text(
                      "Total: \$${controller.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Botón Finalizar Venta
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Finalizar Venta"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4FC4EE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        final ok = await controller.crearVenta();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok
                                  ? "Venta creada exitosamente"
                                  : "Complete todos los campos antes de continuar"),
                            ),
                          );
                          if (ok) Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
