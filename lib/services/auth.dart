import 'dart:async';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Auth {
  Auth() {
    storage = new FlutterSecureStorage();
  }

  Auth.test({required FlutterSecureStorage st}) {
    storage = st;
  }

  late final FlutterSecureStorage storage;
  //Get info fro making the requests from the .env file
  // coverage:ignore-start
  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //SKIPPING COVERAGE SINCE IT?S ONLY A SERVICE USED FROM A PLUGIN
  Future<String?> getCode() async {
    // Present the dialog to the user
    await dotenv.load(fileName: ".env");
    final String client_id = dotenv.get('CLIENT_ID');
    final String client_secret = dotenv.get('CLIENT_SECRET');
    final String redirect_uri = dotenv.get('REDIRECT_URI');
    final String callback_scheme = dotenv.get('CALLBACK_URL_SCHEME');
    //print(client_id);
    final result = await FlutterWebAuth.authenticate(
        url:
            "https://accounts.spotify.com/authorize?client_id=${client_id}\&response_type=code&redirect_uri=${redirect_uri}&scope=user-library-read%20playlist-read-private%20user-read-private%20user-follow-read%20user-read-email%20&state=34fFs29kd09",
        callbackUrlScheme: callback_scheme,
        preferEphemeral: true);

// Extract token from resulting url
    final token = Uri.parse(result);
    //print(token.data);
    var code = token.queryParameters['code'];
    //print(code.toString());
    return code;
  }

  // coverage:ignore-end
  //gets the code and retrievs the auth_token and refresh token
  Future<bool> login(http.Client http, [String? cod]) async {
    await dotenv.load(fileName: ".env");
    final String client_id = dotenv.get('CLIENT_ID');
    final String client_secret = dotenv.get('CLIENT_SECRET');
    final String redirect_uri = dotenv.get('REDIRECT_URI');
    final String callback_scheme = dotenv.get('CALLBACK_URL_SCHEME');
    try {
      String? code;
      if (cod != null) {
        code = cod;
        print(code);
      } else {
        code = await getCode();
      } // this call makes the webview appear
      var url = Uri.https('accounts.spotify.com', '/api/token');
      var response = await http.post(url,
          body: {'code': code, 'redirect_uri': redirect_uri, 'grant_type': 'authorization_code'},
          headers: {'Authorization': 'Basic ' + (base64.encode(utf8.encode(client_id + ':' + client_secret)))});
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      //obtaines the tokens and storing them in secure storage
      var accessToken = decodedResponse['access_token'];
      await storage.write(key: 'access_token', value: accessToken);
      var refreshToken = decodedResponse['refresh_token'];
      await storage.write(key: 'refresh_token', value: refreshToken);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  //refershes the expired token token
  void refresh(http.Client http) async {
    await dotenv.load(fileName: ".env");
    final String client_id = dotenv.get('CLIENT_ID');
    final String client_secret = dotenv.get('CLIENT_SECRET');
    final String redirect_uri = dotenv.get('REDIRECT_URI');
    final String callback_scheme = dotenv.get('CALLBACK_URL_SCHEME');
    var refreshToken = await storage.read(key: 'refresh_token');
    print(refreshToken);
    var url = Uri.https('accounts.spotify.com', '/api/token');
    var response = await http.post(url,
        body: {'refresh_token': refreshToken, 'grant_type': 'refresh_token'}, headers: {'Authorization': 'Basic ' + (base64.encode(utf8.encode(client_id + ':' + client_secret)))});
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //print(decodedResponse.toString());
    var accessToken = decodedResponse['access_token'];
    await storage.write(key: 'access_token', value: accessToken);
  }
}
