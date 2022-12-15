import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 22, 22, 34),
      secondary: Color.fromARGB(255, 0, 102, 255),
      tertiary: Color(0xFF8B8B94),
      onPrimary: Color.fromARGB(255, 39, 39, 58),
    ),
    textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 35, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 18, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 11, color: Color(0xFF8B8B94)),
        bodyLarge: TextStyle(fontSize: 26, color: Colors.white),
        bodySmall: TextStyle(fontSize: 16, color: Colors.white)),
    iconTheme: const IconThemeData(
      color: Color(0xFF8B8B94),
    ),
  );
  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 227, 233, 239),
      secondary: Color.fromARGB(255, 0, 102, 255),
      tertiary: Colors.green,
      onPrimary: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  );
}
