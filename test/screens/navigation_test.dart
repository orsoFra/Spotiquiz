import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/screens/navigation.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: const MediaQueryData(), child: MaterialApp(home: widget));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('testNavbar home', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const Navigation()));
      await widgetTester.pump();
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(Leaderboard), findsOneWidget);
      expect(find.byType(UserPage), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
    });
  });

  testWidgets('testNavbar change page leaderboard', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const Navigation()));
      await widgetTester.pump();
      expect(find.byType(IndexedStack), findsOneWidget);
      IndexedStack stack = widgetTester.widget(find.byType(IndexedStack));
      expect(stack.index, 1);
      await widgetTester.tap(find.descendant(of: find.byType(GButton), matching: find.byIcon(Icons.leaderboard)));
      await widgetTester.pump();
      IndexedStack stack2 = widgetTester.widget(find.byType(IndexedStack));
      expect(stack2.index, 0);
    });
  });
  testWidgets('testNavbar change page user', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const Navigation()));
      await widgetTester.pump();
      expect(find.byType(IndexedStack), findsOneWidget);
      IndexedStack stack = widgetTester.widget(find.byType(IndexedStack));
      expect(stack.index, 1);
      await widgetTester.tap(find.descendant(of: find.byType(GButton), matching: find.byIcon(Icons.person)));
      await widgetTester.pump();
      IndexedStack stack2 = widgetTester.widget(find.byType(IndexedStack));
      expect(stack2.index, 2);
    });
  });
}
