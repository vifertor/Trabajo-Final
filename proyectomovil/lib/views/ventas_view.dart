// lib/views/ventas_view.dart
import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../controllers/venta_controller.dart';
import '../models/venta.dart';
import '../models/empleado.dart';
import '../views/detalle_venta_view.dart';
import 'nueva_venta_view.dart';

class VentasView extends StatefulWidget {
  const VentasView({super.key});

  @override
  State<VentasView> createState() => _VentasViewState();
}

class _VentasViewState extends State<VentasView> {
  final VentaController controller = VentaController();
  List<Venta> ventas = [];
  bool loading = true;

  // Lista temporal de empleados (puede venir luego del backend)
  final List<Empleado> empleados = [
    Empleado(
      idEmpleado: 1,
      nombres: 'Juan',
      apellidos: 'Pérez',
      correo: 'juan@mail.com',
      cedula: '12345678',
      telefono: '555-1234',
      genero: 'Masculino',
      fechaNacimiento: null,
      estado: true,
      fechaRegistro: DateTime.now(),
    ),
    Empleado(
      idEmpleado: 2,
      nombres: 'Ana',
      apellidos: 'Gómez',
      correo: 'ana@mail.com',
      cedula: '87654321',
      telefono: '555-5678',
      genero: 'Femenino',
      fechaNacimiento: null,
      estado: true,
      fechaRegistro: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadVentas();
  }

  Future<void> _loadVentas() async {
    setState(() => loading = true);
    try {
      final data = await controller.getVentas();
      setState(() {
        ventas = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ventas: $e')),
      );
    }
  }

  Future<void> _verDetalle(Venta venta) async {
  try {
    // 1️⃣ Traer la venta completa con query parameter
    final ventasFiltradas = await controller.getVentas(idVenta: venta.idVenta);
    if (ventasFiltradas.isEmpty) return;
    final ventaCompleta = ventasFiltradas.first;

    // 2️⃣ Traer los detalles de productos
    final detalles = await controller.getDetalleVenta(venta.idVenta);

    if (!mounted) return;

    // 3️⃣ Navegar a la vista de detalle con todos los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleVentaView(
          venta: ventaCompleta.copyWith(detallesVenta: detalles),
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al cargar detalle: $e')),
    );
  }
}


  // ✅ Nueva venta SIN pasar empleadoSeleccionado (ahora se elige en la vista)
  Future<void> _nuevaVenta() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NuevaVentaView()),
    );

    if (result == true) {
      _loadVentas(); // recarga lista si se creó una venta nueva
    }
  }

  @override
Widget build(BuildContext context) {
  return MainLayout(
    currentIndex: 3, // Tab de Ventas
    body: Scaffold(
      appBar: AppBar(
        title: const Text("Ventas"),
        backgroundColor: Colors.blue,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadVentas,
              child: ventas.isEmpty
                  ? const Center(child: Text("No hay ventas registradas"))
                  : ListView.builder(
                      itemCount: ventas.length,
                      itemBuilder: (context, index) {
                        final v = ventas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            title: Text("Venta #${v.idVenta} - ${v.nombCliente}"),
                            subtitle: Text(
                              "Empleado: ${v.nombreEmpleado} ${v.apellidoEmpleado}\n"
                              "Monto: \$${v.montoTotal.toStringAsFixed(2)}",
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _verDetalle(v),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nuevaVenta,
        backgroundColor: Colors.blue,
        tooltip: "Nueva Venta",
        child: const Icon(Icons.add),
      ),
    ),
  );
}
}
