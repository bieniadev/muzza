import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/providers/current_playlist.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/providers/player_names.dart';
import 'package:nazwa_apki/screens/running_game.dart';
import 'package:nazwa_apki/services/connections.dart';

class SongSelectScreen extends ConsumerStatefulWidget {
  const SongSelectScreen({super.key, required this.songsPerPlayer});

  final int songsPerPlayer;

  @override
  ConsumerState<SongSelectScreen> createState() => _SongSelectScreenState();
}

class _SongSelectScreenState extends ConsumerState<SongSelectScreen> {
  List<String> _playerNicknames = [];
  List<dynamic> _songsQuery = [];
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _playerNicknames = ref.read(userNicknamesProvider);
  }

  pickSong(index, String title, String videoId, String userName, String playlistId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Zatwierdź wybór'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(_songsQuery[index]['thumbnail']),
                  Text(_songsQuery[index]['title']),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Anuluj'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    selectSong(title, videoId, userName, playlistId);
                  },
                ),
              ],
            ));
  }

  searchSong(query) async {
    final response = await ApiServices().searchSongQuery(query);
    log('RESPONSE: $response');
    setState(() {
      _songsQuery = response;
    });
  }

  int _currentPlayerSelectingIndex = 0;
  int _songsAmountSelected = 0;

  selectSong(String title, String videoId, String userName, String playlistId) async {
    try {
      final response = await ApiServices().addSongToPlaylist(title, videoId, userName, playlistId);
      print('RESPONSE: $response');
      //to do: zrob dobrze ok?
    } catch (err) {
      throw Exception(err);
    }
    setState(() {
      _songsAmountSelected++;
    });

    if (_songsAmountSelected >= widget.songsPerPlayer) {
      setState(() {
        _songsAmountSelected = 0;
        _currentPlayerSelectingIndex++;
      });
      if (_currentPlayerSelectingIndex >= _playerNicknames.length) {
        return; // not sure if 'return' required
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
        title: _currentPlayerSelectingIndex < _playerNicknames.length ? Text('Wybór piosenki nr ${_songsAmountSelected + 1}') : const Text('Wystartuj grę'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
          child: _currentPlayerSelectingIndex < _playerNicknames.length
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Teraz wybiera: ${_playerNicknames[_currentPlayerSelectingIndex]}', style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 10),
                    _songsQuery.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => pickSong(index, _songsQuery[index]['title'], _songsQuery[index]['id'], _playerNicknames[_currentPlayerSelectingIndex], ref.read(currentPlaylistProvider)['_id']),
                                  child: Column(
                                    children: [
                                      Image.network(_songsQuery[index]['thumbnail']),
                                      Text(_songsQuery[index]['title']),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _controller,
                        cursorColor: Theme.of(context).colorScheme.onSecondary,
                        onSubmitted: searchSong,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.inversePrimary)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary)),
                        ),
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
