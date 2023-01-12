import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;

import '../services/data.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 20, 20),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        title: Text('History',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        )),
        elevation: 0,
      ),
      body: FutureBuilder<int>(
        future: getNumQuizzes(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot){
          if(snapshot.hasData){
            return Text("Quizzes done: ${snapshot.data}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),);
          }
          return Text("waiting");
        }

    ),
    );
  }
}


