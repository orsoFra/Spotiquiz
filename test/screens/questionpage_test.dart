import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/question_model.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/widgets/progress_bar.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

class MockAPI extends Mock implements API {}

class MockData extends Mock implements Data {}

class MockMyStorage extends Mock implements MyStorage {}

class MockQuestionApi extends Mock implements QuestionAPI {}

class MockHttpClient extends Mock implements http.Client {}

class MockAudioPlayer extends Mock implements AssetsAudioPlayer {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();
  MockMyStorage mockMyStorage = MockMyStorage();
  MockAPI mockAPI = MockAPI();
  MockData mockData = MockData();
  MockData mocksD = MockData();
  MockQuestionApi mockQuestionApi = MockQuestionApi();
  MockAudioPlayer mockAudioPlayer = MockAudioPlayer();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  MockHttpClient mockHttpClient = MockHttpClient();
  registerFallbackValue(mockHttpClient);
  when(() => mockAudioPlayer.pause()).thenAnswer((invocation) => Future.value());

  testWidgets('test question page no listening', ((widgetTester) async {
    when(() => mockQuestionApi.generateNonListeningQuestions(any(), 10)).thenAnswer((invocation) => [
          Future.value(QuestionModel('question1', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question2', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question3', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question4', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question5', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question6', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question7', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question8', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question9', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question10', ['ans1', 'ans2', 'ans3', 'ans4'], 0))
        ]);

    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(TickerMode(
        child: buildTestableWidget(QuestionPage.test(
          isL: 2,
          ms: mockMyStorage,
          a: mockAPI,
          qA: mockQuestionApi,
          dA: mockData,
          isT: true,
          aap: mockAudioPlayer,
        )),
        enabled: false,
      ));
      verify(() => mockQuestionApi.generateNonListeningQuestions(any(), 10)).called(1);
      await widgetTester.pump(Duration(seconds: 4));
      expect(find.byType(ProgressBar), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
      expect(find.text('ans1'), findsOneWidget);
      expect(find.text('ans2'), findsOneWidget);
      expect(find.text('ans3'), findsOneWidget);
      expect(find.text('ans4'), findsOneWidget);
      expect(find.text('question1'), findsOneWidget);
      expect(find.text('Quit'), findsOneWidget);
    });
  }));
  testWidgets('test question page  listening', ((widgetTester) async {
    when(() => mockQuestionApi.generateListeningQuestions(any(), 10)).thenAnswer((invocation) => [
          Future.value(QuestionModel('question1', ['ans1', 'ans2', 'ans3', 'ans4'], 0, 'url')),
          Future.value(QuestionModel('question2', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question3', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question4', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question5', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question6', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question7', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question8', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question9', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question10', ['ans1', 'ans2', 'ans3', 'ans4'], 0))
        ]);

    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(TickerMode(
        child: buildTestableWidget(QuestionPage.test(
          isL: 1,
          ms: mockMyStorage,
          a: mockAPI,
          qA: mockQuestionApi,
          dA: mockData,
          isT: true,
          aap: mockAudioPlayer,
        )),
        enabled: false,
      ));
      verify(() => mockQuestionApi.generateListeningQuestions(any(), 10)).called(1);
      await widgetTester.pump(Duration(seconds: 4));
      expect(find.byType(ProgressBar), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
      expect(find.text('ans1'), findsOneWidget);
      expect(find.text('ans2'), findsOneWidget);
      expect(find.text('ans3'), findsOneWidget);
      expect(find.text('ans4'), findsOneWidget);
      expect(find.text('question1'), findsOneWidget);
      expect(find.text('Quit'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });
  }));
  testWidgets('test question page tap on quit', ((widgetTester) async {
    when(() => mockQuestionApi.generateListeningQuestions(any(), 10)).thenAnswer((invocation) => [
          Future.value(QuestionModel('question1', ['ans1', 'ans2', 'ans3', 'ans4'], 0, 'url')),
          Future.value(QuestionModel('question2', ['ans1', 'ans2', 'ans3', 'ans4'], 0, 'url')),
          Future.value(QuestionModel('question3', ['ans1', 'ans2', 'ans3', 'ans4'], 0, 'url')),
          Future.value(QuestionModel('question4', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question5', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question6', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question7', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question8', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question9', ['ans1', 'ans2', 'ans3', 'ans4'], 0)),
          Future.value(QuestionModel('question10', ['ans1', 'ans2', 'ans3', 'ans4'], 0))
        ]);

    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(TickerMode(
        child: buildTestableWidget(QuestionPage.test(
          isL: 1,
          ms: mockMyStorage,
          a: mockAPI,
          qA: mockQuestionApi,
          dA: mockData,
          isT: true,
          aap: mockAudioPlayer,
        )),
        enabled: false,
      ));
      verify(() => mockQuestionApi.generateListeningQuestions(any(), 10)).called(1);
      await widgetTester.pump(Duration(seconds: 4));
      expect(find.text('Quit'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      await widgetTester.pump(Duration(seconds: 1));
      await widgetTester.tap(find.byType(TextButton));
      await widgetTester.pump(Duration(seconds: 10));
      expect(find.text('ans1'), findsOneWidget);
      expect(find.text('ans2'), findsOneWidget);
      expect(find.text('ans3'), findsOneWidget);
      expect(find.text('ans4'), findsOneWidget);
    });
  }));
}
