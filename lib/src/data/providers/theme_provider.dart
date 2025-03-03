import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  late Box<bool> _themeBox;
  bool _isDarkMode = false;

  ThemeProvider() {
    _openBox();
  }

  Future<void> _openBox() async {
    _themeBox = await Hive.openBox<bool>('theme');
    _isDarkMode = _themeBox.get('isDarkMode', defaultValue: false)!;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      // _isDarkMode ? TaskerDarkTheme.darkTheme : TaskerLightTheme.lightTheme;
      // Can use any custom theme but prefer using the system themes.
      _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeBox.put('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
