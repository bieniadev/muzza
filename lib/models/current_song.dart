import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CurrentSong {
  String title;
  String videoId;
  int currentIndex;
  YoutubePlayerController controller;

  CurrentSong({
    required this.title,
    required this.videoId,
    required this.currentIndex,
    required this.controller,
  });
}
