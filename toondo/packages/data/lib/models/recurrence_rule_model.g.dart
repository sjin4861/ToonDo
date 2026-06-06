// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurrence_rule_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurrenceEndModelAdapter extends TypeAdapter<RecurrenceEndModel> {
  @override
  final int typeId = 7;

  @override
  RecurrenceEndModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurrenceEndModel(
      kind: fields[0] as RecurrenceEndKind,
      date: fields[1] as DateTime?,
      count: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurrenceEndModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.kind)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceEndModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceRuleModelAdapter extends TypeAdapter<RecurrenceRuleModel> {
  @override
  final int typeId = 8;

  @override
  RecurrenceRuleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurrenceRuleModel(
      frequency: fields[0] as RecurrenceFrequencyModel,
      interval: fields[1] as int,
      byWeekdays: (fields[2] as List).cast<int>(),
      byMonthDay: fields[3] as int?,
      end: fields[4] as RecurrenceEndModel,
    );
  }

  @override
  void write(BinaryWriter writer, RecurrenceRuleModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.frequency)
      ..writeByte(1)
      ..write(obj.interval)
      ..writeByte(2)
      ..write(obj.byWeekdays)
      ..writeByte(3)
      ..write(obj.byMonthDay)
      ..writeByte(4)
      ..write(obj.end);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceRuleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceFrequencyModelAdapter
    extends TypeAdapter<RecurrenceFrequencyModel> {
  @override
  final int typeId = 5;

  @override
  RecurrenceFrequencyModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceFrequencyModel.daily;
      case 1:
        return RecurrenceFrequencyModel.weekly;
      case 2:
        return RecurrenceFrequencyModel.monthly;
      case 3:
        return RecurrenceFrequencyModel.yearly;
      default:
        return RecurrenceFrequencyModel.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceFrequencyModel obj) {
    switch (obj) {
      case RecurrenceFrequencyModel.daily:
        writer.writeByte(0);
        break;
      case RecurrenceFrequencyModel.weekly:
        writer.writeByte(1);
        break;
      case RecurrenceFrequencyModel.monthly:
        writer.writeByte(2);
        break;
      case RecurrenceFrequencyModel.yearly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceFrequencyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceEndKindAdapter extends TypeAdapter<RecurrenceEndKind> {
  @override
  final int typeId = 6;

  @override
  RecurrenceEndKind read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceEndKind.never;
      case 1:
        return RecurrenceEndKind.onDate;
      case 2:
        return RecurrenceEndKind.afterCount;
      default:
        return RecurrenceEndKind.never;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceEndKind obj) {
    switch (obj) {
      case RecurrenceEndKind.never:
        writer.writeByte(0);
        break;
      case RecurrenceEndKind.onDate:
        writer.writeByte(1);
        break;
      case RecurrenceEndKind.afterCount:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceEndKindAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
