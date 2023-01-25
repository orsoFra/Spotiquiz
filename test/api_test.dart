import 'dart:convert';
//import 'dart:html';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'package:http/http.dart' as http;

import 'api_test.mocks.dart';
//import 'package:test/expect.dart';
//import 'package:test/test.dart';

void cannotBeNull(dynamic param) {
  assert(param != null);
}

class MockStorage extends Mock implements IStorage {}

class MocksAPI extends Mock implements API {}

class MockClientHTTP extends Mock implements http.Client {}

@GenerateMocks([FlutterSecureStorage])
@GenerateMocks([API])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockStorage = MockStorage();
  final api = API(mockStorage);
  when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('response'));
  group('test getFeaturesTrack', () {
    test('expect a map as answer', () async {
      final response = {
        "danceability": 0.696,
        "energy": 0.905,
        "key": 2,
        "loudness": -2.743,
        "mode": 1,
        "speechiness": 0.103,
        "acousticness": 0.0110,
        "instrumentalness": 0.000905,
        "liveness": 0.302,
        "valence": 0.625,
        "tempo": 114.944,
        "type": "audio_features",
        "id": "11dFghVXANMlKmJXsNCbNl",
        "uri": "spotify:track:11dFghVXANMlKmJXsNCbNl",
        "track_href": "https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl",
        "analysis_url": "https://api.spotify.com/v1/audio-analysis/11dFghVXANMlKmJXsNCbNl",
        "duration_ms": 207960,
        "time_signature": 4
      };
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });
      expect(api.getFeaturesTrack('11dFghVXANMlKmJXsNCbNl', mockHTTPClient), isA<Future<Map<String, dynamic>>>());
      //verify(() => mockStorage.read(key: 'access_token')).called(1);
    });
    test('expect error', () async {
      final response = {'error': 'Bad request!'};
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 401);
      });
      expect(api.getFeaturesTrack('11dFghVXANMlKmJXsNCbNl', mockHTTPClient), throwsA(isA<Exception>()));
      //verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });
  });
  group('test getInfoTrack', () {
    test('expect a map as answer', () async {
      final response = {
        "album": {
          "album_type": "single",
          "artists": [
            {
              "external_urls": {"spotify": "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"},
              "href": "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
              "id": "6sFIWsNpZYqfjUpaCgueju",
              "name": "Carly Rae Jepsen",
              "type": "artist",
              "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
            }
          ],
          "available_markets": [],
          "external_urls": {"spotify": "https://open.spotify.com/album/0tGPJ0bkWOUmH7MEOR77qc"},
          "href": "https://api.spotify.com/v1/albums/0tGPJ0bkWOUmH7MEOR77qc",
          "id": "0tGPJ0bkWOUmH7MEOR77qc",
          "images": [
            {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b2737359994525d219f64872d3b1", "width": 640},
            {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e027359994525d219f64872d3b1", "width": 300},
            {"height": 64, "url": "https://i.scdn.co/image/ab67616d000048517359994525d219f64872d3b1", "width": 64}
          ],
          "name": "Cut To The Feeling",
          "release_date": "2017-05-26",
          "release_date_precision": "day",
          "total_tracks": 1,
          "type": "album",
          "uri": "spotify:album:0tGPJ0bkWOUmH7MEOR77qc"
        },
        "artists": [
          {
            "external_urls": {"spotify": "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"},
            "href": "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
            "id": "6sFIWsNpZYqfjUpaCgueju",
            "name": "Carly Rae Jepsen",
            "type": "artist",
            "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
          }
        ],
        "available_markets": [],
        "disc_number": 1,
        "duration_ms": 207959,
        "explicit": false,
        "external_ids": {"isrc": "USUM71703861"},
        "external_urls": {"spotify": "https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl"},
        "href": "https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl",
        "id": "11dFghVXANMlKmJXsNCbNl",
        "is_local": false,
        "name": "Cut To The Feeling",
        "popularity": 0,
        "preview_url": null,
        "track_number": 1,
        "type": "track",
        "uri": "spotify:track:11dFghVXANMlKmJXsNCbNl"
      };
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });

      when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('response'));
      expect(api.getInfoTrackJSON('11dFghVXANMlKmJXsNCbNl', mockHTTPClient), isA<Future<Map<dynamic, dynamic>>>());
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });

    test('expect error', () async {
      final response = {'error': 'Bad request!'};
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 401);
      });
      when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('response'));
      expect(api.getInfoTrackJSON('11dFghVXANMlKmJXsNCbNl', mockHTTPClient), throwsA(isA<Exception>()));
      verify(() => mockStorage.read(key: 'access_token')).called(1);
    });
  });

  group('test gerRandomTracksFromArtist', () {
    test('expect a list of strings', () async {
      //sadly necessary for testing
      final response = {
        'tracks': [
          {
            'album': {
              'name': 'disco1',
              'release_date': '1981-10',
              'artists': [
                {'id': 'a', 'name': 'asso'}
              ]
            },
            'name': 'song1',
            'preview_url': 'https://ciaone.com',
          }
        ]
      };
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });
      expect(await api.getRandomTracksFromArtist('asso', mockHTTPClient), isA<List<String>>());
      verify(() => mockStorage.read(key: 'access_token')).called(1);
    });

    test('expect error from getRandomTracksFromArtist', () async {
      final response = {'error': 'Bad request!'};
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 401);
      });
      expect(() async => await api.getRandomTracksFromArtist('asd', mockHTTPClient), throwsException);
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });
  });

  test('Get Try token is a bool', () {
    when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('response'));
    final off = api.tryToken();
    expect(off, isA<Future<bool>>());
    assert(off != null);
  });

  group('test gerRandomAlbumsFromArtist', () {
    test('expect a list of strings', () async {
      //sadly necessary for testing
      final response = {
        "items": [
          {
            "album_type": "album",
            "artists": [
              {
                "external_urls": {"spotify": "https://open.spotify.com/artist/0k17h0D3J5VfsdmQ1iZtE9"},
                "href": "https://api.spotify.com/v1/artists/0k17h0D3J5VfsdmQ1iZtE9",
                "id": "0k17h0D3J5VfsdmQ1iZtE9",
                "name": "Pink Floyd",
                "type": "artist",
                "uri": "spotify:artist:0k17h0D3J5VfsdmQ1iZtE9"
              }
            ],
            "available_markets": [],
            "external_urls": {"spotify": "https://open.spotify.com/album/7yKRvvqspSxfLkr7C7RaAI"},
            "href": "https://api.spotify.com/v1/albums/7yKRvvqspSxfLkr7C7RaAI",
            "id": "7yKRvvqspSxfLkr7C7RaAI",
            "images": [
              {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b273fbe325d2c4cdff1416bd31ca", "width": 640},
              {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e02fbe325d2c4cdff1416bd31ca", "width": 300},
              {"height": 64, "url": "https://i.scdn.co/image/ab67616d00004851fbe325d2c4cdff1416bd31ca", "width": 64}
            ],
            "name": "Meddle (2011 Remastered Version)",
            "release_date": "1971-11-05",
            "release_date_precision": "day",
            "total_tracks": 6,
            "type": "album",
            "uri": "spotify:album:7yKRvvqspSxfLkr7C7RaAI"
          },
          {
            "album_type": "album",
            "artists": [
              {
                "external_urls": {"spotify": "https://open.spotify.com/artist/0k17h0D3J5VfsdmQ1iZtE9"},
                "href": "https://api.spotify.com/v1/artists/0k17h0D3J5VfsdmQ1iZtE9",
                "id": "0k17h0D3J5VfsdmQ1iZtE9",
                "name": "Pink Floyd",
                "type": "artist",
                "uri": "spotify:artist:0k17h0D3J5VfsdmQ1iZtE9"
              }
            ],
            "available_markets": [],
            "external_urls": {"spotify": "https://open.spotify.com/album/2WT1pbYjLJciAR26yMebkH"},
            "href": "https://api.spotify.com/v1/albums/2WT1pbYjLJciAR26yMebkH",
            "id": "2WT1pbYjLJciAR26yMebkH",
            "images": [
              {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b273d3709135d1005baa36939d80", "width": 640},
              {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e02d3709135d1005baa36939d80", "width": 300},
              {"height": 64, "url": "https://i.scdn.co/image/ab67616d00004851d3709135d1005baa36939d80", "width": 64}
            ],
            "name": "The Dark Side Of The Moon (2011 Remastered Version)",
            "release_date": "1973-03-01",
            "release_date_precision": "day",
            "total_tracks": 10,
            "type": "album",
            "uri": "spotify:album:2WT1pbYjLJciAR26yMebkH"
          },
          {
            "album_type": "album",
            "artists": [
              {
                "external_urls": {"spotify": "https://open.spotify.com/artist/0k17h0D3J5VfsdmQ1iZtE9"},
                "href": "https://api.spotify.com/v1/artists/0k17h0D3J5VfsdmQ1iZtE9",
                "id": "0k17h0D3J5VfsdmQ1iZtE9",
                "name": "Pink Floyd",
                "type": "artist",
                "uri": "spotify:artist:0k17h0D3J5VfsdmQ1iZtE9"
              }
            ],
            "available_markets": [],
            "external_urls": {"spotify": "https://open.spotify.com/album/6WaIQHxEHtZL0RZ62AuY0g"},
            "href": "https://api.spotify.com/v1/albums/6WaIQHxEHtZL0RZ62AuY0g",
            "id": "6WaIQHxEHtZL0RZ62AuY0g",
            "images": [
              {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b273f34e8811de255b34c56301d8", "width": 640},
              {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e02f34e8811de255b34c56301d8", "width": 300},
              {"height": 64, "url": "https://i.scdn.co/image/ab67616d00004851f34e8811de255b34c56301d8", "width": 64}
            ],
            "name": "The Wall (Remastered)",
            "release_date": "1979-11-30",
            "release_date_precision": "day",
            "total_tracks": 26,
            "type": "album",
            "uri": "spotify:album:6WaIQHxEHtZL0RZ62AuY0g"
          },
          {
            "album_type": "album",
            "artists": [
              {
                "external_urls": {"spotify": "https://open.spotify.com/artist/0k17h0D3J5VfsdmQ1iZtE9"},
                "href": "https://api.spotify.com/v1/artists/0k17h0D3J5VfsdmQ1iZtE9",
                "id": "0k17h0D3J5VfsdmQ1iZtE9",
                "name": "Pink Floyd",
                "type": "artist",
                "uri": "spotify:artist:0k17h0D3J5VfsdmQ1iZtE9"
              }
            ],
            "available_markets": [],
            "external_urls": {"spotify": "https://open.spotify.com/album/7iLuEbxvxepyHp4yfVfiut"},
            "href": "https://api.spotify.com/v1/albums/7iLuEbxvxepyHp4yfVfiut",
            "id": "7iLuEbxvxepyHp4yfVfiut",
            "images": [
              {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b27369f4b7cda08f4ed73cc20474", "width": 640},
              {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e0269f4b7cda08f4ed73cc20474", "width": 300},
              {"height": 64, "url": "https://i.scdn.co/image/ab67616d0000485169f4b7cda08f4ed73cc20474", "width": 64}
            ],
            "name": "Pulse",
            "release_date": "1995",
            "release_date_precision": "year",
            "total_tracks": 24,
            "type": "album",
            "uri": "spotify:album:7iLuEbxvxepyHp4yfVfiut"
          }
        ],
        "limit": 4,
        "next": "https://api.spotify.com/v1/search?query=artist%3A+Pink+Floyd&type=album&offset=4&limit=4",
        "offset": 0,
        "previous": null,
        "total": 1131
      };
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });
      expect(api.getRandomAlbumsFromArtist('Pink Floyd', mockHTTPClient), isA<Future<List<String>>>());
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });

    test('expect error from getRandomAlbumsFromArtist', () async {
      final response = {'error': 'Bad request!'};
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 401);
      });
      expect(api.getRandomAlbumsFromArtist('Pink Floyd', mockHTTPClient), throwsA(isA<Exception>()));
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });
  });
  group('test get info user', () {
    test('expect a map for info', () {
      final response = {
        "country": "IT",
        "display_name": "Francesco Corso",
        "email": "kekkocorso_99@yahoo.it",
        "explicit_content": {"filter_enabled": false, "filter_locked": false},
        "external_urls": {"spotify": "https://open.spotify.com/user/21q4wwalokcky25op74guvjcq"},
        "followers": {"href": null, "total": 12},
        "href": "https://api.spotify.com/v1/users/21q4wwalokcky25op74guvjcq",
        "id": "21q4wwalokcky25op74guvjcq",
        "images": [
          {"height": null, "url": "https://i.scdn.co/image/ab6775700000ee852d784ac19cbb64f0c974d697", "width": null}
        ],
        "product": "premium",
        "type": "user",
        "uri": "spotify:user:21q4wwalokcky25op74guvjcq"
      };
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });
      expect(api.getInfoUser(mockHTTPClient), isA<Future<Map<String, dynamic>>>());
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });
    test('expect exception', () {
      final response = {'error': 'Bad request!'};
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 401);
      });
      expect(api.getInfoUser(mockHTTPClient), throwsA(isA<Exception>()));
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });
  });

  group('test all single audio features', () {
    /*test('expect a LIST of strings, from getTempoList', () async {
      final responseBody = {
        "audio_features": [
          {
            "danceability": 0.366,
            "energy": 0.963,
            "key": 11,
            "loudness": -5.301,
            "mode": 0,
            "speechiness": 0.142,
            "acousticness": 0.000273,
            "instrumentalness": 0.0122,
            "liveness": 0.115,
            "valence": 0.211,
            "tempo": 137.114,
            "type": "audio_features",
            "id": "7ouMYWpwJ422jRcDASZB7P",
            "uri": "spotify:track:7ouMYWpwJ422jRcDASZB7P",
            "track_href": "https://api.spotify.com/v1/tracks/7ouMYWpwJ422jRcDASZB7P",
            "analysis_url": "https://api.spotify.com/v1/audio-analysis/7ouMYWpwJ422jRcDASZB7P",
            "duration_ms": 366213,
            "time_signature": 4
          }
        ]
      };
      final Response response = Response(jsonEncode(responseBody), 200);
      final mAPI = MocksAPI();
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(responseBody), 200);
      });
      Map<dynamic, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      ;
      when(() => mAPI.getFeaturesTrack('7ouMYWpwJ422jRcDASZB7P', mockHTTPClient)).thenAnswer((data) => Future.value());
      expect(await api.getTempoList('7ouMYWpwJ422jRcDASZB7P', mockHTTPClient), isA<Future<List<String>>>());
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
      verify(() => mAPI.getFeaturesTrack(any(), any())).called(greaterThan(0));
    });*/
    test('expect a LIST of strings, from getKeysList', () {
      final response = {
        "audio_features": [
          {
            "danceability": 0.366,
            "energy": 0.963,
            "key": 11,
            "loudness": -5.301,
            "mode": 0,
            "speechiness": 0.142,
            "acousticness": 0.000273,
            "instrumentalness": 0.0122,
            "liveness": 0.115,
            "valence": 0.211,
            "tempo": 137.114,
            "type": "audio_features",
            "id": "7ouMYWpwJ422jRcDASZB7P",
            "uri": "spotify:track:7ouMYWpwJ422jRcDASZB7P",
            "track_href": "https://api.spotify.com/v1/tracks/7ouMYWpwJ422jRcDASZB7P",
            "analysis_url": "https://api.spotify.com/v1/audio-analysis/7ouMYWpwJ422jRcDASZB7P",
            "duration_ms": 366213,
            "time_signature": 4
          }
        ]
      };

      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });

      expect(api.getKeysList('7ouMYWpwJ422jRcDASZB7P', mockHTTPClient), isA<Future<List<String>>>());
    });
  });

  test('test get user id', () async {
    final response = {'id': 'alfa'};
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getIdUser(mockHTTPClient), isA<Future<String>>());
    var res = await api.getIdUser(mockHTTPClient);
    expect(res, 'alfa');
  });

  test('test get similar artists', () async {
    final response = {
      'artists': [
        {'name': 'uno'},
        {'name': 'due'},
        {'name': 'tre'},
        {'name': 'quattro'}
      ]
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getRelatedArtists('ideasd', mockHTTPClient), isA<Future<List<String>>>());
    List<String> res = await api.getRelatedArtists('ideasd', mockHTTPClient);
    expect(res[0], 'uno');
    expect(res[1], 'due');
  });
  test('test get similar artists error', () async {
    final response = {
      'artists': [
        {'name': 'uno'},
      ]
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getRelatedArtists('ideasd', mockHTTPClient), isA<Future<List<String>>>());
    List<String> res = await api.getRelatedArtists('ideasd', mockHTTPClient);
    expect(res[0], 'uno');
    expect(res[1], '');
  });

  test('test get similar artists error', () async {
    final response = {
      'artists': [
        {'name': 'uno'},
      ]
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getRelatedArtists('ideasd', mockHTTPClient), isA<Future<List<String>>>());
    List<int> res = await api.getRandomYears(2000);
    assert(res[0] < 2030 && res[0] > 1970);
  });

  test('test get info user', () async {
    final response = {
      'display_name': 'ciao',
      'images': [
        {'url': 'asd'}
      ]
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getInfoOfUser(mockHTTPClient, 'ideasd'), isA<Future<Map<String, dynamic>>>());
    var res = await api.getInfoOfUser(mockHTTPClient, 'ideasd');
    expect(res['display_name'], 'ciao');
  });

  test('test get name of user', () async {
    final response = {
      'display_name': 'ciao',
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getNameOfUser(mockHTTPClient, 'ideasd'), isA<Future<String>>());
    var res = await api.getNameOfUser(mockHTTPClient, 'ideasd');
    expect(res, 'ciao');
  });
  test('test get name of user error', () async {
    final response = {
      'display_name': 'ciao',
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 400);
    });
    expect(api.getNameOfUser(mockHTTPClient, 'ideasd'), isA<Future<String>>());
    var res = await api.getNameOfUser(mockHTTPClient, 'ideasd');
    expect(res, 'NO USERNAME');
  });

  test('test get name of artist', () async {
    final response = {
      'name': 'ciao',
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    expect(api.getNameOfArtist(mockHTTPClient, 'ideasd'), isA<Future<String>>());
    var res = await api.getNameOfArtist(mockHTTPClient, 'ideasd');
    expect(res, 'ciao');
  });
  test('test get name of artist error', () async {
    final response = {
      'name': 'ciao',
    };
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 400);
    });
    expect(api.getNameOfArtist(mockHTTPClient, 'ideasd'), isA<Future<String>>());
    var res = await api.getNameOfArtist(mockHTTPClient, 'ideasd');
    expect(res, 'ARTIST NAME');
  });
/*
  test('get random song from library', () async {
    final response = {
      'items': [
        {
          'track': {'preview_url': 'asd', 'id': 'qwerty'}
        }
      ],
      'total': 1,
    };
    final MockClientHTTP mockHTTP = MockClientHTTP();
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });
    when((() => mockHTTP.get(Uri.https('api.spotify.com', '/v1/me/tracks/'), headers: any(named: 'headers')))).thenAnswer((_) => Future.value(Response(jsonEncode(response), 200)));
    when((() => mockHTTP.get(Uri.https('api.spotify.com', '/v1/tracks/' + 'qwerty'), headers: any(named: 'headers'))))
        .thenAnswer((_) => Future.value(Response(jsonEncode(response), 200)));
    expect(api.getRandomSongFromLibraryJSON(mockHTTP), isA<Future<Map<dynamic, dynamic>>>());
    var res = await api.getRandomSongFromLibraryJSON(mockHTTP);
  });*/
}
