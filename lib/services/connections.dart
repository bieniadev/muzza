// api ten, url do naszego api: muzza-backed-production.up.railway.app

import 'dart:convert';

import 'package:http/http.dart';

class ApiServices {
  //api link
  String baseUrl = 'https://muzza-backed-production.up.railway.app';

  //create playlist
  Future<Map<String, dynamic>> createPlaylist(int playersCount, int songsPerPlayer) async {
    Map<String, dynamic> request = {
      'playersCount': playersCount,
      'songsPerPlayer': songsPerPlayer,
    };
    final body = jsonEncode(request);
    final uri = Uri.parse('$baseUrl/api/playlists');
    final requestHeaders = {'Content-Type': 'application/json'};

    Response response = await post(uri, headers: requestHeaders, body: body);

    if (response.statusCode == 201) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  //search song
  Future<dynamic> searchSongQuery(String query) async {
    final uri = Uri.parse('$baseUrl/api/playlists/search?q=$query');
    final requestHeaders = {'Content-Type': 'application/json'};

    Response response = await get(uri, headers: requestHeaders);

    if (response.statusCode == 200) {
      final dynamic result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  // add song to playlist in db
  Future<dynamic> addSongToPlaylist(String title, String videoId, String userName, String playlistId) async {
    Map<String, dynamic> request = {
      'title': title,
      'videoId': videoId,
      'userName': userName,
    };
    final body = jsonEncode(request);
    final uri = Uri.parse('$baseUrl/api/playlists/$playlistId/add-song');
    final requestHeaders = {'Content-Type': 'application/json'};

    Response response = await patch(uri, headers: requestHeaders, body: body);

    if (response.statusCode == 200) {
      final dynamic result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
