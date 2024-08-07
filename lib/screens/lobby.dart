import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/screens/set_nicknames.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  final TextEditingController _playersAmount = TextEditingController();
  final TextEditingController _songsPerplayer = TextEditingController();

  confirmInput() {
    int playersAmount = int.parse(_playersAmount.text);
    int songsPerPlayer = int.parse(_songsPerplayer.text);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SetNicknamesScreen(
              playersAmount: playersAmount,
              songsPerPlayer: songsPerPlayer,
            )));
  }

  @override
  void dispose() {
    _playersAmount.dispose();
    _songsPerplayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustaw graczy'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _playersAmount,
              cursorColor: Theme.of(context).colorScheme.onSecondary,
              autocorrect: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                constraints: BoxConstraints.tight(const Size(200, 60)),
                labelText: 'Ilość Graczy',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _songsPerplayer,
              cursorColor: Theme.of(context).colorScheme.onSecondary,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                constraints: BoxConstraints.tight(const Size(200, 60)),
                labelText: 'Ilość piosenek na gracza',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: confirmInput,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
                padding: const EdgeInsets.all(16),
                child: Text('DALEJ', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
