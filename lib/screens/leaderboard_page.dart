import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import '../models/MyStorage.dart';

final db = FirebaseFirestore.instance;
final sStorage = FlutterSecureStorage();
final storage = MyStorage(sStorage);
final api = API(storage);

Future getScores() async {
  String id = await api.getIdUser(http.Client());
  var res = db.collection('scores').orderBy('totalScore');
  return res;
}

Future<List> getLeaderboard() async {
  List<Object> res = [];
  await db.collection('scores').orderBy('totalScore', descending: true).get().then((snapshot) => snapshot.docs.forEach((element) {
        //print(element.reference);
        res.add(element);
      }));
  return res;
}

Future<int> getPosUser() async {
  String id = await api.getIdUser(http.Client());
  List<Object> res = [];
  var doc = await db.collection('scores').doc(id).get().then((DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    await db
        .collection('scores')
        .where('totalScore', isGreaterThan: data['totalScore'])
        .orderBy('totalScore', descending: true)
        .get()
        .then((snapshot) => snapshot.docs.forEach((element) {
              //print(element.reference);
              res.add(element);
            }));
  });

  return res.length + 1;
}

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

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
        title: Text('Leaderboard'),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
          future: getLeaderboard(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          height: queryData.size.height * 0.3,
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
                              Text(snapshot.data!.elementAt(1)['totalScore'].toString(),
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
                          height: queryData.size.height * 0.4,
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
                              Text(snapshot.data!.elementAt(0)['totalScore'].toString(),
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
                          height: queryData.size.height * 0.2,
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
                              Text(snapshot.data!.elementAt(2)['totalScore'].toString(),
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
                ),
                //FIRST PLACE
                /*Container(
                    height: queryData.size.height * 0.2,
                    width: queryData.size.width * 0.8,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 142, 107, 11),
                          Color.fromARGB(255, 241, 183, 24),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "#1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Column(children: [
                            Text(snapshot.data!.elementAt(0)['totalScore'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(snapshot.data!.elementAt(0)['name'].toString())
                            /*FutureBuilder<String>(
                                    future: api.getNameOfUser(http.Client(), snapshot.data!.elementAt(0)['id'].toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        return Text(snapshot.data!);
                                      else
                                        return Text("awaiting data...");
                                    })*/
                          ]),
                        )
                      ],
                    )),
                //Second
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                    height: queryData.size.height * 0.15,
                    width: queryData.size.width * 0.7,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 120, 120, 120),
                          Color.fromARGB(255, 209, 209, 209),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "#2",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Column(children: [
                            Text(snapshot.data!.elementAt(1)['totalScore'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(snapshot.data!.elementAt(1)['name'].toString())
                            /*FutureBuilder<String>(
                                    future: api.getNameOfUser(http.Client(), snapshot.data!.elementAt(1)['id'].toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        return Text(snapshot.data!);
                                      else
                                        return Text("awaiting data...");
                                    })*/
                          ]),
                        )
                      ],
                    )),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Container(
                    height: queryData.size.height * 0.10,
                    width: queryData.size.width * 0.6,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 151, 89, 19),
                          Color.fromARGB(255, 209, 151, 104),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "#3",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Column(children: [
                            Text(snapshot.data!.elementAt(2)['totalScore'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(snapshot.data!.elementAt(2)['name'].toString())
                            /*FutureBuilder<String>(
                                    future: api.getNameOfUser(http.Client(), snapshot.data!.elementAt(2)['id'].toString()),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData)
                                        return Text(snapshot.data!);
                                      else
                                        return Text("awaiting data...");
                                    })*/
                          ]),
                        )
                      ],
                    )),*/
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Divider(
                  color: Colors.white,
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
                          Color.fromARGB(255, 170, 2, 19),
                          Color.fromARGB(255, 245, 120, 88),
                        ],
                      ),
                    ),
                    child: FutureBuilder<int>(
                        future: getPosUser(),
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
                                Text(snapshot.data!.elementAt(pos.data! - 1)['totalScore'].toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(snapshot.data!.elementAt(pos.data! - 1)['name'].toString())
                              ]),
                            ]);
                          } else
                            return CircularProgressIndicator();
                        }))
              ]));
            } else
              return CircularProgressIndicator();
          }),
    );
  }
}
