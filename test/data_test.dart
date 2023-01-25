import 'dart:convert';

//import 'dart:html';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

//import 'package:test/expect.dart';
//import 'package:test/test.dart';

void cannotBeNull(dynamic param) {
  assert(param != null);
}

class MockHttpClient extends Mock implements http.Client {}

class MocksAPI extends Mock implements API {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final MocksAPI mocksAPI = MocksAPI();
  MockHttpClient mockHttpClient = MockHttpClient();
  registerFallbackValue(mockHttpClient);

  final FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();

  //set up the firestore instance and mock methods
  when(() => mocksAPI.getIdUser(any())).thenAnswer((invocation) => Future.value('21q4wwalokcky25op74guvjcq'));
  when(() => mocksAPI.getNameOfUser(any(), '21q4wwalokcky25op74guvjcq')).thenAnswer((invocation) => Future.value('F C'));
  const Map<String, dynamic> userData = {'id': '21q4wwalokcky25op74guvjcq', 'name': 'Francesco Corso', 'numPerfectQuizzes': 5, 'numQuizzes': 46, 'totalScore': 333};
  const Map<String, dynamic> userDataTwo = {'id': 'asd', 'name': 'name2', 'numPerfectQuizzes': 0, 'numQuizzes': 16, 'totalScore': 123};
  const Map<String, dynamic> userDataThree = {'id': 'qwerty', 'name': 'name3', 'numPerfectQuizzes': 1, 'numQuizzes': 13, 'totalScore': 130};
  await fakeFirebaseFirestore.collection('users').doc('21q4wwalokcky25op74guvjcq').set(userData);
  await fakeFirebaseFirestore.collection('users').doc('asd').set(userDataTwo);
  await fakeFirebaseFirestore.collection('users').doc('qwerty').set(userDataThree);
  fakeFirebaseFirestore.collection("quizzes").add({'date': Timestamp.now(), 'points': 10, 'user': '21q4wwalokcky25op74guvjcq'});
  fakeFirebaseFirestore.collection('feedbacks').add({'date': Timestamp.now(), 'user': '21q4wwalokcky25op74guvjcq', 'rating': 3, 'feedback': 'lol'});

  final data = Data.test(appi: mocksAPI, ff: fakeFirebaseFirestore);

  group('test getter methods', () {
    test('getLeaderboard length', () async {
      List<dynamic> res = [];
      res = await data.getLeaderboard();
      assert(res.length == 3);
    });

    test('get num quizzes', () async {
      var res;
      res = await data.getNumQuizzes();
      assert(res == 46);
    });

    test('get num perfect quizzes', () async {
      var res;
      res = await data.getNumPerfectQuizzes();
      assert(res == 5);
    });

    test('get pos user', () async {
      var res;
      res = await data.getPosUser();
      assert(res == 1);
    });

    test('get userdata', () async {
      var res = await data.getUserData();
      expect(res, {'id': '21q4wwalokcky25op74guvjcq', 'name': 'Francesco Corso', 'numPerfectQuizzes': 5, 'numQuizzes': 46, 'totalScore': 333, 'avgScore': '7.24'});
    });
  });

  group('test setter methods', (() {
    test('store results', () async {
      await data.storeResults(1);
      verify(() => mocksAPI.getIdUser(any())).called(greaterThan(0));
      verify(() => mocksAPI.getNameOfUser(any(), '21q4wwalokcky25op74guvjcq')).called(greaterThan(0));
      var snaps = await fakeFirebaseFirestore.collection('quizzes').get();
      var snapsU = await fakeFirebaseFirestore.collection('users').doc('21q4wwalokcky25op74guvjcq').get();
      var num = snaps.docs.toList();
      var nm = snapsU.data();
      //print(num);
      assert(num.length > 1);
    });

    test('store feedbacks', (() async {
      await data.storeFeedbacks(3, 'feedback');
      verify(() => mocksAPI.getIdUser(any())).called(greaterThan(0));
      var snaps = await fakeFirebaseFirestore.collection('feedbacks').get();
      var num = snaps.docs.toList();
      assert(num.length > 1);
    }));

    test('store bugs', (() async {
      await data.storeBugs('comment');
      verify(() => mocksAPI.getIdUser(any())).called(greaterThan(0));
      var snaps = await fakeFirebaseFirestore.collection('bugs').get();
      var num = snaps.docs.toList();
      assert(num.length > 0);
    }));
  }));
}
