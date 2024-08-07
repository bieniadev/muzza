import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/screens/home.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WYNIKI'),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tutaj wyniki gier'),
              GestureDetector(
                onTap: () => ref.read(currentScreenProvider.notifier).state = const HomeScreen(),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
                  padding: const EdgeInsets.all(16),
                  child: Text('Powrót na start', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
            ],
          ),
        ));
  }
}
