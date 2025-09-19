import 'package:daily_wellness_tracker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const double borderRadius = 8.0;

  static const defaultPageMargin = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 24,
  );

  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Colors.teal[900]),
      bodyLarge: TextStyle(color: Colors.grey[800]),
      bodyMedium: TextStyle(color: Colors.grey[600]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}
