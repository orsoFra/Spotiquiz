import 'dart:async';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Auth {
  final storage = new FlutterSecureStorage();
  //Get info fro making the requests from the .env file
  final client_id = dotenv.get('CLIENT_ID');
  final client_secret = dotenv.get('CLIENT_SECRET');
  final redirect_uri = dotenv.get('REDIRECT_URI');
  final callback_scheme = dotenv.get('CALLBACK_URL_SCHEME');

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<String?> getCode() async {
    // Present the dialog to the user
    await dotenv.load(fileName: ".env");
    //print(client_id);
    final result = await FlutterWebAuth.authenticate(
      url:
          "https://accounts.spotify.com/authorize?client_id=${client_id}\&response_type=code&redirect_uri=${redirect_uri}&scope=user-library-read%20playlist-read-private%20user-read-private%20user-read-email%20&state=34fFs29kd09",
      callbackUrlScheme: callback_scheme,
    );

// Extract token from resulting url
    final token = Uri.parse(result);
    //print(token.data);
    var code = token.queryParameters['code'];
    //print(code.toString());
    return code;
  }

  //gets the code and retrievs the auth_token and refresh token
  void login() async {
    var code = await getCode(); // this call makes the webview appear
    var url = Uri.https('accounts.spotify.com', '/api/token');
    var response = await http.post(url, body: {
      'code': code,
      'redirect_uri': redirect_uri,
      'grant_type': 'authorization_code'
    }, headers: {
      'Authorization': 'Basic ' +
          (base64.encode(utf8.encode(client_id + ':' + client_secret)))
    });
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    //obtaines the tokens and storing them in secure storage
    var accessToken = decodedResponse['access_token'];
    await storage.write(key: 'access_token', value: accessToken);
    var refreshToken = decodedResponse['refresh_token'];
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  //refershes the expired token token
  void refresh() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    print(refreshToken);
    var url = Uri.https('accounts.spotify.com', '/api/token');
    var response = await http.post(url, body: {
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token'
    }, headers: {
      'Authorization': 'Basic ' +
          (base64.encode(utf8.encode(client_id + ':' + client_secret)))
    });
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse.toString());
    var accessToken = decodedResponse['access_token'];
    await storage.write(key: 'access_token', value: accessToken);
  }
}
