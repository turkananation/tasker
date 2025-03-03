import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

enum PriorityLevel {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      title: fields[0] as String,
      description: fields[1] as String,
      dueDate: fields[2] as DateTime?,
      priorityLevel: fields[3] as PriorityLevel,
      isCompleted: fields[4] as bool,
      subtasks: (fields[5] as List?)?.cast<Subtask>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.priorityLevel)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.subtasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityLevelAdapter extends TypeAdapter<PriorityLevel> {
  @override
  final int typeId = 1; // Different typeId for enum adapter

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
        return PriorityLevel.low; // Default in case of unexpected value
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
}

@HiveType(typeId: 0)
class Task extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? dueDate;

  @HiveField(3)
  PriorityLevel priorityLevel;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  List<Subtask> subtasks;

  @override
  @HiveField(6)
  String key;

  Task({
    required this.title,
    this.description = '',
    this.dueDate,
    this.priorityLevel = PriorityLevel.low,
    this.isCompleted = false,
    this.subtasks = const [],
    this.key = '',
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
    save();
    notifyListeners();
  }

  String get formattedDueDate {
    if (dueDate == null) {
      return 'No due date';
    }
    return DateFormat('yyyy-MM-dd').format(dueDate!);
  }
}

@HiveType(typeId: 2) // Assign a unique typeId for Subtask
class Subtask extends HiveObject with ChangeNotifier {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isCompleted;

  Subtask({required this.name, this.isCompleted = false});

  void toggleCompleted() {
    isCompleted = !isCompleted;
    save();
    notifyListeners();
  }
}

class SubtaskAdapter extends TypeAdapter<Subtask> {
  @override
  final int typeId = 2;

  @override
  Subtask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subtask(name: fields[0] as String, isCompleted: fields[1] as bool);
  }

  @override
  void write(BinaryWriter writer, Subtask obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isCompleted);
  }
}
