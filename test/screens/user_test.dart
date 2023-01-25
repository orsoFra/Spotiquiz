import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/models/card.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/services/questionApi.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

class MockAPI extends Mock implements API {}

class MockData extends Mock implements Data {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  MockAPI mockAPI = MockAPI();
  MockData mocksD = MockData();
  MockHttpClient mockHttpClient = MockHttpClient();
  registerFallbackValue(mockHttpClient);

  // test the image of profile
  testWidgets('testUserAvatar', (tester) async {
    await mockNetworkImagesFor(
      () async {
        await tester.runAsync(() async {
          when(() => mockAPI.getInfoUser(any())).thenAnswer((invocation) => Future.value(
                {'imageUrl': '', 'display_name': 'flutterproject', 'email': 'flutterproject@gmail.com', 'product': 'premium'},
              ));
          when(() => mocksD.getUserData()).thenAnswer((invocation) => Future.value({'name': 'flutter', 'numPerfectQuizzes': 1, 'numQuizzes': 1, 'totalScore': 1, 'avgScore': 1}));
          await tester.pumpWidget(buildTestableWidget(UserPage.test(
            dA: mocksD,
            api: mockAPI,
          )));

          verify(() => mockAPI.getInfoUser(any())).called(1);
          verify(() => mocksD.getUserData()).called(1);
          await tester.pumpAndSettle();
          expectLater(find.byType(CircleAvatar), findsWidgets);
          //expect(find.byType(Text), findsWidgets);
          /*await tester.pumpAndSettle();
          */
          //expect(find.byType(CircularProgressIndicator), findsOneWidget);

          // TODO: why hasData is never true?

          // expectLater(find.byType(NetworkImage), findsOneWidget);
          //await tester.timedDrag(find.byType(CircularProgressIndicator), Offset.fromDirection(0.5), Duration(seconds: 1));
        });
      },
    );
  });

  testWidgets('test userInfo', (tester) async {
    await mockNetworkImagesFor(
      () async {
        await tester.runAsync(() async {
          when(() => mockAPI.getInfoUser(any())).thenAnswer((invocation) => Future.value(
                {'imageUrl': '', 'display_name': 'flutterproject', 'email': 'flutterproject@gmail.com', 'product': 'premium'},
              ));
          when(() => mocksD.getUserData()).thenAnswer((invocation) => Future.value({'name': 'flutter', 'numPerfectQuizzes': 1, 'numQuizzes': 1, 'totalScore': 1, 'avgScore': 1}));
          await tester.pumpWidget(buildTestableWidget(UserPage.test(
            dA: mocksD,
            api: mockAPI,
          )));

          verify(() => mockAPI.getInfoUser(any())).called(1);
          verify(() => mocksD.getUserData()).called(1);
          await tester.pumpAndSettle();
          expect(find.text('flutterproject'), findsWidgets);
          expect(find.text('flutterproject@gmail.com'), findsWidgets);
          expect(find.text('premium user '), findsWidgets);
        });
      },
    );
  });

  testWidgets('test user stats', (tester) async {
    await mockNetworkImagesFor(
      () async {
        await tester.runAsync(() async {
          when(() => mockAPI.getInfoUser(any())).thenAnswer((invocation) => Future.value(
                {'imageUrl': '', 'display_name': 'flutterproject', 'email': 'flutterproject@gmail.com', 'product': 'premium'},
              ));
          when(() => mocksD.getUserData())
              .thenAnswer((invocation) => Future.value({'name': 'flutter', 'numPerfectQuizzes': 1, 'numQuizzes': 10, 'totalScore': 100, 'avgScore': 6}));
          await tester.pumpWidget(buildTestableWidget(UserPage.test(
            dA: mocksD,
            api: mockAPI,
          )));

          verify(() => mockAPI.getInfoUser(any())).called(1);
          verify(() => mocksD.getUserData()).called(1);
          await tester.pumpAndSettle();
          expect(find.text('Completed'), findsWidgets);
          expect(find.text('Perfect'), findsWidgets);
          expect(find.text('Score'), findsWidgets);
          expect(find.text('Average'), findsWidgets);
          expect(find.text('10'), findsWidgets);
          expect(find.text('100'), findsWidgets);
          expect(find.text('1'), findsWidgets);
          expect(find.text('6'), findsWidgets);
        });
      },
    );
  });

  testWidgets('test Icons', (tester) async {
    await mockNetworkImagesFor(
      () async {
        await tester.runAsync(() async {
          when(() => mockAPI.getInfoUser(any())).thenAnswer((invocation) => Future.value(
                {'imageUrl': '', 'display_name': 'flutterproject', 'email': 'flutterproject@gmail.com', 'product': 'premium'},
              ));
          when(() => mocksD.getUserData()).thenAnswer((invocation) => Future.value({'name': 'flutter', 'numPerfectQuizzes': 1, 'numQuizzes': 1, 'totalScore': 1, 'avgScore': 1}));
          await tester.pumpWidget(buildTestableWidget(UserPage.test(
            dA: mocksD,
            api: mockAPI,
          )));

          verify(() => mockAPI.getInfoUser(any())).called(1);
          verify(() => mocksD.getUserData()).called(1);
          await tester.pumpAndSettle();
          expect(find.byIcon(Icons.done), findsWidgets);
          expect(find.byIcon(Icons.star_rate), findsWidgets);
          expect(find.byIcon(Icons.emoji_events), findsWidgets);
          expect(find.byIcon(Icons.bar_chart), findsWidgets);
          expect(find.byIcon(Icons.settings), findsWidgets);
        });
      },
    );
  });

  //TESTING GRID of USERpage
  testWidgets('test grid', (tester) async {
    await mockNetworkImagesFor(
      () async {
        await tester.runAsync(() async {
          when(() => mockAPI.getInfoUser(any())).thenAnswer((invocation) => Future.value(
                {'imageUrl': '', 'display_name': 'flutterproject', 'email': 'flutterproject@gmail.com', 'product': 'premium'},
              ));
          when(() => mocksD.getUserData()).thenAnswer((invocation) => Future.value({'name': 'flutter', 'numPerfectQuizzes': 1, 'numQuizzes': 1, 'totalScore': 1, 'avgScore': 1}));
          await tester.pumpWidget(buildTestableWidget(Grid(
            queryData: MediaQueryData(),
            imgSize: 10,
            txtSize: 10,
            tabFactor: 1,
            api: mockAPI,
            dApi: mocksD,
          )));

          await tester.pumpAndSettle();
          verify(() => mockAPI.getInfoUser(any())).called(1);
          verify(() => mocksD.getUserData()).called(1);
          expect(find.byType(GridView), findsWidgets);
        });
      },
    );
  });
}
