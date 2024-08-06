import 'package:flutter/material.dart';

ThemeData themeDark = ThemeData(
  useMaterial3: true,
  primaryColor: const Color.fromARGB(255, 80, 70, 102),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 59, 46, 161),
    background: const Color.fromARGB(255, 60, 52, 77),
    secondary: const Color.fromARGB(255, 131, 62, 177),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      letterSpacing: 1.5,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
    ),
  ),
);
