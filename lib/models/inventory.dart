import 'package:hive/hive.dart';

part 'inventory.g.dart';

@HiveType(typeId: 2)
class InventoryTransaction {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String type; // jawy, sawa, multiple
  
  @HiveField(3)
  final int quantity;
  
  @HiveField(4)
  final String transactionType; // received, used, faulty, returned
  
  @HiveField(5)
  final DateTime dateTime;
  
  @HiveField(6)
  final String? notes;
  
  @HiveField(7)
  final String? linkedDeliveryId; // For used transactions
  
  InventoryTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.quantity,
    required this.transactionType,
    required this.dateTime,
    this.notes,
    this.linkedDeliveryId,
  });
  
  factory InventoryTransaction.fromJson(Map<String, dynamic> json) {
    return InventoryTransaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      quantity: json['quantity'] as int,
      transactionType: json['transactionType'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      notes: json['notes'] as String?,
      linkedDeliveryId: json['linkedDeliveryId'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'quantity': quantity,
      'transactionType': transactionType,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
      'linkedDeliveryId': linkedDeliveryId,
    };
  }
}

@HiveType(typeId: 3)
class FaultySim {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String type; // jawy, sawa, multiple
  
  @HiveField(3)
  final int quantity;
  
  @HiveField(4)
  final DateTime dateTime;
  
  @HiveField(5)
  final String status; // pending, returned_to_company, returned_to_inventory
  
  @HiveField(6)
  final String? notes;
  
  FaultySim({
    required this.id,
    required this.userId,
    required this.type,
    required this.quantity,
    required this.dateTime,
    required this.status,
    this.notes,
  });
  
  factory FaultySim.fromJson(Map<String, dynamic> json) {
    return FaultySim(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      quantity: json['quantity'] as int,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'quantity': quantity,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
}
