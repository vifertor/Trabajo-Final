import 'package:flutter/material.dart';
// lib/widgets/custom_bottom_nav.dart
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: const Color(0xFF4FC4EE),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Catálogos"),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transacciones"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Inventario"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
      ],
    );
  }
}
