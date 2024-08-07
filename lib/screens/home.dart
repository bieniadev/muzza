import 'package:flutter/material.dart';
import 'package:nazwa_apki/screens/lobby.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MUZZA'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Kliknij w guzik by stworzyć lobby'),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LobbyScreen())),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
              padding: const EdgeInsets.all(16),
              child: Text('STWÓRZ', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
          ),
        ],
      )),
    );
  }
}
