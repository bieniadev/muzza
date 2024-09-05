import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/models/current_song.dart';
import 'package:nazwa_apki/models/song.dart';
import 'package:nazwa_apki/providers/randomized_playlist.dart';

final currentPlayingSongProvider = StateProvider<CurrentSong>((ref) {
  List<Song> selectedSongs = ref.read(randomizedPlaylistProvider);
  return CurrentSong(
    title: selectedSongs[0].title,
    currentIndex: 0,
  );
});
