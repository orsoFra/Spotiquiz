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

  Future<QuestionModel> generateRandomQuestion(http.Client http) async {
    var questionGenerators = [
      generateRandomQuestion_AuthorOfSong,
      generateRandomQuestion_AlbumOfSong,
      generateRandomQuestion_SongToListen,
      generateRandomQuestion_AlbumToListen,
      generateRandomQuestion_AuthorToListen,
      generateRandomQuestion_YearOfSong
    ];
    int chosenGenerator = Random().nextInt(questionGenerators.length);
    var questionGenerator = questionGenerators[chosenGenerator];
    Future<QuestionModel> futureQuestion = questionGenerator(http);
    QuestionModel question = await futureQuestion;
    return futureQuestion;
  }

  List<Future<QuestionModel>> generateRandomQuestions(http.Client http, int numQuestions) {
    List<Future<QuestionModel>> questions = [];
    for (int i = 0; i < numQuestions; i++) {
      Future<QuestionModel> futureQuestion = generateRandomQuestion(http);
      questions.add(futureQuestion);
    }
    return questions;
  }

  Future<QuestionModel> generateRandomQuestion_AuthorOfSong(http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    // TODO: this raises an exception sometimes
    String correct_answer = song['album']['artists'][0]['name'];
    String idArtist = song['album']['artists'][0]['id'];
    List<String> options = await api.getRelatedArtists(idArtist, http);
    if (!options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) > 3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);

    QuestionModel questionModel = QuestionModel('Who is the author of the song \'${song["name"]}\'?', [options[0], options[1], options[2], options[3]], ind);

    // TODO: mischiare risposte (quindi cambiare correctAnswer di conseguenza)
    // prima salvo risposta corretta, poi metto tutto in lista, faccio shuffle e poi faccio search di quella corretta
    //print(options);
    // TODO: fare altri tipi di domande
    return questionModel;
  }

  Future<QuestionModel> generateRandomQuestion_AlbumOfSong(http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    String correct_answer = song['album']['name'];
    String artist = song['album']['artists'][0]['id'];
    List<String> options = await api.getRandomAlbumsFromArtist(artist, http);
    //print(options);
    if (!options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) > 3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);
    QuestionModel questionModel = QuestionModel('Which is the album of the song \'${song["name"]}\'?', [options[0], options[1], options[2], options[3]], ind);
    return questionModel;
  }

  //generate a song and get the url
  Future<QuestionModel> generateRandomQuestion_SongToListen(http.Client http) async {
    // TODO: sometimes answers are duplicated
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    String correct_answer = song['name'];
    String URL = song['preview_url'];
    String artist = song['album']['artists'][0]['name'];
    List<String> options = await api.getRandomTracksFromArtist(artist, http);
    if (!options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) > 3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);
    QuestionModel questionModel = QuestionModel('Which song did you listen?', [options[0], options[1], options[2], options[3]], ind, URL);
    return questionModel;
  }

  Future<QuestionModel> generateRandomQuestion_AlbumToListen(http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    String correct_answer = song['album']['name'];
    String URL = song['preview_url'];
    String artist = song['album']['artists'][0]['id'];
    List<String> options = await api.getRandomAlbumsFromArtist(artist, http);
    if (!options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) > 3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);
    QuestionModel questionModel = QuestionModel('To which album does this song belong?', [options[0], options[1], options[2], options[3]], ind, URL);
    return questionModel;
  }

  Future<QuestionModel> generateRandomQuestion_AuthorToListen(http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    String correct_answer = song['album']['artists'][0]['name'];
    String artist = song['album']['artists'][0]['id'];
    List<String> options = await api.getRelatedArtists(artist, http);
    String URL = song['preview_url'];
    if (!options.contains(correct_answer)) //if there is not the correct answer
      options.add(correct_answer); // add it
    while (options.indexOf(correct_answer) > 3) //if the answer is not in the first four
      options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correct_answer);

    QuestionModel questionModel = QuestionModel('Who is the author of this song ?', [options[0], options[1], options[2], options[3]], ind, URL);

    // TODO: mischiare risposte (quindi cambiare correctAnswer di conseguenza)
    // prima salvo risposta corretta, poi metto tutto in lista, faccio shuffle e poi faccio search di quella corretta
    //print(options);
    // TODO: fare altri tipi di domande
    return questionModel;
  }

  Future<QuestionModel> generateRandomQuestion_YearOfSong(http.Client http) async {
    Map<dynamic, dynamic> song = await api.getRandomSongFromLibraryJSON(http);
    int correctYear = int.parse(song['album']['release_date'].toString().substring(0, 4));
    List<int> options = api.getRandomYears(correctYear);
    options.insert(0, correctYear);
    options.shuffle(); //shuffle the answers
    int ind = options.indexOf(correctYear);

    QuestionModel questionModel = QuestionModel(
        'In which year the song \'${song["name"]}\' was released?', [options[0].toString(), options[1].toString(), options[2].toString(), options[3].toString()], ind);
    return questionModel;
  }
}
