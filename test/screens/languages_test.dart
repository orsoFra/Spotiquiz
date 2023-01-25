import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/screens/languages.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/services/data.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

class MockData extends Mock implements Data {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('testleaderboard', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(LanguagesPage()));
      await widgetTester.pumpAndSettle();

      expect(find.text('Only English currently supported'), findsNWidgets(1));
    });
  });
}
