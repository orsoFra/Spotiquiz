import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/services/api.dart';
import '../models/MyStorage.dart';

final db = FirebaseFirestore.instance;
final sStorage = FlutterSecureStorage();
final storage = MyStorage(sStorage);
final api = API(storage);

void storeResults(int score) async {
  String id = await api.getIdUser(http.Client());
  String name = await api.getNameOfUser(http.Client(), id);
  // add --> id autogenerated
  db.collection("quizzes").add({'date': Timestamp.now(), 'points': score, 'user': id});
  // I want take the id of the user --> so it's not autogenerated
  db.collection('users').doc(id).get().then((doc) {
    if (doc.exists) {
      //print("Document data:" + doc.data().toString());
      db.collection("users").doc(id).update({
        'totalScore': score + doc.data()!['totalScore'],
        'numQuizzes': 1 + doc.data()!['numQuizzes'],
        'numPerfectQuizzes': (score == 10 ? 1 : 0) + doc.data()!['numPerfectQuizzes'],
      });
    } else {
      db.collection("users").doc(id).set({'id': id, 'totalScore': score, 'name': name, 'numQuizzes': 1, 'numPerfectQuizzes': score == 10 ? 1 : 0});
    }
  });
}

void storeStats(String authId, bool isCorrect) async {
  String id = await api.getIdUser(http.Client());
  db.collection('users').doc(id).collection('authors').doc(authId).get().then((doc) {
    if (doc.exists) {
      //print("Document data:" + doc.data().toString());
      if (isCorrect)
        db.collection('users').doc(id).collection('authors').doc(authId).update({
          'questionsDone': 1 + doc.data()!['questionsDone'],
          'questionsCorrect': 1 + doc.data()!['questionsCorrect'],
        });
      else {
        db.collection('users').doc(id).collection('authors').doc(authId).update({
          'questionsDone': doc.data()!['questionsDone'],
          'questionsCorrect': 1 + doc.data()!['questionsCorrect'],
        });
      }
    } else {
      if (isCorrect)
        db.collection('users').doc(id).collection('authors').doc(authId).set({
          'questionsDone': 1,
          'questionsCorrect': 1,
        });
      else {
        db.collection('users').doc(id).collection('authors').doc(authId).set({
          'questionsDone': 1,
          'questionsCorrect': 0,
        });
      }
    }
  });
}

Future getScores() async {
  String id = await api.getIdUser(http.Client());
  var res = db.collection('users').orderBy('totalScore');
  return res;
}

Future<int> getNumQuizzes() async {
  String id = await api.getIdUser(http.Client());
  int res = -1;
  await db.collection('users').doc(id).get().then((snapshot) => {res = snapshot.data()!['numQuizzes']});
  return res;
}

Future<int> getNumPerfectQuizzes() async {
  String id = await api.getIdUser(http.Client());
  int res = -1;
  await db.collection('users').doc(id).get().then((snapshot) => {res = snapshot.data()!['numPerfectQuizzes']});
  return res;
}

Future getUserData() async {
  String id = await api.getIdUser(http.Client());
  dynamic res = -1;
  await db.collection('users').doc(id).get().then((snapshot) {
    res = snapshot.data();
    res["avgScore"] = (res["totalScore"] / res["numQuizzes"]).toStringAsPrecision(3);
  });
  return res;
}

Future<List> getLeaderboard() async {
  List<Object> res = [];
  await db.collection('users').orderBy('totalScore', descending: true).get().then((snapshot) => snapshot.docs.forEach((element) {
        //print(element.reference);
        res.add(element);
      }));
  return res;
}

Future<int> getPosUser() async {
  String id = await api.getIdUser(http.Client());
  List<Object> res = [];
  var doc = await db.collection('users').doc(id).get().then((DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    await db
        .collection('users')
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

Future<List> getMKArtist() async {
  String id = await api.getIdUser(http.Client());
  List<Object> res = [];
  await db
      .collection('users')
      .doc(id)
      .collection('authors')
      .orderBy(
        'questionsCorrect',
        descending: true,
      )
      .limit(3)
      .get()
      .then((snapshot) => snapshot.docs.forEach((element) async {
            //print(element.reference);
            res.add(await api.getNameOfArtist(http.Client(), element as String));
          }));
  while (res.length < 3) res.add('');

  return res;
}
