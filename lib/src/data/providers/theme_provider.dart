import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider with ChangeNotifier {
  late Box<bool> _themeBox;
  bool _isDarkMode = false;
  bool _isInitialized = false;

  ThemeProvider({Box<bool>? themeBox}) {
    if (themeBox != null) {
      _themeBox = themeBox;
      _isDarkMode = _themeBox.get('isDarkMode', defaultValue: false)!;
      _isInitialized = true;
      notifyListeners();
    } else {
      _openBox();
    }
  }

  Future<void> _openBox() async {
    _themeBox = await Hive.openBox<bool>('theme');
    _isDarkMode = _themeBox.get('isDarkMode', defaultValue: false)!;
    _isInitialized = true;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  ThemeData get currentTheme =>
      _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeBox.put('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
