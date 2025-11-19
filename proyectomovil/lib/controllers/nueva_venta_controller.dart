// lib/controllers/nueva_venta_controller.dart
import 'package:flutter/material.dart';
import '../models/empleado.dart';
import '../models/inventario.dart';
import '../models/venta.dart';
import '../models/detalle_venta.dart';
import '../services/inventario_service.dart';
import '../services/empleado_service.dart';
import 'venta_controller.dart';

class NuevaVentaController extends ChangeNotifier {
  final InventarioService _inventarioService = InventarioService();
  final EmpleadoService _empleadoService = EmpleadoService();
  final VentaController _ventaController = VentaController();

  // 🔹 Listas
  List<Inventario> productos = [];
  List<Inventario> productosSeleccionados = [];
  List<Empleado> empleados = [];

  // 🔹 Empleado seleccionado
  Empleado? empleadoSeleccionado;

  // 🔹 Campos del formulario
  final TextEditingController nombreClienteCtrl = TextEditingController();
  final TextEditingController observacionesCtrl = TextEditingController();

  double total = 0.0;
  bool loading = false;

  // ============================================================
  // 🔹 Inicialización: carga empleados y productos
  // ============================================================
  Future<void> inicializar() async {
    loading = true;
    notifyListeners();
    try {
      await Future.wait([cargarEmpleados(), cargarProductos()]);
    } catch (e) {
      debugPrint("Error inicializando datos: $e");
    }
    loading = false;
    notifyListeners();
  }

  // ============================================================
  // 🔹 Cargar empleados desde servicio
  // ============================================================
  Future<void> cargarEmpleados() async {
    try {
      empleados = await _empleadoService.getEmpleados();
    } catch (e) {
      debugPrint("Error cargando empleados: $e");
    }
    notifyListeners();
  }

  // ============================================================
  // 🔹 Cargar productos desde inventario
  // ============================================================
  Future<void> cargarProductos() async {
    try {
      productos = await _inventarioService.getInventario();
    } catch (e) {
      debugPrint("Error cargando inventario: $e");
    }
    notifyListeners();
  }

  // ============================================================
  // 🔹 Seleccionar empleado
  // ============================================================
  void seleccionarEmpleado(Empleado e) {
    empleadoSeleccionado = e;
    notifyListeners();
  }

  // ============================================================
  // 🔹 Agregar producto (o actualizar cantidad)
  // ============================================================
  void agregarProducto(Inventario producto, int cantidad) {
    final index = productosSeleccionados
        .indexWhere((p) => p.idInventario == producto.idInventario);

    if (index != -1) {
      productosSeleccionados[index].cantidad = cantidad;
    } else {
      productosSeleccionados.add(Inventario(
        idInventario: producto.idInventario,
        idDetalleProducto: producto.idDetalleProducto,
        nombreProducto: producto.nombreProducto,
        marca: producto.marca,
        modelo: producto.modelo,
        categoria: producto.categoria,
        precioUnitario: producto.precioUnitario,
        cantidad: cantidad,
        estado: producto.estado,
      ));
    }
    calcularTotal();
  }

  // ============================================================
  // 🔹 Eliminar producto
  // ============================================================
  void eliminarProducto(Inventario producto) {
    productosSeleccionados
        .removeWhere((p) => p.idInventario == producto.idInventario);
    calcularTotal();
  }

  // ============================================================
  // 🔹 Calcular total de la venta
  // ============================================================
  void calcularTotal() {
    total = productosSeleccionados.fold(
      0.0,
      (sum, p) => sum + (p.precioUnitario * p.cantidad),
    );
    notifyListeners();
  }

  // ============================================================
  // 🔹 Crear venta con detalles (todo en un solo POST)
  // ============================================================
  Future<bool> crearVenta() async {
    if (empleadoSeleccionado == null ||
        nombreClienteCtrl.text.isEmpty ||
        productosSeleccionados.isEmpty) {
      return false;
    }

    // 🔹 Crear detalles de la venta usando idInventario
    final List<DetalleVenta> detalles = productosSeleccionados.map((p) {
      return DetalleVenta(
        idInventario: p.idInventario, // backend espera IdInventario
        cantidad: p.cantidad,
        precioVenta: p.precioUnitario,
        montoTotalDetalle: p.precioUnitario * p.cantidad,
        nombreProducto: p.nombreProducto,
        marcaId: 0,
        nombreMarca: p.marca,
      );
    }).toList();

    // 🔹 Crear objeto Venta
    final venta = Venta(
      idVenta: 0,
      idEmpleado: empleadoSeleccionado!.idEmpleado,
      nombreEmpleado: empleadoSeleccionado!.nombres,
      apellidoEmpleado: empleadoSeleccionado!.apellidos,
      nombCliente: nombreClienteCtrl.text,
      observaciones: observacionesCtrl.text,
      fechaVenta: DateTime.now(),
      montoTotal: total,
      estadoVenta: true,
      detallesVenta: detalles, // enviamos todos los detalles juntos
    );

    debugPrint(
        "Creando venta con idEmpleado: ${venta.idEmpleado}, detalles: ${detalles.map((d) => d.idInventario).toList()}");

    try {
      // 🔹 Solo se hace un POST a /Venta
      await _ventaController.crearVenta(venta);

      // 🔹 Limpiar formulario
      _limpiarFormulario();
      return true;
    } catch (e) {
      debugPrint("Error creando venta: $e");
      return false;
    }
  }

  // ============================================================
  // 🔹 Limpiar formulario
  // ============================================================
  void _limpiarFormulario() {
    productosSeleccionados.clear();
    total = 0.0;
    nombreClienteCtrl.clear();
    observacionesCtrl.clear();
    empleadoSeleccionado = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nombreClienteCtrl.dispose();
    observacionesCtrl.dispose();
    super.dispose();
  }
}
