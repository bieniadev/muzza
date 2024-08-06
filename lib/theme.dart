import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 239, 118, 167),
    background: const Color.fromARGB(255, 216, 216, 216),
    primary: Colors.grey.shade100,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade800,
    onPrimary: const Color.fromARGB(255, 212, 104, 147),
    onSecondary: const Color.fromARGB(255, 219, 81, 136),
  ),
);
