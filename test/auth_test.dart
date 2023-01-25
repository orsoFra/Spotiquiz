import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:http/http.dart' as http;

class MockStorage extends Mock implements FlutterSecureStorage {}

class MockHTTP extends Mock implements http.Client {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mockStorage = MockStorage();
  final mockHTTPost = MockHTTP();
  final Auth auth = Auth.test(st: mockStorage);
  setUpAll(() {
    registerFallbackValue(Uri());
  });
  //await dotenv.load(fileName: ".env");
  test('login method', () async {
    var response = {'access_token': '', 'refresh_token': ''};
    var uri = Uri.https('accounts.spotify.com', '/api/token');
    final mockHTTPClient = MockClient((request) async {
      // Create sample response of the HTTP call //
      return Response(jsonEncode(response), 200);
    });

    when(() => mockHTTPost.post(uri, headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async => Future.value(http.Response('{"title": "Test"}', 200)));
    var res = await auth.login(mockHTTPost, 'string');
    verify(() => mockHTTPost.post(uri, headers: any(named: 'headers'), body: any(named: 'body'))).called(1);
    assert(res == false);
  });

  test('refresh method', () async {
    final response = {'access_token': '', 'refresh_token': ''};
    var uri = Uri.https('accounts.spotify.com', '/api/token');
    when(() => mockStorage.read(key: any(named: 'key'))).thenAnswer((invocation) => Future.value('response'));
    when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((invocation) => Future.value());
    when(() => mockHTTPost.post(any(), headers: any(named: 'headers'), body: any(named: 'body'))).thenAnswer((_) async => Future.value(Response(jsonEncode(response), 200)));
    auth.refresh(mockHTTPost);
    //verify(() => mockHTTPost.post(uri, headers: any(named: 'headers'), body: any(named: 'body'))).called(1);
    //verify(() => mockStorage.read(key: any(named: 'key'))).called(1);
    //verify(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value'))).called(1);
  });
}
