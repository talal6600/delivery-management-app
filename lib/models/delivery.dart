import 'package:hive/hive.dart';

part 'delivery.g.dart';

@HiveType(typeId: 1)
class Delivery {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String type; // jawy, sawa, multiple, incomplete, device
  
  @HiveField(3)
  final String? timeRange; // less_than_2, 2_to_3, more_than_3 (null for incomplete/device)
  
  @HiveField(4)
  final int? simCount; // For multiple type (1, 2, or 3)
  
  @HiveField(5)
  final double commission;
  
  @HiveField(6)
  final DateTime dateTime;
  
  @HiveField(7)
  final String? notes;
  
  Delivery({
    required this.id,
    required this.userId,
    required this.type,
    this.timeRange,
    this.simCount,
    required this.commission,
    required this.dateTime,
    this.notes,
  });
  
  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      timeRange: json['timeRange'] as String?,
      simCount: json['simCount'] as int?,
      commission: (json['commission'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      notes: json['notes'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'timeRange': timeRange,
      'simCount': simCount,
      'commission': commission,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
    };
  }
  
  Delivery copyWith({
    String? id,
    String? userId,
    String? type,
    String? timeRange,
    int? simCount,
    double? commission,
    DateTime? dateTime,
    String? notes,
  }) {
    return Delivery(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      timeRange: timeRange ?? this.timeRange,
      simCount: simCount ?? this.simCount,
      commission: commission ?? this.commission,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
    );
  }
}
