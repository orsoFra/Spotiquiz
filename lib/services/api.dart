import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/expect.dart';

import '../models/MyStorage.dart';
import '../models/question_model.dart';

enum keys { DO, DO_diesis, RE, RE_diesis, MI, FA, FA_diesis, SOL, SOL_diesis, LA, LA_diesis, SI }

// coverage:ignore-start
const int TIMEOUT_IN_SECONDS = 300;
final List randomAlbums = ['The Wall', 'Oysters', 'Mamma Mia Deluxe', 'Bycicle', 'A collection of dance songs', 'Materials', 'Demons'];
final List randomSongs = ['Another Brick in the Wall', 'Oysters to Drink', 'Mamma Mia Pizzeria', 'Song 4', 'Dance dance revolution', 'Plutonium', 'Birds'];

// coverage:ignore-end
class API {
  API(this._storage);
  final IStorage _storage;
  //prints all the user's playlists
  /*void getPlaylists() async {
    final _storage = FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https('api.spotify.com', '/v1/me/playlists');
    var response = await http.get(url, headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'}).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse.toString());
  }*/

  void flushCredentials() async {
    final _storage = FlutterSecureStorage();
    await _storage.deleteAll();
  }

  // coverage:ignore-start
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
    var response = await http.get(url, headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'}).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    var numOfTracks = decodedResponse['total'];
    var offset = Random().nextInt(numOfTracks);
    return offset;
  }
  // coverage:ignore-end

