import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tasker/src/data/models/task.dart';

class LocalStorageService {
  static Future<void> initLocalStorage() async {
    try {
      await Hive.initFlutter();
      await Hive.openBox<bool>('theme');
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      Hive.registerAdapter(TaskAdapter());
      Hive.registerAdapter(PriorityLevelAdapter()); // Register the enum adapter
      await Hive.openBox<Task>('tasks');
    } catch (e) {
      debugPrint("ERROR ON initLocalStorage(): ${e.toString()}");
    }
  }
}
