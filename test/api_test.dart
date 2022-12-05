import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mockito/mockito.dart' as mockito;
//import 'package:test/expect.dart';
//import 'package:test/test.dart';

void cannotBeNull(dynamic param) {
  assert(param != null);
}

class MockStorage extends Mock implements IStorage {}

@GenerateMocks([FlutterSecureStorage])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockStorage = MockStorage();
  final api = API(mockStorage);

  group('test getInfoTrack', () {
    test('expect a map as answer', () async {
      final response = {
        "album": {
          "album_type": "single",
          "artists": [
            {
              "external_urls": {
                "spotify":
                    "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"
              },
              "href":
                  "https://api.spotify.com/v1/artists/6sFIWsNpZYqfjUpaCgueju",
              "id": "6sFIWsNpZYqfjUpaCgueju",
              "name": "Carly Rae Jepsen",
              "type": "artist",
              "uri": "spotify:artist:6sFIWsNpZYqfjUpaCgueju"
            }
          ],
          "available_markets": [],
          "external_urls": {
            "spotify": "https://open.spotify.com/album/0tGPJ0bkWOUmH7MEOR77qc"
          },
          "href": "https://api.spotify.com/v1/albums/0tGPJ0bkWOUmH7MEOR77qc",
          "id": "0tGPJ0bkWOUmH7MEOR77qc",
          "images": [
            {
              "height": 640,
              "url":
                  "https://i.scdn.co/image/ab67616d0000b2737359994525d219f64872d3b1",
              "width": 640
            },
            {
              "height": 300,
              "url":
                  "https://i.scdn.co/image/ab67616d00001e027359994525d219f64872d3b1",
              "width": 300
            },
            {
              "height": 64,
              "url":
                  "https://i.scdn.co/image/ab67616d000048517359994525d219f64872d3b1",
              "width": 64
            }
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
            "external_urls": {
              "spotify":
                  "https://open.spotify.com/artist/6sFIWsNpZYqfjUpaCgueju"
            },
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
        "external_urls": {
          "spotify": "https://open.spotify.com/track/11dFghVXANMlKmJXsNCbNl"
        },
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

      when(() => mockStorage.read(key: 'access_token'))
          .thenAnswer((invocation) => Future.value('response'));
      expect(api.getInfoTrack('11dFghVXANMlKmJXsNCbNl', mockHTTPClient),
          isA<Future<Map<String, dynamic>>>());
      verify(() => mockStorage.read(key: 'access_token')).called(1);
    });
  });

  test('Get Offset >=0', () async {
    final off = api.getOffset();
    expect(off, isA<Future<int>>());
    assert(off != null);
  });

  test('Get Try token is a bool', () async {
    final off = api.tryToken();
    expect(off, isA<Future<bool>>());
    assert(off != null);
  });
}
