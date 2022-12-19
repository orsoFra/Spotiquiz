import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/models/question_model.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/services/questionApi.dart';
import '../models/MyStorage.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

final sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);
final qApi = QuestionAPI();
final assetsAudioPlayer = AssetsAudioPlayer();
//bool isPlaying = false;
void playPauseAudioNetwork(String URL, bool doPlay) async {
  if (!doPlay) {
    assetsAudioPlayer.pause();
  } else {
    try {
      await assetsAudioPlayer.open(Audio.network(URL), autoStart: false, showNotification: true);
      assetsAudioPlayer.play();
    } catch (t) {
      print(t);
    }
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  ValueNotifier<bool> isPlaying = ValueNotifier(false);

  @override
  void initState() {
    isPlaying = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // QuestionModel question = new QuestionModel("Who is the author of the song Pippo?", ["a", "b", "c", "d"], 1);
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        body: Column(
          children: [
            FutureBuilder<QuestionModel>(
                future: qApi.generateRandomQuestion(http.Client()),
                builder: (BuildContext context, AsyncSnapshot<QuestionModel> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      // TODO: mettere widget che fa loading invece del text
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: const CircularProgressIndicator()),
                        ],
                      );
                    case ConnectionState.done:
                      if (snapshot.data == null) print('data is null');
                      return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Question 1/1",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 28.0,
                            ),
                          ),
                        ),
                        // TODO: change it when you will have more questions

                        Divider(
                          color: Colors.white,
                          height: 8.0,
                          thickness: 1.0,
                        ),

                        const SizedBox(
                          height: 20.0,
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 200.0,
                          child: Text(
                            snapshot.data!.question,
                            style: TextStyle(color: Colors.white, fontSize: 22.0),
                          ),
                        ),
                        if (snapshot.data!.songURL != null)
                          ValueListenableBuilder(
                              valueListenable: isPlaying,
                              builder: (context, value, child) => IconButton(
                                  iconSize: 50,
                                  icon: (isPlaying.value) ? const Icon(Icons.stop) : Icon(Icons.play_arrow),
                                  onPressed: () {
                                    isPlaying.value = !isPlaying.value;
                                    playPauseAudioNetwork(snapshot.data!.songURL!, isPlaying.value);
                                  })),

                        SizedBox(
                          height: 25.0,
                        ),

                        // generate 4 bottons for the answers
                        for (int i = 0; i < snapshot.data!.answers.length; i++)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 18.0),
                            child: MaterialButton(
                              shape: StadiumBorder(),
                              color: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(vertical: 18.0),
                              onPressed: () {},
                              child: Text(snapshot.data!.answers[i], style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        SizedBox(
                          height: 30.0,
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              // we will do it later
                              ),
                          child: Text(
                            "Next Question",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ]);
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return new Text('Result: ${snapshot.data}');
                  }
                }),
          ],
        ));
  }
}