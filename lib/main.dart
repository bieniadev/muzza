import 'package:flutter/material.dart';
import 'package:nazwa_apki/theme.dart';

import 'screens/main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MUZZA',
      theme: themeData,
      home: const HomeScreen(),
    );
  }
}
