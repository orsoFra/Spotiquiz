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

import 'api_test.mocks.dart';
//import 'package:test/expect.dart';
//import 'package:test/test.dart';

void cannotBeNull(dynamic param) {
  assert(param != null);
}

class MockStorage extends Mock implements IStorage {}

class MocksAPI extends Mock implements API {}

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
      expect(api.getInfoTrackJSON('11dFghVXANMlKmJXsNCbNl', mockHTTPClient), isA<Future<Map<String, dynamic>>>());
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
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(1));
    });
  });

  group('test gerRandomTracksFromArtist', () {
    test('expect a list of strings', () {
      //sadly necessary for testing
      final response = {
        "tracks": {
          "href": "https://api.spotify.com/v1/search?query=artist%3A+Pink+Floyd&type=track&offset=0&limit=4",
          "items": [
            {
              "album": {
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
                "external_urls": {"spotify": "https://open.spotify.com/album/7wzStEU2keGohEu8jpVMZW"},
                "href": "https://api.spotify.com/v1/albums/7wzStEU2keGohEu8jpVMZW",
                "id": "7wzStEU2keGohEu8jpVMZW",
                "images": [
                  {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b273d067828a6bcc3c1c9fa5f43f", "width": 640},
                  {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e02d067828a6bcc3c1c9fa5f43f", "width": 300},
                  {"height": 64, "url": "https://i.scdn.co/image/ab67616d00004851d067828a6bcc3c1c9fa5f43f", "width": 64}
                ],
                "name": "The Division Bell (2011 Remastered Version)",
                "release_date": "1994-03-28",
                "release_date_precision": "day",
                "total_tracks": 11,
                "type": "album",
                "uri": "spotify:album:7wzStEU2keGohEu8jpVMZW"
              },
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
              "disc_number": 1,
              "duration_ms": 329360,
              "explicit": false,
              "external_ids": {"isrc": "GBN9X1100015"},
              "external_urls": {"spotify": "https://open.spotify.com/track/5kLg9cdm7LayfkyaxVZKdD"},
              "href": "https://api.spotify.com/v1/tracks/5kLg9cdm7LayfkyaxVZKdD",
              "id": "5kLg9cdm7LayfkyaxVZKdD",
              "is_local": false,
              "name": "Marooned - 2011 Remaster",
              "popularity": 51,
              "preview_url": "https://p.scdn.co/mp3-preview/16806a286e2861eb12821d5aceef8922e701f849?cid=36169bfc58ce451a88a245063a4638c5",
              "track_number": 4,
              "type": "track",
              "uri": "spotify:track:5kLg9cdm7LayfkyaxVZKdD"
            },
            {
              "album": {
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
                "external_urls": {"spotify": "https://open.spotify.com/album/21jUB9RqplD6OqtsTjKBnO"},
                "href": "https://api.spotify.com/v1/albums/21jUB9RqplD6OqtsTjKBnO",
                "id": "21jUB9RqplD6OqtsTjKBnO",
                "images": [
                  {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b2731a0e01b6cd607bbc41c3ff4b", "width": 640},
                  {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e021a0e01b6cd607bbc41c3ff4b", "width": 300},
                  {"height": 64, "url": "https://i.scdn.co/image/ab67616d000048511a0e01b6cd607bbc41c3ff4b", "width": 64}
                ],
                "name": "Animals (2011 Remastered Version)",
                "release_date": "1977-01-21",
                "release_date_precision": "day",
                "total_tracks": 5,
                "type": "album",
                "uri": "spotify:album:21jUB9RqplD6OqtsTjKBnO"
              },
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
              "disc_number": 1,
              "duration_ms": 686346,
              "explicit": true,
              "external_ids": {"isrc": "GBN9Y1100092"},
              "external_urls": {"spotify": "https://open.spotify.com/track/23dTQ4fjLrPPbYHamkJDzo"},
              "href": "https://api.spotify.com/v1/tracks/23dTQ4fjLrPPbYHamkJDzo",
              "id": "23dTQ4fjLrPPbYHamkJDzo",
              "is_local": false,
              "name": "Pigs (Three Different Ones) - 2011 Remaster",
              "popularity": 52,
              "preview_url": "https://p.scdn.co/mp3-preview/c1e517d1020353541ee40f72c45a360f59f2cfe4?cid=36169bfc58ce451a88a245063a4638c5",
              "track_number": 3,
              "type": "track",
              "uri": "spotify:track:23dTQ4fjLrPPbYHamkJDzo"
            },
            {
              "album": {
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
              "disc_number": 1,
              "duration_ms": 228586,
              "explicit": false,
              "external_ids": {"isrc": "GBN9Y1100099"},
              "external_urls": {"spotify": "https://open.spotify.com/track/7rPzEczIS574IgPaiPieS3"},
              "href": "https://api.spotify.com/v1/tracks/7rPzEczIS574IgPaiPieS3",
              "id": "7rPzEczIS574IgPaiPieS3",
              "is_local": false,
              "name": "Another Brick In The Wall, Pt. 2 - 2011 Remastered Version",
              "popularity": 71,
              "preview_url": "https://p.scdn.co/mp3-preview/136a755233226b369b9d123f08fe77ce7af0a60d?cid=36169bfc58ce451a88a245063a4638c5",
              "track_number": 5,
              "type": "track",
              "uri": "spotify:track:7rPzEczIS574IgPaiPieS3"
            },
            {
              "album": {
                "album_type": "compilation",
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
                "external_urls": {"spotify": "https://open.spotify.com/album/15Tc3f1XzDKLodDXDELISe"},
                "href": "https://api.spotify.com/v1/albums/15Tc3f1XzDKLodDXDELISe",
                "id": "15Tc3f1XzDKLodDXDELISe",
                "images": [
                  {"height": 640, "url": "https://i.scdn.co/image/ab67616d0000b273b3ca136e83344321ebd3de01", "width": 640},
                  {"height": 300, "url": "https://i.scdn.co/image/ab67616d00001e02b3ca136e83344321ebd3de01", "width": 300},
                  {"height": 64, "url": "https://i.scdn.co/image/ab67616d00004851b3ca136e83344321ebd3de01", "width": 64}
                ],
                "name": "A Collection Of Great Dance Songs",
                "release_date": "1981-11-01",
                "release_date_precision": "day",
                "total_tracks": 6,
                "type": "album",
                "uri": "spotify:album:15Tc3f1XzDKLodDXDELISe"
              },
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
              "disc_number": 1,
              "duration_ms": 321080,
              "explicit": false,
              "external_ids": {"isrc": "GBDJQ0100008"},
              "external_urls": {"spotify": "https://open.spotify.com/track/1HzDhHApjdjXPLHF6GGYhu"},
              "href": "https://api.spotify.com/v1/tracks/1HzDhHApjdjXPLHF6GGYhu",
              "id": "1HzDhHApjdjXPLHF6GGYhu",
              "is_local": false,
              "name": "Wish You Were Here",
              "popularity": 68,
              "preview_url": "https://p.scdn.co/mp3-preview/e26e8dce7ef4bcb955ee0b1b4c8316f2daa3b942?cid=36169bfc58ce451a88a245063a4638c5",
              "track_number": 5,
              "type": "track",
              "uri": "spotify:track:1HzDhHApjdjXPLHF6GGYhu"
            }
          ],
          "limit": 4,
          "next": "https://api.spotify.com/v1/search?query=artist%3A+Pink+Floyd&type=track&offset=4&limit=4",
          "offset": 0,
          "previous": null,
          "total": 2141
        }
      };
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 200);
      });
      expect(api.getRandomTracksFromArtist('Pink Floyd', mockHTTPClient), isA<Future<List<String>>>());
      verify(() => mockStorage.read(key: 'access_token')).called(1);
    });

    test('expect error from getRandomTracksFromArtist', () async {
      final response = {'error': 'Bad request!'};
      final mockHTTPClient = MockClient((request) async {
        // Create sample response of the HTTP call //
        return Response(jsonEncode(response), 401);
      });
      expect(api.getRandomTracksFromArtist('Pink Floyd', mockHTTPClient), throwsA(isA<Exception>()));
      verify(() => mockStorage.read(key: 'access_token')).called(greaterThan(0));
    });
  });
  test('Get Offset >=0', () {
    when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('response'));
    final off = api.getOffset();
    expect(off, isA<Future<int>>());
    assert(off != null);
  });

  test('Get Try token is a bool', () {
    when(() => mockStorage.read(key: 'access_token')).thenAnswer((invocation) => Future.value('response'));
    final off = api.tryToken();
    expect(off, isA<Future<bool>>());
    assert(off != null);
  });

  group('test gerRandomAlbumsFromArtist', () {
    test('expect a list of strings', () {
      //sadly necessary for testing
      final response = {
        "albums": {
          "href": "https://api.spotify.com/v1/search?query=artist%3A+Pink+Floyd&type=album&offset=0&limit=4",
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
        }
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
    test('expect a LIST of strings, from getTempoList', () async {
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
    });
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
}
