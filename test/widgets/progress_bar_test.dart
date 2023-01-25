import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/controllers/question_controller.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/card.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/questionpage.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/widgets/progress_bar.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: Scaffold(body: widget)));
}

class MockQController extends Mock implements QuestionController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();
  final MockQController mockQController = MockQController();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('test progress bar', ((widgetTester) async {
    await widgetTester.pumpWidget(buildTestableWidget(ProgressBar(questionController: mockQController)));
    await widgetTester.pump(Duration(seconds: 1));
    expect(find.byType(Stack), findsWidgets);
    expect(find.byType(Positioned), findsWidgets);
    expect(find.byType(Container), findsWidgets);
  }));
}
