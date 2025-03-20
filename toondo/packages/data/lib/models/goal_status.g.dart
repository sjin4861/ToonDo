// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalStatusAdapter extends TypeAdapter<GoalStatus> {
  @override
  final int typeId = 2;

  @override
  GoalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalStatus.active;
      case 1:
        return GoalStatus.completed;
      case 2:
        return GoalStatus.givenUp;
      default:
        return GoalStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, GoalStatus obj) {
    switch (obj) {
      case GoalStatus.active:
        writer.writeByte(0);
        break;
      case GoalStatus.completed:
        writer.writeByte(1);
        break;
      case GoalStatus.givenUp:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
