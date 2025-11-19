import 'package:flutter/material.dart';
import '../models/venta.dart';
import '../models/detalle_venta.dart';

class DetalleVentaView extends StatelessWidget {
  final Venta venta;

  const DetalleVentaView({super.key, required this.venta});

  @override
  Widget build(BuildContext context) {
    final detalles = venta.detallesVenta;

    return Scaffold(
      appBar: AppBar(title: Text("Detalle Venta #${venta.idVenta}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: detalles.isEmpty
            ? const Center(child: Text("No hay detalles para esta venta"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Cliente: ${venta.nombCliente}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Empleado: ${venta.nombreEmpleado} ${venta.apellidoEmpleado}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Observaciones: ${venta.observaciones ?? ''}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Fecha: ${venta.fechaVenta.toLocal()}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: detalles.length,
                      itemBuilder: (context, index) {
                        final d = detalles[index];
                        return Card(
                          child: ListTile(
                            title: Text(d.nombreProducto),
                            subtitle: Text(
                                "Marca: ${d.nombreMarca}\nCantidad: ${d.cantidad}  •  Precio: \$${d.precioVenta.toStringAsFixed(2)}\nTotal: \$${d.montoTotalDetalle.toStringAsFixed(2)}"),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Monto Total: \$${venta.montoTotal.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
