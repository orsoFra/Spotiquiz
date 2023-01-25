import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/card.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/homepage_tablet.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: const MediaQueryData(), child: MaterialApp(home: widget));
}

class MockQAPI extends Mock implements QuestionAPI {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockQAPI mocksQAPI = MockQAPI();
  MockHttpClient mockHttpClient = MockHttpClient();

  testWidgets('testHomepageSwiper', (tester) async {
    await tester.runAsync(() async {
      when(() => mocksQAPI.generateHomeSuggestions(any())).thenAnswer((invocation) async => ['RANDOM', 'SILENT', 'LISTENING']);

      await tester.pumpWidget(buildTestableWidget(MyHomePage.test(
        title: 'Test',
        qa: mocksQAPI,
      )));
      await tester.pump();
      verify((() => mocksQAPI.generateHomeSuggestions(any()))).called(1);
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
      expect(find.text('Welcome Back'), findsWidgets);
      expect(find.byType(Swiper), findsWidgets);
      expect(find.descendant(of: find.byType(Swiper), matching: find.byType(SliderCard)), findsWidgets);
      //verify((() => mocksQAPI.generateHomeSuggestions(http.Client()))).called(1);
    });
  });

  testWidgets('testHomepageSwiperEmpty', (tester) async {
    await tester.runAsync(() async {
      when(() => mocksQAPI.generateHomeSuggestions(any())).thenAnswer((invocation) async => Future.value([]));
      await tester.pumpWidget(buildTestableWidget(MyHomePage.test(
        title: 'Test',
        qa: mocksQAPI,
      )));
      verify((() => mocksQAPI.generateHomeSuggestions(any()))).called(1);

      expect(find.byType(Text), findsWidgets);
      expect(find.text('Welcome Back'), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.byType(Swiper), findsNothing);
      await tester.pumpAndSettle();
      expect(find.text('No quizzes?'), findsWidgets);

      //verify((() => mocksQAPI.generateHomeSuggestions(mockHttpClient))).called(1);
    });
  });

  testWidgets('testHomepageTablet', (tester) async {
    await tester.runAsync(() async {
      when(() => mocksQAPI.generateHomeSuggestions(any())).thenAnswer((invocation) async => ['RANDOM', 'SILENT', 'LISTENING']);

      await tester.pumpWidget(buildTestableWidget(HomeTablet.test(
        qA: mocksQAPI,
      )));
      await tester.pump();
      verify((() => mocksQAPI.generateHomeSuggestions(any()))).called(1);
      await tester.pumpAndSettle();
      expect(find.byType(Text), findsWidgets);
      expect(find.text('Welcome Back'), findsWidgets);
      expect(find.byType(Swiper), findsWidgets);
      expect(find.descendant(of: find.byType(Swiper), matching: find.byType(SliderCard)), findsWidgets);
      expect(find.text('YOUR PROFILE'), findsWidgets);
      expect(find.text('LEADERBOARD'), findsWidgets);
      //verify((() => mocksQAPI.generateHomeSuggestions(http.Client()))).called(1);
    });
  });
}
