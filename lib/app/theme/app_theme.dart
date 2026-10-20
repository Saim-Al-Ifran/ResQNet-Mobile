
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFEF3340);
  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color darkBackground = Color(0xFF0B1420);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.dark,
      ),
    );
  }
}
