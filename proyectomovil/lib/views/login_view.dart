// Archivo: lib/views/login_view.dart (Diseño actualizado)

import 'package:flutter/material.dart';
import 'package:proyectomovil/views/home_view.dart';
import '../services/auth_service.dart';

// Definición de colores
const Color _kPrimaryColor = Color(0xFF00BFFF); // Color celeste brillante para el botón
const Color _kTextFieldFillColor = Color(0xFFF0F0F0); // Color de fondo de los campos

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _auth = AuthService();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  // Estado para manejar la visibilidad de la contraseña
  bool _obscureText = true; 

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final ok = await _auth.login(_userCtrl.text.trim(), _passCtrl.text.trim());
    setState(() => _loading = false);
    
    if (ok) {
      // Navegamos a la vista principal si el login es exitoso
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView())); 
    } else {
      setState(() => _error = 'Credenciales inválidas');
    }
  }

  // Estilo de los campos de texto
  InputDecoration _inputDecoration(String labelText, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: labelText,
      // Color del hint/label
      labelStyle: const TextStyle(color: Colors.grey),
      // Elimina el padding interno
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), 
      // Estilo del borde cuando no está enfocado
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.transparent), // Borde transparente
      ),
      // Estilo del borde cuando está enfocado
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: _kPrimaryColor, width: 2.0), // Borde azul
      ),
      // Color de fondo del campo
      filled: true,
      fillColor: _kTextFieldFillColor,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos SingleChildScrollView para evitar overflow cuando aparece el teclado
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420,
                // Asegura que ocupe al menos toda la altura de la pantalla
                minHeight: MediaQuery.of(context).size.height, 
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de Cell Shop
                  Image.asset(
                    // 🚨 Asegúrate de que esta ruta sea correcta para tu logo
                    'assets/images/logo.png', 
                    height: 120,
                  ),
                  const SizedBox(height: 50),

                  // Campo de Usuario
                  TextField(
                    controller: _userCtrl,
                    decoration: _inputDecoration('Nombre de Usuario'), // Evitamos usar nombres explícitos
                  ),
                  const SizedBox(height: 20),

                  // Campo de Contraseña
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscureText,
                    decoration: _inputDecoration(
                      'Contraseña', // Evitamos usar nombres explícitos
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Texto de "Olvidaste tu contraseña?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  
                  if (_error != null) 
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),

                  const SizedBox(height: 30),

                  // Botón de Iniciar Sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5,
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Iniciar',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Color de la letra blanco
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}