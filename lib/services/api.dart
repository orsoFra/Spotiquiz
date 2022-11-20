import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth.dart';

class API {
  //prints all the user's playlists
  void getPlaylists() async {
    final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https('api.spotify.com', '/v1/me/playlists');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ' + value!,
      'Content-Type': 'application/json'
    });

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse.toString());
  }

  //printer for long responses
  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //Get a random offset for a track in the saved library
  Future<int> getOffset() async {
    final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https('api.spotify.com', '/v1/me/tracks');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ' + value!,
      'Content-Type': 'application/json'
    });

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(JsonEncoder().convert(decodedResponse));
    var numOfTracks = decodedResponse['total'];
    var offset = Random().nextInt(numOfTracks);
    //print(offset);
    return offset;
  }

  //retrievs the track'l URI
  Future<String> getRandomSongFromLibrary() async {
    final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var offset = await getOffset();
    var newurl = Uri.https(
        'api.spotify.com',
        '/v1/me/tracks/',
        {"offset": offset, 'limit': 1}
            .map((key, value) => MapEntry(key, value.toString())));
    var newresponse = await http.get(
      newurl,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    var decodedResponse = jsonDecode(utf8.decode(newresponse.bodyBytes)) as Map;
    //printWrapped(decodedResponse.toString());
    if (decodedResponse['items'][0]['track']['preview_url'] == null)
      return getRandomSongFromLibrary(); //in case of null preview, returns another song
    return decodedResponse['items'][0]['track']['preview_url'];
  }

//pass a track ID and return some info
  Future<Map<dynamic, dynamic>> getInfoTrack(String track) async {
    final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var offset = await getOffset();
    var newurl = Uri.https('api.spotify.com', '/v1/me/tracks/',
        {"id": track}.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      newurl,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    return decodedResponse;
  }
}
