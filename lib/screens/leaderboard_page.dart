import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import '../models/MyStorage.dart';
import '../services/data.dart';

final storage = MyStorage(sStorage);
final api = API(storage);

class Leaderboard extends StatefulWidget {
  Leaderboard({super.key}) {
    dApi = Data(api: api);
  }
  late Data dApi;

  Leaderboard.test({super.key, required Data dA}) {
    dApi = dA;
  }
  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 20, 20),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        title: Text('All time leaderboard'),
        elevation: 0,
      ),
      body: OrientationLayoutBuilder(
        portrait: (context) {
          return RefreshIndicator(
            child: FutureBuilder<List<dynamic>>(
                future: widget.dApi.getLeaderboard(),
                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Center(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                            Podium(key: Key('Podium'), snapshot: snapshot, queryData: queryData, portrait: true),
                            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            Divider(
                              color: Color.fromARGB(255, 49, 45, 45),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            //SCORE OF THE USER
                            Container(
                                height: queryData.size.height * 0.2,
                                width: queryData.size.width * 0.8,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 30, 25, 25),
                                      Color.fromARGB(255, 49, 45, 45),
                                    ],
                                  ),
                                ),
                                child: FutureBuilder<int>(
                                    future: widget.dApi.getPosUser(),
                                    builder: (context, pos) {
                                      if (pos.hasData) {
                                        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          Text(
                                            '#' + pos.data!.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                            Text(snapshot.data!.elementAt(pos.data! - 1)['totalScore'].toString() + ' points',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Text(snapshot.data!.elementAt(pos.data! - 1)['name'].toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ]),
                                        ]);
                                      } else
                                        return CircularProgressIndicator(
                                          color: Color.fromARGB(255, 49, 45, 45),
                                        );
                                    }))
                          ])),
                        ),
                      ],
                    );
                  } else
                    return CircularProgressIndicator();
                }),
            onRefresh: () async {
              setState(() {});
            },
          );
        },
        landscape: (context) {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<List<dynamic>>(
                    future: widget.dApi.getLeaderboard(),
                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Podium(snapshot: snapshot, queryData: queryData, portrait: false)]),
                                  Container(
                                      height: queryData.size.height * 0.2,
                                      width: queryData.size.width * 0.4,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromARGB(255, 30, 25, 25),
                                            Color.fromARGB(255, 49, 45, 45),
                                          ],
                                        ),
                                      ),
                                      child: FutureBuilder<int>(
                                          future: widget.dApi.getPosUser(),
                                          builder: (context, pos) {
                                            if (pos.hasData) {
                                              return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                                Text(
                                                  '#' + pos.data!.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Text(snapshot.data!.elementAt(pos.data! - 1)['totalScore'].toString() + ' points',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                  Text(snapshot.data!.elementAt(pos.data! - 1)['name'].toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      )),
                                                ]),
                                              ]);
                                            } else
                                              return CircularProgressIndicator(
                                                color: Color.fromARGB(255, 49, 45, 45),
                                              );
                                          }))
                                ],

                                //SCORE OF THE USER
                              ),
                              SizedBox.shrink()
                            ],
                          ),
                        );
                      } else
                        return CircularProgressIndicator();
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Podium extends StatelessWidget {
  const Podium({super.key, required this.snapshot, required this.queryData, required this.portrait});
  final AsyncSnapshot snapshot;
  final MediaQueryData queryData;
  final bool portrait;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (portrait)
          ? (queryData.size.width < 500)
              ? queryData.size.width * 0.9
              : queryData.size.width * 0.7
          : queryData.size.width * 0.4,
      height: (portrait) ? queryData.size.height * 0.4 : queryData.size.height * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              height: (portrait) ? queryData.size.height * 0.3 : queryData.size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 120, 120, 120),
                    Color.fromARGB(255, 209, 209, 209),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "#2",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(snapshot.data!.elementAt(1)['totalScore'].toString() + ' points',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(snapshot.data!.elementAt(1)['name'].toString())
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: (portrait) ? queryData.size.height * 0.4 : queryData.size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 142, 107, 11),
                    Color.fromARGB(255, 241, 183, 24),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "#1",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(snapshot.data!.elementAt(0)['totalScore'].toString() + ' points',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(snapshot.data!.elementAt(0)['name'].toString())
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: (portrait) ? queryData.size.height * 0.2 : queryData.size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 151, 89, 19),
                    Color.fromARGB(255, 209, 151, 104),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "#3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(snapshot.data!.elementAt(2)['totalScore'].toString() + ' points',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(snapshot.data!.elementAt(2)['name'].toString())
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
