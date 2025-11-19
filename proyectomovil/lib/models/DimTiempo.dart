import 'domain_model.dart';

class DimTiempo extends DomainModel {
  final DateTime fecha;
  final int year;
  final int month;
  final int day;
  final String quarter;

  DimTiempo({
    required this.fecha,
    required this.year,
    required this.month,
    required this.day,
    required this.quarter,
  });

  @override
  int get id => fecha.millisecondsSinceEpoch;

  factory DimTiempo.fromJson(Map<String, dynamic> json) {
    return DimTiempo(
      fecha: DateTime.parse(json['fecha']),
      year: (json['año'] as num?)?.toInt() ?? 0,         // viene como "año" en SQL
      month: (json['mes'] as num?)?.toInt() ?? 0,
      day: (json['día'] as num?)?.toInt() ?? 0,
      quarter: json['trimestre'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'fecha': fecha.toIso8601String(),
        'año': year,
        'mes': month,
        'día': day,
        'trimestre': quarter,
      };

  @override
  String getDomain() => 'DimTiempo';
}
