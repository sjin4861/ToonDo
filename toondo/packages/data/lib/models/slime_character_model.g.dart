// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slime_character_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlimeCharacterModelAdapter extends TypeAdapter<SlimeCharacterModel> {
  @override
  final int typeId = 4;

  @override
  SlimeCharacterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlimeCharacterModel(
      name: fields[0] as String,
      conversationHistory: (fields[1] as List).cast<String>(),
      rolePrompt: fields[2] as String,
      props: (fields[3] as List).cast<String>(),
      animationState: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SlimeCharacterModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.conversationHistory)
      ..writeByte(2)
      ..write(obj.rolePrompt)
      ..writeByte(3)
      ..write(obj.props)
      ..writeByte(4)
      ..write(obj.animationState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlimeCharacterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
