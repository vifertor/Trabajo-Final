import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/sales_chart_controller.dart';
import '../layout/main_layout.dart';

class SalesChartViewWrapper extends StatelessWidget {
  const SalesChartViewWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentIndex: 1,
      body: SalesChartView(),
    );
  }
}

class SalesChartView extends StatefulWidget {
  const SalesChartView({Key? key}) : super(key: key);

  @override
  State<SalesChartView> createState() => _SalesChartViewState();
}

class _SalesChartViewState extends State<SalesChartView> {
  late final SalesChartController controller;

  @override
  void initState() {
    super.initState();
    controller = SalesChartController();
    controller.addListener(_refresh);
    controller.loadSales();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: controller.startDate != null && controller.endDate != null
          ? DateTimeRange(start: controller.startDate!, end: controller.endDate!)
          : null,
    );

    if (picked != null) {
      controller.setDateRange(picked.start, picked.end);
      controller.loadSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- CÁLCULOS PREVIOS ---
    final totalVentas = controller.sales.fold<double>(0, (sum, e) => sum + e.totalVenta);
    final cantidadVentas = controller.sales.length;
    final ticketPromedio = cantidadVentas > 0 ? totalVentas / cantidadVentas : 0;

    // Top productos vendidos
    final productosVendidos = <int, int>{};
    for (var venta in controller.sales) {
      productosVendidos[venta.idDetalleProducto] =
          (productosVendidos[venta.idDetalleProducto] ?? 0) + venta.cantidadVendida;
    }
    final top5Productos = productosVendidos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5ProductosList = top5Productos.take(5).toList();

    // Ventas por empleado
    final ventasPorEmpleado = <int, double>{};
    for (var venta in controller.sales) {
      ventasPorEmpleado[venta.idEmpleado] =
          (ventasPorEmpleado[venta.idEmpleado] ?? 0) + venta.totalVenta;
    }
    final top5Empleados = ventasPorEmpleado.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5EmpleadosList = top5Empleados.take(5).toList();

    // Top 5 productos porcentaje
    final totalCantidad = productosVendidos.values.fold<int>(0, (sum, v) => sum + v);
    final top5Porcentaje = top5ProductosList.map((e) {
      final porcentaje = totalCantidad > 0 ? (e.value / totalCantidad) * 100.0 : 0.0;
      return {'id': e.key, 'porcentaje': porcentaje};
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Ventas'),
        backgroundColor: const Color(0xFF4FC4EE),
        centerTitle: true,
      ),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : controller.error != null
              ? Center(child: Text('Error: ${controller.error}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: _selectDateRange,
                        child: const Text('Filtrar por rango de fechas'),
                      ),
                      const SizedBox(height: 20),

                      // KPI 1: Barra horizontal Top 5 productos
                      const Text(
                        'Porcentaje de Ventas por Producto (Top 5)',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            maxY: 100,
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: top5Porcentaje
                                .asMap()
                                .map((i, e) => MapEntry(
                                    i,
                                    BarChartGroupData(
                                      x: i,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e['porcentaje']!.toDouble(),
                                          color: Colors.green,
                                          width: 22,
                                          borderRadius: BorderRadius.circular(4),
                                        )
                                      ],
                                    )))
                                .values
                                .toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 20,
                                      getTitlesWidget: (v, _) => Text('${v.toInt()}%'))),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  if (idx >= 0 && idx < top5Porcentaje.length) {
                                    return Text('Prod ${top5Porcentaje[idx]['id']}');
                                  }
                                  return const Text('');
                                },
                              )),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // KPI 2: PieChart Ventas por empleado
                      const Text(
                        'Distribución de Ventas por Empleado',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sections: top5EmpleadosList.map((e) {
                              final total = top5EmpleadosList.fold<double>(
                                  0, (sum, v) => sum + v.value);
                              final porcentaje = total > 0 ? (e.value / total) * 100 : 0;
                              final color = Colors.primaries[e.key % Colors.primaries.length];
                              return PieChartSectionData(
                                value: e.value,
                                color: color,
                                title: '${porcentaje.toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),


                      // KPI 4: Top 5 Productos Vendidos (BarChart vertical)
                      const Text(
                        'Top 5 Productos Vendidos',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            maxY: top5ProductosList.isNotEmpty
                                ? top5ProductosList
                                        .map((e) => e.value)
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2
                                : 10,
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: top5ProductosList
                                .asMap()
                                .map((index, e) => MapEntry(
                                    index,
                                    BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value.toDouble(),
                                          color: Colors.orange,
                                          width: 22,
                                          borderRadius: BorderRadius.circular(4),
                                        )
                                      ],
                                    )))
                                .values
                                .toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, interval: 5)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  if (idx >= 0 && idx < top5ProductosList.length) {
                                    return Text('Prod ${top5ProductosList[idx].key}');
                                  }
                                  return const Text('');
                                },
                              )),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // KPI 5: Top 5 Empleados por Ventas (BarChart vertical)
                      const Text(
                        'Top 5 Empleados por Ventas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            maxY: top5EmpleadosList.isNotEmpty
                                ? top5EmpleadosList
                                        .map((e) => e.value)
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2
                                : 100,
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: top5EmpleadosList
                                .asMap()
                                .map((index, e) => MapEntry(
                                    index,
                                    BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value,
                                          color: Colors.blue,
                                          width: 22,
                                          borderRadius: BorderRadius.circular(4),
                                        )
                                      ],
                                    )))
                                .values
                                .toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true, interval: 100)),
                              bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  if (idx >= 0 && idx < top5EmpleadosList.length) {
                                    return Text('Emp ${top5EmpleadosList[idx].key}');
                                  }
                                  return const Text('');
                                },
                              )),
                            ),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}

