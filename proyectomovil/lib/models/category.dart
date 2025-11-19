import 'domain_model.dart';

class Category extends DomainModel {
  final int categoriaId;
  final String categoriaNombre;
  final bool categoriaEstado;

  Category({
    required this.categoriaId,
    required this.categoriaNombre,
    required this.categoriaEstado,
  });

  @override
  int get id => categoriaId;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoriaId: json['categoria_Id'] is int
          ? json['categoria_Id']
          : (int.tryParse(json['categoria_Id']?.toString() ?? '0') ?? 0),
      categoriaNombre: json['categoria_Nombre']?.toString() ?? '',
      categoriaEstado: json['categoria_Estado'] is bool
          ? json['categoria_Estado']
          : (json['categoria_Estado'] == 1 || json['categoria_Estado'] == '1'),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'categoria_Id': categoriaId,
        'categoria_Nombre': categoriaNombre,
        'categoria_Estado': categoriaEstado,
      };

  @override
  String getDomain() => 'Categoria';
}
