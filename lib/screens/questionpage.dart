import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:spotiquiz/controllers/timer_controller.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/models/question_model.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/services/questionApi.dart';
import '../controllers/question_controller.dart';
import '../models/MyStorage.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:spotiquiz/screens/resultpage.dart';

import '../widgets/progress_bar.dart';

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
      await assetsAudioPlayer.open(Audio.network(URL),
          autoStart: false, showNotification: true);
      assetsAudioPlayer.play();
    } catch (t) {
      print(t);
    }
  }
}

class QuestionPage extends StatefulWidget {
  // ProgressBar progressBar = ProgressBar();
  QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  ValueNotifier<bool> isPlaying = ValueNotifier(false);
  List<Future<QuestionModel>>? questions;

  QuestionController? _controller;
  late TimerController timerController;

  // ProgressBar get progressBar => widget.progressBar;

  @override
  void initState() {
    isPlaying = ValueNotifier<bool>(false);
    super.initState();
    int numQuestions = 10;
    this.questions = qApi.generateRandomQuestions(http.Client(), numQuestions);
    _controller = Get.put(QuestionController(this.stopPlaying, numQuestions));
    timerController = Get.put(TimerController(_controller!));
    _controller?.setTimerController(timerController);
    timerController.resetTimerAndStart();
    _controller?.reset();
  }

  void stopPlaying(){
    assetsAudioPlayer.pause();
    setState(() {
      isPlaying.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // QuestionModel question = new QuestionModel("Who is the author of the song Pippo?", ["a", "b", "c", "d"], 1);
    _controller?.setContext(context);
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: PageView.builder(
          itemCount: questions!.length,
          controller: _controller?.pageController,
          onPageChanged: (page) {
            // widget.progressBar.controller.animationController.reset();
            // widget.progressBar.controller.animationController.forward();
            if (page == questions!.length - 1) {
              setState(() {
                //btnText = "See Results";
                print("finish");
              });
            }
            setState(() {
              //answered = false;
              print("page changed");
              // ProgressBar(controller,);
              // widget.progressBar;
            });
          },
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<QuestionModel>(
                      future: this.questions![index],
                      builder: (BuildContext context,
                          AsyncSnapshot<QuestionModel> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                    child: const CircularProgressIndicator()),
                              ],
                            );
                          case ConnectionState.done:
                            if (snapshot.data == null) print('data is null');
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // widget.progressBar,
                                  ProgressBar(questionController: _controller!),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "Question ${index + 1}/${questions!.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 28.0,
                                      ),
                                    ),
                                  ),

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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22.0),
                                    ),
                                  ),
                                  if (snapshot.data!.songURL != null)
                                    ValueListenableBuilder(
                                        valueListenable: isPlaying,
                                        builder: (context, value, child) =>
                                            IconButton(
                                                iconSize: 50,
                                                icon: (isPlaying.value)
                                                    ? const Icon(Icons.stop)
                                                    : Icon(Icons.play_arrow),
                                                onPressed: () {
                                                  isPlaying.value =
                                                      !isPlaying.value;
                                                  playPauseAudioNetwork(
                                                      snapshot.data!.songURL!,
                                                      isPlaying.value);
                                                })),

                                  SizedBox(
                                    height: 25.0,
                                  ),

                                  // generate 4 bottons for the answers
                                  for (int i = 0;
                                      i < snapshot.data!.answers.length;
                                      i++)
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: 18.0),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                if (i ==
                                                    snapshot
                                                        .data!.correctAnswer) {
                                                  return Colors.greenAccent;
                                                } else {
                                                  return Colors.redAccent;
                                                }
                                              }
                                              return null; // Defer to the widget's default.
                                            },
                                          ),
                                          // shape: StadiumBorder(),
                                          // color: Colors.blueAccent,
                                          // padding: EdgeInsets.symmetric(
                                          //     vertical: 18.0),
                                        ),
                                        onPressed: () {
                                          if (i ==
                                              snapshot.data!.correctAnswer) {
                                            _controller?.score++;
                                          }
                                          _controller?.nextPage();
                                        },
                                        child: Text(snapshot.data!.answers[i],
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                ]);
                          default:
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            else
                              return new Text('Result: ${snapshot.data}');
                        }
                      }),
                ],
              ),
            );
          }),
    );
  }
}
