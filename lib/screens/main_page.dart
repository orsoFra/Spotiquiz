import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:spotiquiz/firebase_options.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/screens/navigation.dart';

final sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);
final auth = Auth();

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<bool> checkLogin() async {
    await dotenv.load(fileName: ".env");
    var test = await storage.read(key: 'access_token');
    if (test != null) {
      //IF there is an access token -> not first login
      if (!await api.tryToken()) {
        //if the token is expired
        auth.refresh(); //refresh it
        print('VALID TOKEN! \n');
      }
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data.toString());

          if (snapshot.data.toString() == 'true') {
            return Navigation();
          } else
            return Login();
        } else
          return Login();
      },
    );
  }
}
