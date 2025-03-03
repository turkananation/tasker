// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'priority_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriorityLevelAdapter extends TypeAdapter<PriorityLevel> {
  @override
  final int typeId = 1;

  @override
  PriorityLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PriorityLevel.low;
      case 1:
        return PriorityLevel.medium;
      case 2:
        return PriorityLevel.high;
      default:
        return PriorityLevel.low;
    }
  }

  @override
  void write(BinaryWriter writer, PriorityLevel obj) {
    switch (obj) {
      case PriorityLevel.low:
        writer.writeByte(0);
        break;
      case PriorityLevel.medium:
        writer.writeByte(1);
        break;
      case PriorityLevel.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
