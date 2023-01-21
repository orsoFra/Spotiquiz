import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import '../models/MyStorage.dart';
import '../services/data.dart';

final sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);
final dApi = Data(api: api);

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage(this.score, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dApi.storeResults(score);
    MediaQueryData queryData = MediaQuery.of(context);
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text("Congratulations!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 45.0,
            ),
            const Text(
              "Your Score is:",
              style: TextStyle(color: Colors.white, fontSize: 34.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "${score}",
              style: TextStyle(
                foreground: Paint()..shader = linearGradient,
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Button to return to the home
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: queryData.size.height * 0.08,
                width: queryData.size.width * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                  child: Text("BACK TO HOME",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
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
            ),
          ],
        ));
  }
}
