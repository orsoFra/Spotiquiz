import 'package:flutter/material.dart';
import 'package:spotiquiz/screens/historypage.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

final qApi = QuestionAPI();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
                future: qApi.generateHomeSuggestions(http.Client()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        if (snapshot.data![index] == 'RANDOM') {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuestionPage(
                                        isListening: 0,
                                      )));
                            },
                            child: Container(
                              height: 150,
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
                              child: Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => QuestionPage(
                                                isListening: 0,
                                              )));
                                    },
                                    style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                    child: Text('RANDOM QUIZ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ),
                            ),
                          );
                        } else if (snapshot.data![index] == 'LISTENING') {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuestionPage(
                                        isListening: 1,
                                      )));
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 5, 56, 195),
                                    Color.fromARGB(255, 80, 121, 245),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => QuestionPage(
                                                isListening: 1,
                                              )));
                                    },
                                    style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                    child: Text('LISTENING QUIZ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QuestionPage(
                                        isListening: 2,
                                      )));
                            },
                            child: Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromARGB(255, 195, 56, 5),
                                    Color.fromARGB(255, 245, 108, 80),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => QuestionPage(
                                                isListening: 2,
                                              )));
                                    },
                                    style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                    child: Text('SILENT QUIZ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ),
                            ),
                          );
                        } //else
                      },
                      itemCount: snapshot.data!.length,
                      pagination: const SwiperPagination(),
                      control: const SwiperControl(color: Colors.transparent),
                      itemHeight: queryData.size.height * 0.6,
                      itemWidth: queryData.size.width * 0.9,
                      layout: SwiperLayout.TINDER,
                    );
                  }
                  return CircularProgressIndicator.adaptive();
                },
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            /*InkWell(
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => History()));
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
              ),
            ),*/
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
