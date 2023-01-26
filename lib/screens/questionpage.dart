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
import 'package:spotiquiz/services/data.dart';
import '../widgets/progress_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spotiquiz/services/scalesize.dart';

var assetsAudioPlayer;

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
  QuestionPage({Key? key, required int this.isListening}) {
    sStorage = FlutterSecureStorage();
    storage = new MyStorage(sStorage);
    api = API(storage);
    qApi = QuestionAPI();
    dApi = Data(api: api);
    assetsAudioPlayer = AssetsAudioPlayer();
    isTest = false;
  }
  late final int isListening;
  late final sStorage;
  late final storage;
  late final api;
  late final qApi;
  late final dApi;
  late final bool isTest;

  QuestionPage.test({required int isL, required MyStorage ms, required API a, required QuestionAPI qA, required Data dA, required bool isT, required AssetsAudioPlayer aap}) {
    isListening = isL;
    sStorage = FlutterSecureStorage();
    storage = ms;
    api = a;
    qApi = qA;
    dApi = dA;
    isTest = isT;
    assetsAudioPlayer = aap;
  }

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
      this.questions = widget.qApi.generateListeningQuestions(http.Client(), numQuestions);
    else if (widget.isListening == 0)
      this.questions = widget.qApi.generateRandomQuestions(http.Client(), numQuestions);
    else
      this.questions = widget.qApi.generateNonListeningQuestions(http.Client(), numQuestions);

    if (widget.isTest) {
      _controller = Get.put(QuestionController(this.stopPlaying, numQuestions));
      timerController = Get.put(TimerController(_controller!));
      timerController.pause();
    } else {
      _controller = Get.put(QuestionController(this.stopPlaying, numQuestions));
      timerController = Get.put(TimerController(_controller!));
      _controller?.setTimerController(timerController);
      timerController.resetTimerAndStart();
      _controller?.reset();
    }
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
            return OrientationLayoutBuilder(
              portrait: ((context) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: queryData.size.height * 0.08,
                      ),
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

                                  SizedBox(
                                    width: double.infinity,
                                    height: queryData.size.height * 0.10,
                                    child: Text(
                                      snapshot.data!.question,
                                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                                    ),
                                  ),
                                  (snapshot.data!.songURL != null)
                                      ? ValueListenableBuilder(
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
                                              }))
                                      : ResponsiveBuilder(
                                          builder: (context, sizingInformation) {
                                            if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                                              return SizedBox(
                                                height: queryData.size.height * 0.1,
                                              );
                                            } else
                                              return SizedBox(
                                                height: queryData.size.height * 0.07,
                                              );
                                          },
                                        ),

                                  SizedBox(
                                    height: queryData.size.height * 0.05,
                                  ),

                                  // generate 4 bottons for the answers
                                  for (int i = 0; i < snapshot.data!.answers.length; i++)
                                    Column(
                                      children: [
                                        InkWell(
                                          key: Key(i.toString()),
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
                                                          ? [
                                                              Color.fromARGB(255, 0, 255, 0),
                                                              Color.fromARGB(255, 34, 139, 34),
                                                            ]
                                                          // wrong answer: red button
                                                          : [
                                                              Color.fromARGB(255, 255, 0, 0),
                                                              Color.fromARGB(255, 178, 34, 34),
                                                            ]
                                                      // default: violet
                                                      : [
                                                          Color.fromARGB(255, 128, 5, 195),
                                                          Color.fromARGB(255, 182, 80, 245),
                                                        ]),
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
                                                  textScaleFactor: ScaleSize.textScaleFactor(context),
                                                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(vertical: 10))
                                      ],
                                    ),
                                  SizedBox(
                                    height: queryData.size.height * 0.07,
                                  ),

                                  // QUIT BUTTON
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFF0D47A1),
                                                  Color(0xFF1976D2),
                                                  Color(0xFF42A5F5),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          key: Key('QUITBUTTON'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.all(16.0),
                                            textStyle: const TextStyle(fontSize: 20),
                                          ),
                                          onPressed: () {
                                            // if you want to exit, the timer and the music have to be stopped
                                            // and we don't want the results
                                            // and we have to back to the home page
                                            timerController.pause();
                                            assetsAudioPlayer.pause();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Quit'),
                                        ),
                                      ],
                                    ),
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
              landscape: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              if (snapshot.hasData) {
                                return Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Container(
                                    width: queryData.size.width * 0.4,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                                        height: queryData.size.height * 0.15,
                                        child: Text(
                                          snapshot.data!.question,
                                          style: TextStyle(color: Colors.white, fontSize: 27.0),
                                        ),
                                      ),
                                      (snapshot.data!.songURL != null)
                                          ? ValueListenableBuilder(
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
                                                  }))
                                          : SizedBox(
                                              height: queryData.size.height * 0.1,
                                            ),
                                      SizedBox(
                                        height: 25.0,
                                      ),
                                    ]),
                                  ),
                                  Column(
                                      // generate 4 bottons for the answers
                                      children: [
                                        for (int i = 0; i < snapshot.data!.answers.length; i++)
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
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
                                                  width: queryData.size.width * 0.3,
                                                  height: queryData.size.height * 0.08,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topRight,
                                                        end: Alignment.bottomLeft,
                                                        colors: hasBeenPressed[i]
                                                            ? i == snapshot.data!.correctAnswer
                                                                // correct answer: green button
                                                                ? [
                                                                    Color.fromARGB(255, 0, 255, 0),
                                                                    Color.fromARGB(255, 34, 139, 34),
                                                                  ]
                                                                // wrong answer: red button
                                                                : [
                                                                    Color.fromARGB(255, 255, 0, 0),
                                                                    Color.fromARGB(255, 178, 34, 34),
                                                                  ]
                                                            // default: violet
                                                            : [
                                                                Color.fromARGB(255, 128, 5, 195),
                                                                Color.fromARGB(255, 182, 80, 245),
                                                              ]),
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
                                                    child: Text(
                                                      snapshot.data!.answers[i],
                                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(vertical: 10))
                                            ],
                                          ),
                                      ])
                                ]);
                              } else {
                                return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  Center(child: const CircularProgressIndicator()),
                                ]);
                              }
                            default:
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              else
                                return new Text('Result: ${snapshot.data}');
                          }
                        }),
                    // QUIT BUTTON
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              width: queryData.size.width * 0.17,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              // if you want to exit, the timer and the music have to be stopped
                              // and we don't want the results
                              // and we have to back to the home page
                              timerController.pause();
                              assetsAudioPlayer.pause();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Quit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
