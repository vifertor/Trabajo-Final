import 'package:flutter/material.dart';
import 'package:proyectomovil/views/login_view.dart';
import 'models/type_registry.dart'; // Importación necesaria para el FIX


import 'views/catalogos_view.dart';
import 'views/compras_view.dart';
import 'views/home_view.dart';
import 'views/ventas_view.dart';
import 'views/perfil_view.dart';
import 'views/sales_chart_view.dart';
import 'views/inventario_view.dart'; // <-- NUEVA IMPORTACIÓN

void main() {
  // --- FIX CRÍTICO: Ejecutar el registro de modelos ---
  registerModels();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    debugPrint('⚠️ ERROR CAPTURADO: ${details.exceptionAsString()}');
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CellShop App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
      ),
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(), // <-- agregar esta línea
        '/catalogos': (context) => const CatalogosView(),
        '/compras': (context) => const ComprasView(),
        '/home': (context) => const HomeView(),
        '/ventas': (context) => const VentasView(),
        '/inventario': (context) => const InventarioView(), // <-- RUTA INVENTARIO
        '/perfil': (context) => const PerfilView(),
        '/sales_chart': (context) => const SalesChartView(),
      },
    );
  }
}
