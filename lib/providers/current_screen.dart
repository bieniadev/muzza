import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/screens/home.dart';

final currentScreenProvider = StateProvider<Widget>((ref) {
  return const HomeScreen();
});
