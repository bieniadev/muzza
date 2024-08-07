import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/providers/player_names.dart';
import 'package:nazwa_apki/screens/song_select.dart';

class SetNicknamesScreen extends ConsumerStatefulWidget {
  const SetNicknamesScreen({super.key, required this.playersAmount, required this.songsPerPlayer});

  final int playersAmount;
  final int songsPerPlayer;

  @override
  ConsumerState<SetNicknamesScreen> createState() => _SetNicknamesScreenState();
}

class _SetNicknamesScreenState extends ConsumerState<SetNicknamesScreen> {
  final List<TextEditingController> _controllers = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.playersAmount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  startGame() {
    List<String> playerNames = [];
    for (var controller in _controllers) {
      playerNames.add(controller.text);
    }
    ref.read(userNicknamesProvider.notifier).state = playerNames;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    ref.read(currentScreenProvider.notifier).state = SongSelectScreen(songsPerPlayer: widget.songsPerPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustaw nazwy graczy'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const Spacer(flex: 1),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: widget.playersAmount,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _controllers[index],
                    cursorColor: Theme.of(context).colorScheme.onSecondary,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      constraints: BoxConstraints.tight(const Size(170, 60)),
                      labelText: 'Gracz ${index + 1}',
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: startGame,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
              padding: const EdgeInsets.all(16),
              child: Text('WYBÓR PIOSENEK', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