  Future<bool> tryToken() async {
    //final _storage = FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https('api.spotify.com', '/v1/me');
    try {
      var response = await http.get(url, headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'}).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
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
  Future<Map<dynamic, dynamic>> getRandomSongFromLibraryJSON(http.Client http, [int? givenOffset]) async {
    //final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var offset = 0;
    if (givenOffset == null) offset = await getOffset();
    var newurl = Uri.https('api.spotify.com', '/v1/me/tracks/', {"offset": offset, 'limit': 1}.map((key, value) => MapEntry(key, value.toString())));
    var newresponse = await http.get(
      newurl,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (newresponse.statusCode != 200) {
      throw Exception('Error in method getInfoTrack');
    }
    var decodedResponse = jsonDecode(utf8.decode(newresponse.bodyBytes)) as Map;
    //printWrapped(decodedResponse.toString());
    var previewUrl = decodedResponse['items'][0]['track']['preview_url'];
    //print(decodedResponse['items'][0]['track']['id']);
    //var infoOnTrack = getInfoTrack(decodedResponse['items'][0]['track']['id']);
    //printWrapped(infoOnTrack);
    if (previewUrl != null && previewUrl != Null) {
      print('preview not null');
      return getInfoTrackJSON(decodedResponse['items'][0]['track']['id'], http, previewUrl);
    }
    print('recursive call');
    return getRandomSongFromLibraryJSON(http); //in case of null preview, returns another song;
  }

//pass a track ID and return some info: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
  Future<Map<dynamic, dynamic>> getInfoTrackJSON(String track, http.Client http, [String? pUrl]) async {
    String? value = await _storage.read(key: 'access_token');
    var newurl = Uri.https(
      'api.spotify.com',
      '/v1/tracks/${track}',
    );
    var response = await http.get(
      newurl,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      throw Exception('Error in method getInfoTrack');
    }

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    data.remove('available_markets');
    data['album'].remove('available_markets');
    if (pUrl != null && pUrl != Null) {
      //print('preview not null recursive');
      data['preview_url'] = pUrl;
    }
    //printWrapped(data.entries.toString());
    //getRandomTracksFromArtist(data['album']['artists'][0]['name'], http);
    //getRandomAlbumsFromArtist(data['album']['artists'][0]['name'], http);
    //print(decodedResponse);
    return data;
  }

//get audio features from a track: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-audio-features
//$track contains the track id
  Future<Map<String, dynamic>> getFeaturesTrack(String track, http.Client http) async {
    //https://api.spotify.com/v1/audio-features/id
    //final _storage = FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var url = Uri.https(
      'api.spotify.com',
      '/v1/audio-features/${track}',
    );
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
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
  Future<List<String>> getRandomTracksFromArtist(String id, http.Client http, [int? off]) async {
    //final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    //var offset = Random().nextInt(50);
    //if (off != null) offset = off; //pick offset from the param
    //it's 995 since the offset limit is 1000
    var url = Uri.https(
        'api.spotify.com',
        '/v1/artists/' + id + '/top-tracks',
        {
          "country": 'IT',
        }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      throw Exception('Error in method getRandomTracksFromArtist');
    }
    //print('Searching for artist:' + artist);
    List<String> result = [];
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(url);
    for (int i = 0; i < 4; i++) {
      if (i < decodedResponse['tracks'].length)
        result.add(decodedResponse['tracks'][i]['name']);
      else {
        result.add(randomSongs[Random().nextInt(randomSongs.length)]);
      }
    }
    //print(result);
    return result;
  } //getRandomTracks

  Future<List<String>> getRandomAlbumsFromArtist(String artist, http.Client http, [int? off]) async {
    //final _storage = new FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    var offset = Random().nextInt(15); //only get from the response the maximum number of items
    //get offset for the query
    var url = Uri.https(
        'api.spotify.com',
        '/v1/artists/' + artist + '/albums',
        {
          "offset": offset,
          'limit': 4,
        }.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      print(response.body.toString());
      throw Exception('Error in method getRandomAlbumsFromArtist');
    }
    //print('Searching for artist:' + artist);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    if (decodedResponse['total'] < offset) {
      //print(offset);

      //if (off != null) offset = off; //pick offset from the param
      url = Uri.https(
          'api.spotify.com',
          '/v1/artists/' + artist + '/albums',
          {
            "offset": 0,
            'limit': 4,
          }.map((key, value) => MapEntry(key, value.toString())));
      response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ' + value, 'Content-Type': 'application/json'},
      ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    }
    /*if (response.statusCode != 200) {
      print(response.body.toString());
      throw Exception('Error in method getRandomAlbumsFromArtist 2');
    }
    //print('Searching for artist:' + artist);
    */
    List<String> result = [];
    decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(url);
    for (int i = 0; i < 4; i++) {
      if (i < decodedResponse['items'].length)
        result.add(decodedResponse['items'][i]['name']);
      else
        result.add(randomAlbums[Random().nextInt(randomAlbums.length)]);
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
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      Duration(milliseconds: 300);
      //return getInfoUser(http);
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

  Future<String> getIdUser(http.Client http) async {
    //final _storage = const FlutterSecureStorage();
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https(
      'api.spotify.com',
      '/v1/me/',
    );
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      throw Exception('Error in method getIDUser');
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse.entries);
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    //print(data.entries);

    //print(data['imageUrl']);
    return data['id'];
  }
/*
  Future<List<String>> getTempoList(String track, http.Client http) async {
    Map<dynamic, dynamic> data = await getFeaturesTrack(track, http);
    List<String> result = [];
    result.add(data['time_signature'] + '/4');
    for (int i = 0; i < 4; i++) {
      int tempo = Random().nextInt(7);
      if (tempo.toString() != data['time_signature'] && result.indexOf(tempo.toString() + '/4') == -1) {
        result.add(tempo.toString() + '/4');
      }
    }
    print(result.toString());
    return result;
  }*/
/*
  Future<List<String>> getKeysList(String track, http.Client http) async {
    Map<dynamic, dynamic> data = await getFeaturesTrack(track, http);
    List<String> result = [];
    int keyIndex = int.parse(data['key']);
    if (keyIndex == -1) return result; //in case there is no key signature detected
    result.add(keys.values[keyIndex].toString().substring(5));
    for (int i = 0; i < 4; i++) {
      int rk = Random().nextInt(11);
      if (keys.values[rk] != data['key'] && result.indexOf(keys.values[rk].toString().substring(5)) == -1) {
        result.add(keys.values[rk].toString().substring(5));
      }
    }
    print(result.toString());
    return result;
  }


  Future<List<dynamic>> getUserQuizScores(String userid, http.Client http) async {
    String id = '21q4wwalokcky25op74guvjcq';
    var url = Uri.https('639ad7f8d514150197412361.mockapi.io', '/spotiquiz/quizzes', {"user": id, 'limit': 10}.map((key, value) => MapEntry(key, value.toString())));
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      throw Exception('Error in method getUserQuizScores');
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as List;

    return decodedResponse;
  }

  Future<List<String>> getRandomArtistsFromUser(http.Client http) async {
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https('api.spotify.com', '/v1/me/following', {"offset": 0, 'limit': 4, 'type': 'artist'}.map((key, value) => MapEntry(key, value.toString())));
    // var url = Uri.https('api.spotify.com', '/v1/me/following');
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      throw Exception("Invalid response statusCode: ${response.statusCode}");
    }
    //print('Searching for artist:' + artist);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    var offset = Random().nextInt(decodedResponse['artists']['total']); //only get from the response the maximum number of items

    url = Uri.https('api.spotify.com', '/v1/me/following', {"limit ": 4, "offset": offset, 'type': 'artist'}.map((key, value) => MapEntry(key, value.toString())));
    response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      print(response.body.toString());
      throw Exception('Error in method getRandomAlbumsFromArtist 2');
    }
    decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    List<String> data = [];
    for (int i = 0; i < 4; i++) {
      data.add(decodedResponse['artists']['items'][i]['name']);
    }
    print(data);
    return data;
  }*/

  Future<List<String>> getRelatedArtists(String id, http.Client http) async {
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https('api.spotify.com', '/v1/artists/' + id + '/related-artists');
    // var url = Uri.https('api.spotify.com', '/v1/me/following');
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception("Invalid response statusCode: ${response.statusCode}"); // TODO: errore 403, probabilmente questa operazione (me/following) non è autorizzata per questo token
    }
    //print('Searching for artist:' + artist);
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    List<String> data = [];
    for (int i = 0; i < 4; i++) {
      if (i < decodedResponse['artists'].length)
        data.add(decodedResponse['artists'][i]['name']);
      else
        data.add('');
    }
    //print(data);
    return data;
  }

  List<int> getRandomYears(int referenceYear) {
    List<int> result = [];
    int thisYear = DateTime.now().year;
    int minYear = referenceYear - 10;
    int maxYear = min(referenceYear + 10, thisYear);
    while (result.length < 3) {
      int randomYear = minYear + Random().nextInt(maxYear - minYear);
      if (randomYear == referenceYear || result.contains(randomYear)) {
        continue;
      }
      result.add(randomYear);
    }
    return result;
  }

  Future<Map<String, dynamic>> getInfoOfUser(http.Client http, String id) async {
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https(
      'api.spotify.com',
      '/v1/users/' + id,
    );
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      throw Exception('Error in method getInfoOfUser');
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

  Future<String> getNameOfUser(http.Client http, String id) async {
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https(
      'api.spotify.com',
      '/v1/users/' + id,
    );
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      return 'NO USERNAME';
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse.entries);
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    //print(data.entries);
    //data['imageUrl'] = data['images'][0]['url'];
    //print(data['imageUrl']);
    return data['display_name'];
  }

  Future<String> getNameOfArtist(http.Client http, String id) async {
    String? value = await _storage.read(key: 'access_token');
    //get offset for the query
    var url = Uri.https(
      'api.spotify.com',
      '/v1/artists/' + id,
    );
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ' + value!, 'Content-Type': 'application/json'},
    ).timeout(new Duration(seconds: TIMEOUT_IN_SECONDS));
    if (response.statusCode != 200) {
      return 'ARTIST NAME';
    }
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse.entries);
    Map<dynamic, dynamic> data = Map();
    data.addAll(decodedResponse);
    //print(data.entries);

    //print(data['imageUrl']);
    return data['name'];
  }
} //auth


