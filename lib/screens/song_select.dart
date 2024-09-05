import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/models/playlist.dart';
import 'package:nazwa_apki/models/song.dart';
import 'package:nazwa_apki/providers/current_playlist.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/providers/player_names.dart';
import 'package:nazwa_apki/providers/randomized_playlist.dart';
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
  Playlist? _playlist;
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _playerNicknames = ref.read(userNicknamesProvider);
  }

  pickSong(int index, Song song, String playlistId) {
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
                    selectSong(song, playlistId);
                  },
                ),
              ],
            ));
  }

  searchSong(query) async {
    setState(() => _isLoading = !_isLoading);
    try {
      final response = await ApiServices().searchSongQuery(query);
      setState(() => _songsQuery = response);
    } catch (err) {
      setState(() => _isLoading = !_isLoading);
      throw Exception(err);
    }
    setState(() => _isLoading = !_isLoading);
  }

  int _currentPlayerSelectingIndex = 0;
  int _songsAmountSelected = 0;

  selectSong(Song song, String playlistId) async {
    _controller.clear();
    setState(() => _songsQuery.clear());
    setState(() => _isLoading = !_isLoading);

    try {
      final response = await ApiServices().addSongToPlaylist(song, playlistId);

      List<Song> songs = (response['songs'] as List<dynamic>).map((song) => Song(title: song['title'], videoId: song['videoId'], userName: song['userName'])).toList();
      _playlist = Playlist(
        id: response['_id'],
        playersCount: response['playersCount'],
        songsPerPlayer: response['songsPerPlayer'],
        songs: songs,
        createdAt: response['createdAt'],
        updatedAt: response['updatedAt'],
      );
      ref.read(currentPlaylistProvider.notifier).state = _playlist;
    } catch (err) {
      setState(() => _isLoading = !_isLoading);
      throw Exception(err);
    }

    setState(() => _songsAmountSelected++);

    if (_songsAmountSelected >= widget.songsPerPlayer) {
      setState(() {
        _songsAmountSelected = 0;
        _currentPlayerSelectingIndex++;
      });
      if (_currentPlayerSelectingIndex >= _playerNicknames.length) {
        return; // not sure if 'return' required
      }
    }
    setState(() => _isLoading = !_isLoading);
  }

  startGame() async {
    try {
      final response = await ApiServices().startGame(_playlist!.id);
      List<Song> songs = (response as List<dynamic>).map((song) => Song(title: song['title'], videoId: song['videoId'], userName: song['userName'])).toList();
      ref.read(randomizedPlaylistProvider.notifier).state = songs;
    } catch (err) {
      throw Exception(err);
    }

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
                    _songsQuery.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                Song songQuery = Song(
                                  title: _songsQuery[index]['title'],
                                  userName: _playerNicknames[_currentPlayerSelectingIndex],
                                  videoId: _songsQuery[index]['id'],
                                );
                                String currentPlaylistId = ref.read(currentPlaylistProvider)!.id;

                                return InkWell(
                                  onTap: () => pickSong(
                                    index,
                                    songQuery,
                                    currentPlaylistId,
                                  ),
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
                    _isLoading ? const CircularProgressIndicator(color: Colors.red) : const SizedBox(),
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
