import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/components/youtube_player.dart';
import 'package:nazwa_apki/models/current_song.dart';
import 'package:nazwa_apki/providers/current_song.dart';
import 'package:nazwa_apki/providers/randomized_playlist.dart';

class RunningGame extends ConsumerStatefulWidget {
  const RunningGame({super.key});

  @override
  ConsumerState<RunningGame> createState() => _RunningGameState();
}

class _RunningGameState extends ConsumerState<RunningGame> {
  late CurrentSong _currentSong;
  late int _songsAmount;
  @override
  void initState() {
    super.initState();
    _songsAmount = ref.read(randomizedPlaylistProvider).length;
  }

  @override
  Widget build(BuildContext context) {
    _currentSong = ref.watch(currentPlayingSongProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('ĆPANIE 😎 ${_currentSong.currentIndex + 1} / $_songsAmount'),
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_currentSong.title),
              const YoutubeVideoPlayer(),
            ],
          ),
        ));
  }
}
