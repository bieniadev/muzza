import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/providers/player_names.dart';
import 'package:nazwa_apki/screens/running_game.dart';

class SongSelectScreen extends ConsumerStatefulWidget {
  const SongSelectScreen({super.key, required this.songsPerPlayer});

  final int songsPerPlayer;

  @override
  ConsumerState<SongSelectScreen> createState() => _SongSelectScreenState();
}

class _SongSelectScreenState extends ConsumerState<SongSelectScreen> {
  List<String> _playerNicknames = [];
  @override
  void initState() {
    super.initState();
    _playerNicknames = ref.read(userNicknamesProvider);
  }

  int _currentPlayerSelectingIndex = 0;
  int _songsAmountSelected = 0;
  selectSong() {
    setState(() {
      _songsAmountSelected++;
    });
    if (_songsAmountSelected >= widget.songsPerPlayer) {
      setState(() {
        _songsAmountSelected = 0;
        _currentPlayerSelectingIndex++;
      });
      if (_currentPlayerSelectingIndex >= _playerNicknames.length) {
        return; // nie wiem czy potrzebny chcek na break petli
      }
    }
  }

  startGame() {
    ref.read(currentScreenProvider.notifier).state = const RunningGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybór piosenki nr ${_songsAmountSelected + 1}'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
          child: _currentPlayerSelectingIndex < _playerNicknames.length
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Teraz wybiera: ${_playerNicknames[_currentPlayerSelectingIndex]}'),
                    GestureDetector(
                      onTap: selectSong,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
                        padding: const EdgeInsets.all(16),
                        child: Text('KOLEJNA', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Wszystkie piosenki wybrane!'),
                    GestureDetector(
                      onTap: startGame,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
                        padding: const EdgeInsets.all(16),
                        child: Text('START GRY', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      ),
                    ),
                  ],
                )),
    );
  }
}
