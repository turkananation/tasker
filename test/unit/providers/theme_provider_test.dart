import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:tasker/src/data/providers/theme_provider.dart';

// Create a Mock for the Box
class MockBox extends Mock implements Box<bool> {
  // Add a variable to store the value
  bool _isDarkMode = false;

  // Override the get method to return the stored value
  @override
  bool get(key, {bool? defaultValue}) {
    if (key == 'isDarkMode') {
      return _isDarkMode;
    }
    return defaultValue ?? false;
  }

  // Override the put method to update the stored value
  @override
  Future<void> put(key, value) async {
    if (key == 'isDarkMode') {
      _isDarkMode = value;
    }
  }
}

void main() {
  late ThemeProvider themeProvider;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
  });

  group('ThemeProvider Tests', () {
    test('should initialize with default theme (light mode)', () {
      // Arrange
      // No need to mock get here, as the default is false
      // Act - Pass the mock box directly to constructor
      themeProvider = ThemeProvider(themeBox: mockBox);

      // Assert
      expect(themeProvider.isDarkMode, false);
      expect(themeProvider.currentTheme, isA<ThemeData>());
      expect(themeProvider.currentTheme.brightness, Brightness.light);
    });

    test(
      'should initialize with dark theme if saved preference is dark mode',
      () async {
        // Arrange
        await mockBox.put('isDarkMode', true); // Set the initial value to true

        // Act - Pass the mock box directly to constructor
        themeProvider = ThemeProvider(themeBox: mockBox);

        // Assert
        expect(themeProvider.isDarkMode, true);
        expect(themeProvider.currentTheme, isA<ThemeData>());
        expect(themeProvider.currentTheme.brightness, Brightness.dark);
      },
    );

    test('should toggle theme from light to dark', () async {
      // Arrange
      // No need to mock get here, as the default is false
      themeProvider = ThemeProvider(themeBox: mockBox);

      // Act
      themeProvider.toggleTheme();

      // Assert
      expect(themeProvider.isDarkMode, true);
      expect(themeProvider.currentTheme.brightness, Brightness.dark);
    });

    test('should toggle theme from dark to light', () async {
      // Arrange
      await mockBox.put('isDarkMode', true); // Set the initial value to true
      themeProvider = ThemeProvider(themeBox: mockBox);

      // Act
      themeProvider.toggleTheme();

      // Assert
      expect(themeProvider.isDarkMode, false);
      expect(themeProvider.currentTheme.brightness, Brightness.light);
    });

    test('should notify listeners when theme changes', () {
      // Arrange
      // No need to mock get here, as the default is false
      themeProvider = ThemeProvider(themeBox: mockBox);

      // Set up a listener counter
      int listenerCallCount = 0;
      themeProvider.addListener(() {
        listenerCallCount++;
      });

      // Act
      themeProvider.toggleTheme();

      // Assert
      expect(listenerCallCount, 1);
    });
  });
}
