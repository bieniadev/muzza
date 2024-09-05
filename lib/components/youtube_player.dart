import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/models/current_song.dart';
import 'package:nazwa_apki/models/song.dart';
import 'package:nazwa_apki/providers/current_screen.dart';
import 'package:nazwa_apki/providers/current_song.dart';
import 'package:nazwa_apki/providers/randomized_playlist.dart';
import 'package:nazwa_apki/screens/summary.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends ConsumerStatefulWidget {
  const YoutubeVideoPlayer({super.key});

  @override
  ConsumerState<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends ConsumerState<YoutubeVideoPlayer> {
  // ignore: non_constant_identifier_names
  late YoutubePlayerController _YTcontroller;
  late List<Song> _shuffledPlaylist;
  late List<String> _viedoIdLists;
  int _idx = 0;

  skipSong() {
    _idx++;
    if (_idx >= _shuffledPlaylist.length) {
      ref.read(currentScreenProvider.notifier).state = const SummaryScreen();
      return;
    }
    CurrentSong song = CurrentSong(title: _shuffledPlaylist[_idx].title, currentIndex: _idx);
    ref.read(currentPlayingSongProvider.notifier).state = song;
    _YTcontroller.load(_shuffledPlaylist[_idx].videoId);
  }

  @override
  void initState() {
    super.initState();
    _shuffledPlaylist = ref.read(randomizedPlaylistProvider);
    _viedoIdLists = _shuffledPlaylist.map((song) => song.videoId).toList();

    _YTcontroller = YoutubePlayerController(
      initialVideoId: _viedoIdLists.first,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(currentPlayingSongProvider);
    return Column(
      children: [
        YoutubePlayer(
          controller: _YTcontroller,
          showVideoProgressIndicator: true,
          progressColors: const ProgressBarColors(
            playedColor: Color.fromARGB(255, 212, 104, 147),
            handleColor: Color.fromARGB(255, 239, 118, 167),
          ),
        ),
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
    );
  }
}
