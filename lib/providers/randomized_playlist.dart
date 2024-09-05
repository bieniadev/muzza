import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nazwa_apki/models/song.dart';

final randomizedPlaylistProvider = StateProvider<List<Song>>((ref) {
  return [];
});
