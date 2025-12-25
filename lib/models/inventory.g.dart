// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryTransactionAdapter extends TypeAdapter<InventoryTransaction> {
  @override
  final int typeId = 2;

  @override
  InventoryTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryTransaction(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      quantity: fields[3] as int,
      transactionType: fields[4] as String,
      dateTime: fields[5] as DateTime,
      notes: fields[6] as String?,
      linkedDeliveryId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryTransaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.transactionType)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.linkedDeliveryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FaultySimAdapter extends TypeAdapter<FaultySim> {
  @override
  final int typeId = 3;

  @override
  FaultySim read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FaultySim(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      quantity: fields[3] as int,
      dateTime: fields[4] as DateTime,
      status: fields[5] as String,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FaultySim obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaultySimAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
