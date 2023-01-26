import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/models/card.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title}) {
    qApi = QuestionAPI();
  }
  late QuestionAPI qApi;

  MyHomePage.test({
    super.key,
    required this.title,
    required QuestionAPI qa,
  }) {
    this.qApi = qa;
  }
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 20, 20),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                )),
            Container(
              height: queryData.size.height * 0.6,
              width: queryData.size.width * 0.9,
              child: FutureBuilder<List<String>>(
                future: widget.qApi.generateHomeSuggestions(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Text('No quizzes?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ));
                    } else {
                      return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data![index] == 'RANDOM') {
                            return SliderCard(
                                key: Key('RANDOM'),
                                cols: [
                                  Color.fromARGB(255, 128, 5, 195),
                                  Color.fromARGB(255, 182, 80, 245),
                                ],
                                icon: Icons.question_mark_rounded,
                                text: 'RANDOM QUIZ',
                                isListening: 0);
                          } else if (snapshot.data![index] == 'LISTENING') {
                            return SliderCard(
                                key: Key('LISTENING'),
                                cols: const [
                                  Color.fromARGB(255, 5, 56, 195),
                                  Color.fromARGB(255, 80, 121, 245),
                                ],
                                icon: Icons.music_note_rounded,
                                text: 'LISTENING QUIZ',
                                isListening: 1);
                          } else {
                            return SliderCard(
                                key: Key('SILENT'),
                                cols: [
                                  Color.fromARGB(255, 195, 56, 5),
                                  Color.fromARGB(255, 245, 108, 80),
                                ],
                                icon: Icons.notifications_off_rounded,
                                text: 'SILENT QUIZ',
                                isListening: 2);
                          } //else
                        },
                        itemCount: snapshot.data!.length,
                        pagination: const SwiperPagination(builder: SwiperPagination.rect),
                        control: const SwiperControl(color: Colors.transparent),
                        itemHeight: queryData.size.height * 0.6,
                        itemWidth: queryData.size.width * 0.9,
                        layout: SwiperLayout.TINDER,
                      );
                    }
                  }
                  return CircularProgressIndicator.adaptive();
                },
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
