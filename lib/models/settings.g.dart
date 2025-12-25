// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 5;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      userId: fields[0] as String,
      weeklyGoal: fields[1] as double,
      preferredFuelType: fields[2] as String,
      commissionRates: (fields[3] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, double>())),
      displayName: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.weeklyGoal)
      ..writeByte(2)
      ..write(obj.preferredFuelType)
      ..writeByte(3)
      ..write(obj.commissionRates)
      ..writeByte(4)
      ..write(obj.displayName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
