// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_icon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomIconModelAdapter extends TypeAdapter<CustomIconModel> {
  @override
  final int typeId = 4;

  @override
  CustomIconModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomIconModel(
      id: fields[0] as String,
      filePath: fields[1] as String,
      createdAt: fields[2] as DateTime,
      lastUsedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomIconModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.lastUsedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomIconModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
