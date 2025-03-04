import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tasker/src/data/models/priority_level.dart';
import 'package:tasker/src/data/models/subtask.dart';

part 'task.g.dart';

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
