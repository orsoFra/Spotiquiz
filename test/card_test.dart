import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/card.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: Scaffold(body: widget)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('testCard', (tester) async {
    await tester.pumpWidget(buildTestableWidget(SliderCard(cols: [
      Color.fromARGB(255, 128, 5, 195),
      Color.fromARGB(255, 182, 80, 245),
    ], icon: Icons.question_mark_rounded, text: 'RANDOM QUIZ', isListening: 0)));
    await tester.pumpAndSettle();
    expect(find.text('RANDOM QUIZ'), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });

  testWidgets('cardInk', (tester) async {
    await tester.pumpWidget(buildTestableWidget(SliderCard(
        key: Key('card'),
        cols: [
          Color.fromARGB(255, 128, 5, 195),
          Color.fromARGB(255, 182, 80, 245),
        ],
        icon: Icons.question_mark_rounded,
        text: 'RANDOM QUIZ',
        isListening: 0)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('RANDOM QUIZ')));
    await tester.pumpAndSettle();
    expect(find.byType(Container), findsOneWidget);

    //expect(find.textContaining('Question'), findsOneWidget);
  });
  testWidgets('cardbutton', (tester) async {
    await tester.pumpWidget(buildTestableWidget(SliderCard(
        key: Key('card'),
        cols: [
          Color.fromARGB(255, 128, 5, 195),
          Color.fromARGB(255, 182, 80, 245),
        ],
        icon: Icons.question_mark_rounded,
        text: 'RANDOM QUIZ',
        isListening: 0)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('RANDOM QUIZbutton')));
    await tester.pumpAndSettle();
    expect(find.byType(Container), findsOneWidget);

    //expect(find.textContaining('Question'), findsOneWidget);
  });
}
