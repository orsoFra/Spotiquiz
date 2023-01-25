import 'dart:ffi';

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/card.dart';
import 'package:spotiquiz/models/question_model.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

class MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  final MockStorage mS = MockStorage();
  test('test class quesitonmodel', () {
    final QuestionModel q = QuestionModel('are you ok?', ['no', 'yes', 'maybe'], 0);

    expect(q.question, 'are you ok?');
    expect(q.answers, ['no', 'yes', 'maybe']);
    expect(q.correctAnswer, 0);
  });

  test('test class MyStorage', (() {
    final MyStorage s = MyStorage(mS);
    when(() => mS.read(key: any(named: 'key'))).thenAnswer((invocation) => Future.value('response'));
    when(() => mS.write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((invocation) => Future.value());
    s.saveToken('aaa');
    s.read(key: 'token');
  }));
}
