import 'package:flutter/material.dart';
import '../models/sales_data.dart';
import '../services/api_services.dart';

class SalesChartController extends ChangeNotifier {
  List<SalesData> sales = [];
  bool loading = false;
  String? error;

  DateTime? startDate;
  DateTime? endDate;

  final ApiServices _api = ApiServices();

  void setDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  Future<void> loadSales() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      // Plantilla completa para obtener la lista de ETLVentas
      sales = await _api.getList<SalesData>(
        model: SalesData(
          idVenta: 0,
          idDetalleProducto: 0,
          idCliente: 0,
          idEmpleado: 0,
          cantidadVendida: 0,
          totalVenta: 0.0,
          precioUnitario: 0.0,
          fecha: DateTime.now(),
          nombreCliente: null,
          nombreEmpleado: null,
          nombreProducto: null,
        ),
      );

      // Filtrar por rango de fechas si se seleccionó
      if (startDate != null && endDate != null) {
        sales = sales
            .where((e) =>
                e.fecha.isAfter(startDate!.subtract(const Duration(days: 1))) &&
                e.fecha.isBefore(endDate!.add(const Duration(days: 1))))
            .toList();
      }

      // Ordenar por fecha ascendente
      sales.sort((a, b) => a.fecha.compareTo(b.fecha));
    } catch (e) {
      error = e.toString();
      sales = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
