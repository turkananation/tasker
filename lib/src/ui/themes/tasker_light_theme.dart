import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasker/src/ui/themes/tasker_colors.dart';

class TaskerLightTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: TaskerColors.primary),
      scaffoldBackgroundColor: TaskerColors.backgroundLight,
      fontFamily: GoogleFonts.nunitoSans().fontFamily,
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: TaskerColors.textPrimary),
        headlineMedium: TextStyle(color: TaskerColors.textPrimary),
        headlineSmall: TextStyle(color: TaskerColors.textPrimary),
        labelLarge: TextStyle(color: TaskerColors.textPrimary),
        labelMedium: TextStyle(color: TaskerColors.textPrimary),
        labelSmall: TextStyle(color: TaskerColors.textPrimary),
        titleLarge: TextStyle(color: TaskerColors.textPrimary),
        titleMedium: TextStyle(color: TaskerColors.textPrimary),
        titleSmall: TextStyle(color: TaskerColors.textPrimary),
        displayLarge: TextStyle(color: TaskerColors.textPrimary),
        displayMedium: TextStyle(color: TaskerColors.textPrimary),
        displaySmall: TextStyle(color: TaskerColors.textPrimary),
        bodyLarge: TextStyle(color: TaskerColors.textPrimary),
        bodyMedium: TextStyle(color: TaskerColors.textPrimary),
        bodySmall: TextStyle(color: TaskerColors.textPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: TaskerColors.primary,
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
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
