import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

class MainLayout extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const MainLayout({
    Key? key,
    required this.body,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _showTransactionsMenu = false;

  void _onTap(int index) {
    String route = '';
    switch (index) {
      case 0:
        route = '/catalogos';
        _showTransactionsMenu = false;
        break;
      case 1:
        // Transacciones → desplegar submenu
        setState(() {
          _showTransactionsMenu = !_showTransactionsMenu;
        });
        return; // no navegamos todavía
      case 2:
        route = '/home';
        _showTransactionsMenu = false;
        break;
      case 3:
        route = '/inventario'; // ✔ ahora Inventario va a la ruta correcta
        _showTransactionsMenu = false;
        break;
      case 4:
        route = '/perfil';
        _showTransactionsMenu = false;
        break;
    }

    if (route.isNotEmpty) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  void _onTransactionSelected(String option) {
    String route = '';
    switch (option) {
      case 'Compra':
        route = '/compras';
        break;
      case 'Venta':
        route = '/ventas';
        break;
      case 'Inventario':
        route = '/inventario';
        break;
    }

    setState(() {
      _showTransactionsMenu = false;
    });

    if (route.isNotEmpty) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: widget.body,
          bottomNavigationBar: CustomBottomNav(
            currentIndex: widget.currentIndex,
            onTap: _onTap,
          ),
        ),
        // Submenu de Transacciones
        if (_showTransactionsMenu)
          Positioned(
            bottom: 70, // sobre la barra de navegación
            left: MediaQuery.of(context).size.width * 0.15, // centrado
            child: Material(
              color: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTransactionOption('Compra'),
                  _buildTransactionOption('Venta'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionOption(String title) {
    return InkWell(
      onTap: () => _onTransactionSelected(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
