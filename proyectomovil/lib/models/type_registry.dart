// lib/models/type_registry.dart
import 'package:proyectomovil/models/compra.dart';
import 'package:proyectomovil/models/empleado.dart';
import 'package:proyectomovil/models/marca.dart';
import 'package:proyectomovil/models/modelo.dart';
import 'package:proyectomovil/models/producto.dart';
import 'package:proyectomovil/models/proveedor.dart';
import 'category.dart';
import 'user.dart';
import 'detalle_producto.dart';
import 'sales_data.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class TypeRegistry {
  static final Map<String, FromJson<dynamic>> _creators = {};

  static void register<T>(String typeName, FromJson<T> creator) {
    _creators[typeName] = creator;
  }

  static T create<T>(String typeName, Map<String, dynamic> json) {
    final creator = _creators[typeName];
    if (creator == null) {
      throw Exception(
          'No creator registered for $typeName. Asegúrate de llamar a registerModels() en main.dart.');
    }
    return creator(json) as T;
  }
}

/// Llama a este método en main() para registrar modelos
void registerModels() {
  TypeRegistry.register<Category>('Category', (json) => Category.fromJson(json));
  TypeRegistry.register<User>('User', (json) => User.fromJson(json));
  TypeRegistry.register<Modelo>('Modelo', (json) => Modelo.fromJson(json));
  TypeRegistry.register<Marca>('Marca', (json) => Marca.fromJson(json));
  TypeRegistry.register<DetalleProducto>(
      'DetalleProducto', (json) => DetalleProducto.fromJson(json));
  TypeRegistry.register<Producto>('Producto', (json) => Producto.fromJson(json));
      TypeRegistry.register<Empleado>("Empleado", (json) => Empleado.fromJson(json));
  TypeRegistry.register<Proveedor>("Proveedor", (json) => Proveedor.fromJson(json));
 TypeRegistry.register<Compra>('Compra', (json) => Compra.fromJson(json));
 TypeRegistry.register<SalesData>('SalesData', (json) => SalesData.fromJson(json));
}
