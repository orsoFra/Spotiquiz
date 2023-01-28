import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/services/data.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

class MockData extends Mock implements Data {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockData mocksD = MockData();
  testWidgets('testleaderboard', (widgetTester) async {
    when(() => mocksD.getLeaderboard()).thenAnswer((invocation) => Future.value([
          {'name': 'One', 'totalScore': 100},
          {'name': 'Two', 'totalScore': 50},
          {'name': 'Three', 'totalScore': 20}
        ]));
    when(() => mocksD.getPosUser()).thenAnswer((invocation) => Future.value(1));
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(Leaderboard.test(
        dA: mocksD,
      )));
      await widgetTester.pumpAndSettle();
      expect(find.byType(Podium), findsWidgets);
      expect(find.text('One'), findsNWidgets(2));
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
      expect(find.text('100 points'), findsNWidgets(2));
      expect(find.text('50 points'), findsOneWidget);
      expect(find.text('20 points'), findsOneWidget);
    });
  });

  testWidgets('testleaderboard portrait', (widgetTester) async {
    widgetTester.binding.window.physicalSizeTestValue = Size(42, 72);

    // resets the screen to its original size after the test end
    addTearDown(widgetTester.binding.window.clearPhysicalSizeTestValue);
    when(() => mocksD.getLeaderboard()).thenAnswer((invocation) => Future.value([
          {'name': 'One', 'totalScore': 100},
          {'name': 'Two', 'totalScore': 50},
          {'name': 'Three', 'totalScore': 20}
        ]));
    when(() => mocksD.getPosUser()).thenAnswer((invocation) => Future.value(1));
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(Leaderboard.test(
        dA: mocksD,
      )));
      await widgetTester.pumpAndSettle();
      expect(find.byType(Podium), findsWidgets);
      expect(find.text('One'), findsNWidgets(2));
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
      expect(find.text('100 points'), findsNWidgets(2));
      expect(find.text('50 points'), findsOneWidget);
      expect(find.text('20 points'), findsOneWidget);
    });
  });
}
