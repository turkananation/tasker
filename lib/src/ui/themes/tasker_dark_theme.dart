import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasker/src/ui/themes/tasker_colors.dart';

class TaskerDarkTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: TaskerColors.primaryDark),
      scaffoldBackgroundColor: TaskerColors.backgroundDark,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: TaskerColors.textLight),
        headlineMedium: TextStyle(color: TaskerColors.textLight),
        headlineSmall: TextStyle(color: TaskerColors.textLight),
        labelLarge: TextStyle(color: TaskerColors.textLight),
        labelMedium: TextStyle(color: TaskerColors.textLight),
        labelSmall: TextStyle(color: TaskerColors.textLight),
        titleLarge: TextStyle(color: TaskerColors.textLight),
        titleMedium: TextStyle(color: TaskerColors.textLight),
        titleSmall: TextStyle(color: TaskerColors.textLight),
        displayLarge: TextStyle(color: TaskerColors.textLight),
        displayMedium: TextStyle(color: TaskerColors.textLight),
        displaySmall: TextStyle(color: TaskerColors.textLight),
        bodyLarge: TextStyle(color: TaskerColors.textLight),
        bodyMedium: TextStyle(color: TaskerColors.textLight),
        bodySmall: TextStyle(color: TaskerColors.textLight),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: TaskerColors.black,
        foregroundColor: TaskerColors.backgroundLight,
        elevation: 8.0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: TaskerColors.textLight,
          fontSize: 20.0,
          fontFamily: GoogleFonts.nunitoSans().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
