import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/screens/summary.dart';

class RunningGame extends ConsumerWidget {
  const RunningGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    endGame() {
      ref.read(currentScreenProvider.notifier).state = const SummaryScreen();
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('GRANIE'),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tutaj odtwarzacz piosenek rel?'),
              GestureDetector(
                onTap: endGame,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
                  padding: const EdgeInsets.all(16),
                  child: Text('FORCE KONIEC GRY', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
            ],
          ),
        ));
  }
}
