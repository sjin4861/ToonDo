// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_status_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalStatusEnumAdapter extends TypeAdapter<GoalStatusEnum> {
  @override
  final int typeId = 2;

  @override
  GoalStatusEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalStatusEnum.active;
      case 1:
        return GoalStatusEnum.completed;
      case 2:
        return GoalStatusEnum.givenUp;
      default:
        return GoalStatusEnum.active;
    }
  }

  @override
  void write(BinaryWriter writer, GoalStatusEnum obj) {
    switch (obj) {
      case GoalStatusEnum.active:
        writer.writeByte(0);
        break;
      case GoalStatusEnum.completed:
        writer.writeByte(1);
        break;
      case GoalStatusEnum.givenUp:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalStatusEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
