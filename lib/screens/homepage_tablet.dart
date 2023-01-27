import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spotiquiz/services/scalesize.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

import '../models/card.dart';

final qApi = QuestionAPI();

class HomeTablet extends StatefulWidget {
  HomeTablet({super.key}) {
    qApi = QuestionAPI();
  }

  late final qApi;

  HomeTablet.test({super.key, required QuestionAPI qA}) {
    qApi = qA;
  }

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 20, 20),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        elevation: 0,
      ),
      body: OrientationLayoutBuilder(
        portrait: ((context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Welcome Back',
                    textScaleFactor: ScaleSize.textScaleFactor(context),
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
                        return Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            if (snapshot.data![index] == 'RANDOM') {
                              return SliderCard(cols: [
                                Color.fromARGB(255, 128, 5, 195),
                                Color.fromARGB(255, 182, 80, 245),
                              ], icon: Icons.question_mark_rounded, text: 'RANDOM QUIZ', isListening: 0);
                            } else if (snapshot.data![index] == 'LISTENING') {
                              return SliderCard(cols: [
                                Color.fromARGB(255, 5, 56, 195),
                                Color.fromARGB(255, 80, 121, 245),
                              ], icon: Icons.music_note_rounded, text: 'LISTENING QUIZ', isListening: 1);
                            } else {
                              return SliderCard(cols: [
                                Color.fromARGB(255, 195, 56, 5),
                                Color.fromARGB(255, 245, 108, 80),
                              ], icon: Icons.notifications_off_rounded, text: 'SILENT QUIZ', isListening: 2);
                            } //else
                          },
                          itemCount: snapshot.data!.length,
                          pagination: const SwiperPagination(builder: SwiperPagination.rect),
                          control: const SwiperControl(color: Colors.transparent),
                          itemHeight: queryData.size.height * 0.6,
                          itemWidth: queryData.size.width * 0.8,
                          layout: SwiperLayout.TINDER,
                        );
                      }
                      return CircularProgressIndicator.adaptive();
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                  },
                  child: Container(
                    height: queryData.size.height * 0.08,
                    width: queryData.size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 128, 5, 195),
                          Color.fromARGB(255, 182, 80, 245),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                      child: Text("YOUR PROFILE",
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: queryData.textScaleFactor * 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                  },
                  child: Container(
                    height: queryData.size.height * 0.08,
                    width: queryData.size.width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 128, 5, 195),
                          Color.fromARGB(255, 182, 80, 245),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Leaderboard()));
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                      child: Text("LEADERBOARD",
                          textScaleFactor: ScaleSize.textScaleFactor(context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: queryData.textScaleFactor * 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        landscape: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome Back',
                  textScaleFactor: ScaleSize.textScaleFactor(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: queryData.size.height * 0.75,
                        width: queryData.size.width * 0.4,
                        child: FutureBuilder<List<String>>(
                          future: widget.qApi.generateHomeSuggestions(http.Client()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  if (snapshot.data![index] == 'RANDOM') {
                                    return SliderCard(cols: [
                                      Color.fromARGB(255, 128, 5, 195),
                                      Color.fromARGB(255, 182, 80, 245),
                                    ], icon: Icons.question_mark_rounded, text: 'RANDOM QUIZ', isListening: 0);
                                  } else if (snapshot.data![index] == 'LISTENING') {
                                    return SliderCard(cols: [
                                      Color.fromARGB(255, 5, 56, 195),
                                      Color.fromARGB(255, 80, 121, 245),
                                    ], icon: Icons.music_note_rounded, text: 'LISTENING QUIZ', isListening: 1);
                                  } else {
                                    return SliderCard(cols: [
                                      Color.fromARGB(255, 195, 56, 5),
                                      Color.fromARGB(255, 245, 108, 80),
                                    ], icon: Icons.notifications_off_rounded, text: 'SILENT QUIZ', isListening: 2);
                                  } //else
                                },
                                itemCount: snapshot.data!.length,
                                pagination: const SwiperPagination(builder: SwiperPagination.rect),
                                control: const SwiperControl(color: Colors.transparent),
                                itemHeight: queryData.size.height * 0.75,
                                itemWidth: queryData.size.width * 0.4,
                                layout: SwiperLayout.TINDER,
                              );
                            }
                            return CircularProgressIndicator.adaptive();
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        key: Key('Person'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                        },
                        child: Container(
                          height: queryData.size.height * 0.2,
                          width: queryData.size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 128, 5, 195),
                                Color.fromARGB(255, 182, 80, 245),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                            },
                            style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                            child: Text("YOUR PROFILE",
                                textScaleFactor: ScaleSize.textScaleFactor(context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: queryData.textScaleFactor * 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      InkWell(
                        key: Key('Leaderboard'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                        },
                        child: Container(
                          height: queryData.size.height * 0.2,
                          width: queryData.size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 128, 5, 195),
                                Color.fromARGB(255, 182, 80, 245),
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Leaderboard()));
                            },
                            style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                            child: Text("LEADERBOARD",
                                textScaleFactor: ScaleSize.textScaleFactor(context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: queryData.textScaleFactor * 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
