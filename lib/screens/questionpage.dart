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
import 'package:spotiquiz/services/data.dart' as dApi;
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
      await assetsAudioPlayer.open(Audio.network(URL), autoStart: false, showNotification: true);
      assetsAudioPlayer.play();
    } catch (t) {
      print(t);
    }
  }
}

class QuestionPage extends StatefulWidget {
  QuestionPage({Key? key, required int this.isListening}) : super(key: key);
  final int isListening;
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  ValueNotifier<bool> isPlaying = ValueNotifier(false);
  List<Future<QuestionModel>>? questions;

  QuestionController? _controller;
  late TimerController timerController;

  List<bool> hasBeenPressed = [false, false, false, false];
  int previousIndex = -1;

  @override
  void initState() {
    isPlaying = ValueNotifier<bool>(false);
    super.initState();
    int numQuestions = 10;
    if (widget.isListening == 1)
      this.questions = qApi.generateListeningQuestions(http.Client(), numQuestions);
    else if (widget.isListening == 0)
      this.questions = qApi.generateRandomQuestions(http.Client(), numQuestions);
    else
      this.questions = qApi.generateNonListeningQuestions(http.Client(), numQuestions);
    _controller = Get.put(QuestionController(this.stopPlaying, numQuestions));
    timerController = Get.put(TimerController(_controller!));
    _controller?.setTimerController(timerController);
    timerController.resetTimerAndStart();
    _controller?.reset();
  }

  void stopPlaying() {
    assetsAudioPlayer.pause();
    setState(() {
      isPlaying.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    _controller?.setContext(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 20, 20),
      body: PageView.builder(
          itemCount: questions!.length,
          controller: _controller?.pageController,
          onPageChanged: (page) {
            if (page == questions!.length - 1) {
              setState(() {
                print("finish");
              });
            }
            setState(() {
              print("page changed");
            });
          },
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index != previousIndex) {
              hasBeenPressed = [false, false, false, false];
            }
            previousIndex = index;
            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<QuestionModel>(
                      future: this.questions![index],
                      builder: (BuildContext context, AsyncSnapshot<QuestionModel> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
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
                              // widget.progressBar,
                              //Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                              ProgressBar(questionController: _controller!),
                              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Question ${index + 1}/${questions!.length}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
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
                                  style: TextStyle(color: Colors.white, fontSize: 27.0),
                                ),
                              ),
                              if (snapshot.data!.songURL != null)
                                ValueListenableBuilder(
                                    valueListenable: isPlaying,
                                    builder: (context, value, child) => IconButton(
                                        iconSize: 50,
                                        icon: (isPlaying.value)
                                            ? const Icon(
                                                Icons.stop,
                                                color: Colors.white,
                                              )
                                            : Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                        onPressed: () {
                                          isPlaying.value = !isPlaying.value;
                                          playPauseAudioNetwork(snapshot.data!.songURL!, isPlaying.value);
                                        })),

                              SizedBox(
                                height: 25.0,
                              ),

                              // generate 4 bottons for the answers
                              for (int i = 0; i < snapshot.data!.answers.length; i++)
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (i == snapshot.data!.correctAnswer) {
                                          _controller?.score++;
                                          dApi.storeStats(snapshot.data!.authorId!, true);
                                        } else {
                                          dApi.storeStats(snapshot.data!.authorId!, false);
                                        }

                                        setState(() {
                                          hasBeenPressed[i] = true;
                                          assetsAudioPlayer.pause();
                                          isPlaying.value = false;
                                        });
                                        _controller?.nextPage();
                                      },
                                      child: Container(
                                        width: queryData.size.width * 0.7,
                                        height: queryData.size.height * 0.08,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: hasBeenPressed[i]
                                              ? i == snapshot.data!.correctAnswer
                                                  // correct answer: green button
                                                  ? [Color.fromARGB(255, 0, 255, 0),
                                                    Color.fromARGB(255, 34, 139, 34),]
                                                  // wrong answer: red button
                                                  : [Color.fromARGB(255, 255, 0, 0),
                                                    Color.fromARGB(255, 178, 34, 34),]
                                              // default: violet
                                             : [Color.fromARGB(255, 128, 5, 195),
                                               Color.fromARGB(255, 182, 80, 245),]),
                                          ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent,
                                              shadowColor: Colors.transparent,
                                          ),
                                          // backgroundColor: Colors.greenAccent),
                                          // shape: StadiumBorder(),
                                          // color: Colors.blueAccent,
                                          // padding: EdgeInsets.symmetric(
                                          //     vertical: 18.0),
                                          onPressed: () {
                                            if (i == snapshot.data!.correctAnswer) {
                                              _controller?.score++;
                                              dApi.storeStats(snapshot.data!.authorId!, true);
                                            } else {
                                              dApi.storeStats(snapshot.data!.authorId!, false);
                                            }
                                            setState(() {
                                              hasBeenPressed[i] = true;
                                              assetsAudioPlayer.pause();
                                              isPlaying.value = false;
                                            });
                                            _controller?.nextPage();
                                          },
                                          child: Text(snapshot.data!.answers[i],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                    ),

                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 10))
                                  ],
                                ),
                              const SizedBox(
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
