import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class LocalStorageService {
  static Future<void> initLocalStorage() async {
    try {
      await Hive.initFlutter();
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      await Hive.openBox<bool>('theme');
    } catch (e) {
      debugPrint("ERROR ON initLocalStorage(): ${e.toString()}");
    }
  }
}
