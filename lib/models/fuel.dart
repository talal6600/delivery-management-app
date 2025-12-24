import 'package:hive/hive.dart';

part 'fuel.g.dart';

@HiveType(typeId: 4)
class FuelEntry {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String fuelType; // fuel_91, fuel_95
  
  @HiveField(3)
  final double liters;
  
  @HiveField(4)
  final double cost;
  
  @HiveField(5)
  final double? distance; // Optional: distance covered (km)
  
  @HiveField(6)
  final DateTime dateTime;
  
  @HiveField(7)
  final String? notes;
  
  FuelEntry({
    required this.id,
    required this.userId,
    required this.fuelType,
    required this.liters,
    required this.cost,
    this.distance,
    required this.dateTime,
    this.notes,
  });
  
  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fuelType: json['fuelType'] as String,
      liters: (json['liters'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      distance: json['distance'] != null 
          ? (json['distance'] as num).toDouble()
          : null,
      dateTime: DateTime.parse(json['dateTime'] as String),
      notes: json['notes'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fuelType': fuelType,
      'liters': liters,
      'cost': cost,
      'distance': distance,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
    };
  }
  
  // Calculate consumption rate for this entry
  double? get consumptionRate {
    if (distance != null && liters > 0) {
      return distance! / liters;
    }
    return null;
  }
  
  FuelEntry copyWith({
    String? id,
    String? userId,
    String? fuelType,
    double? liters,
    double? cost,
    double? distance,
    DateTime? dateTime,
    String? notes,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fuelType: fuelType ?? this.fuelType,
      liters: liters ?? this.liters,
      cost: cost ?? this.cost,
      distance: distance ?? this.distance,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
    );
  }
}
