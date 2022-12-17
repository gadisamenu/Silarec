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
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 26, color: Colors.white, fontWeight: FontWeight.w600),
      bodySmall:
          TextStyle(fontSize: 14, color: Color.fromARGB(255, 126, 132, 141)),
      labelMedium: TextStyle(fontSize: 16, color: Colors.white),
    ),
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
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 35, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 18, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
      bodyLarge: TextStyle(
          fontSize: 26, color: Colors.black, fontWeight: FontWeight.w600),
      bodySmall: TextStyle(fontSize: 14, color: Colors.black),
      labelMedium: TextStyle(fontSize: 16, color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 0, 0, 0),
    ),
  );
}
