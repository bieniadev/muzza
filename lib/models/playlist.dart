import 'package:nazwa_apki/models/song.dart';

class Playlist {
  String id;
  int playersCount;
  int songsPerPlayer;
  List<Song> songs;
  String createdAt;
  String updatedAt;

  Playlist({
    required this.id,
    required this.playersCount,
    required this.songsPerPlayer,
    required this.songs,
    required this.createdAt,
    required this.updatedAt,
  });
}
