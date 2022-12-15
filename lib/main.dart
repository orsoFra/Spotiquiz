import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:http/http.dart' as http;

import 'models/MyStorage.dart';

// Create storage
final sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);
final auth = Auth();
var accesstoken;
Map<String, dynamic> a = Map();
final assetsAudioPlayer = AssetsAudioPlayer();

Future main() async {
  await dotenv.load(fileName: ".env");
  var test = await storage.read(key: 'access_token');
  if (test != null) {
    //IF there is an access token -> not first login
    if (!await api.tryToken()) {
      //if the token is expired
      auth.refresh(); //refresh it
    }
  } else {
    // if the token does not exist
    auth.login(); //prompt login
  }
  runApp(const MyApp());
}

void playAudioNetwork() async {
  a = await api.getRandomSongFromLibrary(http.Client());
  try {
    await assetsAudioPlayer.open(Audio.network(a['preview_url']),
        autoStart: false, showNotification: true);
    assetsAudioPlayer.play();
  } catch (t) {
    print(t);
  }
}

void infoTrack() async {
  Map<String, dynamic> info =
      await api.getFeaturesTrack(a['id'], http.Client());
  print(info.keys);
}

void login() async {
  final Auth spotiauth = Auth();
  spotiauth.login();
  //accesstoken = await storage.read(key: 'acces_token');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

@protected
@mustCallSuper
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? token = '';
  var song;

  void _seetLink() {
    setState(() async {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press and see',
            ),
            MaterialButton(
              onPressed: playAudioNetwork,
              color: Colors.amber,
              child: Text("PLAY"),
            ),
            MaterialButton(
              onPressed: assetsAudioPlayer.pause,
              color: Colors.blue,
              child: Text("PAUSE"),
            ),
            MaterialButton(
              onPressed: infoTrack,
              color: Colors.green[600],
              child: Text("INFO ON SONG"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => QuestionPage()));
              },
              color: Colors.orange[600],
              child: Text("RANDOM QUESTION"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => UserPage()));
              },
              color: Colors.green[600],
              child: Text("INFO ON USER"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: login,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
