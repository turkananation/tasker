import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'subtask.g.dart';

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
