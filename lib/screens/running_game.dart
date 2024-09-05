import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/components/youtube_player.dart';
import 'package:nazwa_apki/models/current_song.dart';
import 'package:nazwa_apki/models/song.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/providers/current_song.dart';
import 'package:nazwa_apki/providers/randomized_playlist.dart';
import 'package:nazwa_apki/screens/summary.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RunningGame extends ConsumerStatefulWidget {
  const RunningGame({super.key});

  @override
  ConsumerState<RunningGame> createState() => _RunningGameState();
}

class _RunningGameState extends ConsumerState<RunningGame> {
  @override
  Widget build(BuildContext context) {
    List<Song> _shuffledPlaylist = ref.read(randomizedPlaylistProvider);
    CurrentSong _currentSong = ref.read(currentPlayingSongProvider);
    int idx = _currentSong.currentIndex;

    skipSong() {
      print('CO TO JEST WCZESNIEJ: ${_shuffledPlaylist[idx].videoId}');
      print('CURRENT SONG: ${_currentSong.title}');
      print('CURRENT INDEX: ${_currentSong.currentIndex}');
      idx++;
      print('INDEX INCREMENTED: ${idx}');
      print('CO TO JEST? ${_shuffledPlaylist[idx].videoId}');

      YoutubePlayerController updatedController = YoutubePlayerController(
        initialVideoId: _shuffledPlaylist[idx].videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      setState(() {
        _currentSong.controller.dispose();
        _currentSong.controller = updatedController;
      });
      ref.read(currentPlayingSongProvider.notifier).state = CurrentSong(
        controller: updatedController,
        currentIndex: idx,
        title: _shuffledPlaylist[idx].title,
        videoId: _shuffledPlaylist[idx].videoId,
      );
      //   ref.read(currentPlayingSongProvider.notifier).state.controller.dispose();
      //   ref.read(currentPlayingSongProvider.notifier).state.controller = updatedController;
      print('AFTER SONG: ${_currentSong.title}');
      print('INDEX AFTER: ${_currentSong.currentIndex}');
    }

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
              Text(_currentSong.title),
              const YoutubeVideoPlayer(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: skipSong,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.onSecondary),
                  padding: const EdgeInsets.all(16),
                  child: Text('Kolejna Nuta', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                ),
              ),
            ],
          ),
        ));
  }
}
