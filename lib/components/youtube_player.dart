import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/models/current_song.dart';
import 'package:nazwa_apki/models/song.dart';
import 'package:nazwa_apki/providers/current_song.dart';
import 'package:nazwa_apki/providers/randomized_playlist.dart';
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

  @override
  void initState() {
    super.initState();
    _shuffledPlaylist = ref.read(randomizedPlaylistProvider);
    _viedoIdLists = _shuffledPlaylist.map((song) => song.videoId).toList();
    print('LIST OF IDS $_viedoIdLists');
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
    return YoutubePlayer(
      controller: _YTcontroller,
      showVideoProgressIndicator: true,
//   videoProgressIndicatorColor: Colors.amber,
      progressColors: const ProgressBarColors(
        playedColor: Color.fromARGB(255, 212, 104, 147),
        handleColor: Color.fromARGB(255, 239, 118, 167),
      ),
//   onReady: () {
//     _YTcontroller.addListener(listener);
//   },
    );
  }
}
