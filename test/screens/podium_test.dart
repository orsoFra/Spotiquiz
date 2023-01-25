import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: Scaffold(body: widget)));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AsyncSnapshot snapshot = AsyncSnapshot.withData(ConnectionState.done, [
    {'name': 'One', 'totalScore': 100},
    {'name': 'Two', 'totalScore': 50},
    {'name': 'Three', 'totalScore': 20}
  ]);

  testWidgets('test podium', (tester) async {
    await tester.pumpWidget(buildTestableWidget(Podium(snapshot: snapshot, queryData: MediaQueryData(), portrait: true)));
    await tester.pumpAndSettle();
    expect(find.byType(Container), findsWidgets);
    expect(find.byType(Row), findsOneWidget);
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
    expect(find.text('100 points'), findsOneWidget);
    expect(find.text('50 points'), findsOneWidget);
    expect(find.text('20 points'), findsOneWidget);
  });
}
