import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api.dart';
import '../models/MyStorage.dart';
import '../models/question_model.dart';

final sStorage = FlutterSecureStorage();
final storage = MyStorage(sStorage);

class QuestionAPI {
  final api = API(storage);
  Future<QuestionModel> generateRandomQuestion_AuthorOfSong(
      http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);

    QuestionModel questionModel = QuestionModel(
        'Who is the author of the song \'${song["name"]}\'?',
        [song["artists"][0]["name"], "Pippo", "Pluto", "Fefi"],
        0);

    // TODO: mischiare risposte (quindi cambiare correctAnswer di conseguenza)
    // prima salvo risposta corretta, poi metto tutto in lista, faccio shuffle e poi faccio search di quella corretta

    // TODO: fare altri tipi di domande
    return questionModel;
  }

  Future<QuestionModel> generateRandomQuestion_AlbumOfSong(
      http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    String correct_answer = song['album']['name'];
    String artist = song['album']['artists'][0]['id'];
    List<String> options = await api.getRandomAlbumsFromArtist(artist, http);
    //print(options);
    if (options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) >
        3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);
    QuestionModel questionModel = QuestionModel(
        'Which is the album of the song \'${song["name"]}\'?',
        [options[0], options[1], options[2], options[3]],
        ind);
    return questionModel;
  }

  Future<QuestionModel> generateRandomQuestion_SongToListen(
      http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    String correct_answer = song['name'];
    String URL = song['preview_url'];
    String artist = song['album']['artists'][0]['name'];
    List<String> options = await api.getRandomTracksFromArtist(artist, http);
    if (options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) >
        3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);
    QuestionModel questionModel = QuestionModel('Which song did you listen?',
        [options[0], options[1], options[2], options[3]], ind, URL);
    return questionModel;
  }
}
