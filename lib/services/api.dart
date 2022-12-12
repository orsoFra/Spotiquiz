import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/MyStorage.dart';

enum keys {
  DO,
  DO_diesis,
  RE,
  RE_diesis,
  MI,
  FA,
  FA_diesis,
  SOL,
  SOL_diesis,
  LA,
  LA_diesis,
  SI
}

class API {
  API(this._storage);
  final IStorage _storage;
  //prints all the user's playlists
  void getPlaylists() async {
    final _storage = FlutterSecureStorage();
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
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //Get a random offset for a track in the saved library
  Future<int> getOffset() async {
    //final _storage = FlutterSecureStorage();
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
    return offset;
  }

  Future<bool> tryToken() async {
    //final _storage = FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https('api.spotify.com', '/v1/me');
    try {
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  //retrievs the track'l URI
  Future<Map<String, dynamic>> getRandomSongFromLibrary(
      http.Client http) async {
    //final _storage = new FlutterSecureStorage();
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
    if (newresponse.statusCode != 200) {
      throw Exception('Error in method getInfoTrack');
    }
    var decodedResponse = jsonDecode(utf8.decode(newresponse.bodyBytes)) as Map;
    //printWrapped(decodedResponse.toString());
    var previewUrl = decodedResponse['items'][0]['track']['preview_url'];
    //print(decodedResponse['items'][0]['track']['id']);
    //var infoOnTrack = getInfoTrack(decodedResponse['items'][0]['track']['id']);
    //printWrapped(infoOnTrack);
    if (previewUrl != null) {
      var infoOnTrack =
          getInfoTrack(decodedResponse['items'][0]['track']['id'], http);
      return infoOnTrack;
    }
    return getRandomSongFromLibrary(
        http); //in case of null preview, returns another song;
  }

//pass a track ID and return some info: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
  Future<Map<String, dynamic>> getInfoTrack(
      String track, http.Client http) async {
    String? value = await _storage.read(key: 'access_token');
    var newurl = Uri.https(
      'api.spotify.com',
      '/v1/tracks/${track}',
    );
    var response = await http.get(
      newurl,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error in method getInfoTrack');
    }

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    data.remove('available_markets');
    data['album'].remove('available_markets');
    data['album']['artists'][0].remove('external_urls');
    data['album']['artists'][0].remove('type');
    //printWrapped(data.entries.toString());
    getRandomTracksFromArtist(data['album']['artists'][0]['name'], http);
    getRandomAlbumsFromArtist(data['album']['artists'][0]['name'], http);
    getTempoList(track, http);
    getKeysList(track, http);
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

//get audio features from a track: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-audio-features
//$track contains the track id
  Future<Map<String, dynamic>> getFeaturesTrack(
      String track, http.Client http) async {
    //https://api.spotify.com/v1/audio-features/id
    //final _storage = FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https(
      'api.spotify.com',
      '/v1/audio-features/${track}',
    );
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error in method getFeaturesTrack');
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    //printWrapped(data.entries.toString());
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  //GET 3 random titles of songs from the same artist of another track
  Future<List<String>> getRandomTracksFromArtist(
      String artist, http.Client http,
      [int? off]) async {
    //final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var offset = Random().nextInt(995);
    if (off != null) offset = off; //pick offset from the param
    //it's 995 since the offset limit is 1000
    var url = Uri.https(
        'api.spotify.com',
        '/v1/search/',
        {'q': 'artist:' + artist, "offset": offset, 'limit': 4, 'type': 'track'}
            .map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error in method getRandomTracksFromArtist');
    }
    //print('Searching for artist:' + artist);
    List<String> result = [];
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['tracks']['total'] < offset)
      return getRandomTracksFromArtist(artist, http, 0);
    //print(url);
    for (int i = 0; i < 4; i++) {
      result.add(decodedResponse['tracks']['items'][i]['name']);
    }
    //print(result);
    return result;
  } //getRandomTracks

  Future<List<String>> getRandomAlbumsFromArtist(
      String artist, http.Client http,
      [int? off]) async {
    //final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https(
        'api.spotify.com',
        '/v1/search/',
        {'q': 'artist:' + artist, "offset": 0, 'limit': 4, 'type': 'album'}
            .map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error in method getRandomAlbumsFromArtist');
    }
    //print('Searching for artist:' + artist);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var offset = Random().nextInt(decodedResponse['albums']
        ['total']); //only get from the response the maximum number of items

    if (off != null) offset = off; //pick offset from the param
    url = Uri.https(
        'api.spotify.com',
        '/v1/search/',
        {'q': 'artist:' + artist, "offset": offset, 'limit': 4, 'type': 'album'}
            .map((key, value) => MapEntry(key, value.toString())));
    response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    //print('Searching for artist:' + artist);
    List<String> result = [];
    decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse['albums']['total'] < offset)
      return getRandomTracksFromArtist(artist, http, 0);
    //print(url);
    for (int i = 0; i < 4; i++) {
      result.add(decodedResponse['albums']['items'][i]['name']);
    }
    //print(result);
    return result;
  } //getRandomTracks

  Future<Map<String, dynamic>> getInfoUser(http.Client http) async {
    //final _storage = const FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https(
      'api.spotify.com',
      '/v1/me/',
    );
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + value!,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error in method getInfoUser');
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse.entries);
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    //print(data.entries);
    data['imageUrl'] = data['images'][0]['url'];
    //print(data['imageUrl']);
    return data.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<List<String>> getTempoList(String track, http.Client http) async {
    Map<dynamic, dynamic> data = await getFeaturesTrack(track, http);
    List<String> result = [];
    result.add(data['time_signature'] + '/4');
    for (int i = 0; i < 4; i++) {
      int tempo = Random().nextInt(7);
      if (tempo.toString() != data['time_signature'] &&
          result.indexOf(tempo.toString() + '/4') == -1) {
        result.add(tempo.toString() + '/4');
      }
    }
    print(result.toString());
    return result;
  }

  Future<List<String>> getKeysList(String track, http.Client http) async {
    Map<dynamic, dynamic> data = await getFeaturesTrack(track, http);
    List<String> result = [];
    int keyIndex = int.parse(data['key']);
    if (keyIndex == -1)
      return result; //in case there is no key signature detected
    result.add(keys.values[keyIndex].toString().substring(5));
    for (int i = 0; i < 4; i++) {
      int rk = Random().nextInt(11);
      if (keys.values[rk] != data['key'] &&
          result.indexOf(keys.values[rk].toString().substring(5)) == -1) {
        result.add(keys.values[rk].toString().substring(5));
      }
    }
    print(result.toString());
    return result;
  }
} //auth


