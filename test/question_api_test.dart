import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:spotiquiz/models/question_model.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/services/questionApi.dart';

//import 'package:test/expect.dart';
//import 'package:test/test.dart';

void cannotBeNull(dynamic param) {
  assert(param != null);
}

class MockHttpClient extends Mock implements http.Client {}

class MocksAPI extends Mock implements API {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final MocksAPI mocksAPI = MocksAPI();
  MockHttpClient mockHttpClient = MockHttpClient();
  registerFallbackValue(mockHttpClient);
  final QuestionAPI qApi = QuestionAPI.test(a: mocksAPI);
  when(() => mocksAPI.getRandomSongFromLibraryJSON(any())).thenAnswer((invocation) => Future.value({
        'album': {
          'name': 'disco1',
          'release_date': '1981-10',
          'artists': [
            {'id': 'a', 'name': 'asso'}
          ]
        },
        'name': 'song1',
        'preview_url': 'https://ciaone.com',
      }));
  when(() => mocksAPI.getRelatedArtists(any(), any())).thenAnswer((invocation) => Future.value(['asso', 'nonno', 'mela', 'caso']));
  when(() => mocksAPI.getRandomAlbumsFromArtist(any(), any())).thenAnswer((invocation) => Future.value(['disco1', 'disco2', 'disco3', 'disco4']));
  when(() => mocksAPI.getRandomTracksFromArtist(any(), any())).thenAnswer((invocation) => Future.value(['song1', 'song2', 'song3', 'song4']));
  when(() => mocksAPI.getRandomYears(any())).thenAnswer((invocation) => [1981, 1987, 2000, 1990]);
  test('generate author of song', (() async {
    var res = await qApi.generateRandomQuestion_AuthorOfSong(mockHttpClient);
    expect(res, isA<QuestionModel>());
    expect(res.correctAnswer, 0);
  }));
  test('generate album of song', (() async {
    var res = await qApi.generateRandomQuestion_AlbumOfSong(mockHttpClient);
    expect(res, isA<QuestionModel>());
    expect(res.correctAnswer, 0);
  }));

  test('generate song to listen', (() async {
    var res = await qApi.generateRandomQuestion_SongToListen(mockHttpClient);
    expect(res, isA<QuestionModel>());
    expect(res.correctAnswer, 0);
  }));

  test('generate album to listen', (() async {
    var res = await qApi.generateRandomQuestion_AlbumToListen(mockHttpClient);
    expect(res, isA<QuestionModel>());
    expect(res.correctAnswer, 0);
  }));

  test('generate author to listen', (() async {
    var res = await qApi.generateRandomQuestion_AuthorToListen(mockHttpClient);
    expect(res, isA<QuestionModel>());
    expect(res.correctAnswer, 0);
  }));
  test('generate year', (() async {
    var res = await qApi.generateRandomQuestion_YearOfSong(mockHttpClient);
    expect(res, isA<QuestionModel>());
    assert(res.correctAnswer == 0 || res.correctAnswer == 1);
  }));
  test('generate non listening question', (() async {
    var res = await qApi.generateNonListeningQuestion(mockHttpClient);
    expect(res, isA<QuestionModel>());
    assert(res.songURL == null);
  }));
  test('generate listening question', (() async {
    var res = await qApi.generateListeningQuestion(mockHttpClient);
    expect(res, isA<QuestionModel>());
    assert(res.songURL != null);
  }));
  test('generate listening questions', (() async {
    var res = await qApi.generateListeningQuestions(mockHttpClient, 10);
    expect(res, isA<List<Future<QuestionModel>>>());
    assert(res.length == 10);
  }));
  test('generate non listening questions', (() async {
    var res = await qApi.generateNonListeningQuestions(mockHttpClient, 10);
    expect(res, isA<List<Future<QuestionModel>>>());
    assert(res.length == 10);
  }));
}
