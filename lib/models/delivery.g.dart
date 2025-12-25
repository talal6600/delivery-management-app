// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryAdapter extends TypeAdapter<Delivery> {
  @override
  final int typeId = 1;

  @override
  Delivery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Delivery(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      timeRange: fields[3] as String?,
      simCount: fields[4] as int?,
      commission: fields[5] as double,
      dateTime: fields[6] as DateTime,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Delivery obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.timeRange)
      ..writeByte(4)
      ..write(obj.simCount)
      ..writeByte(5)
      ..write(obj.commission)
      ..writeByte(6)
      ..write(obj.dateTime)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
