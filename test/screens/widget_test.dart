// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/screens/main_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/screens/navigation.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:http/http.dart' as http;

Widget buildTestableWidget(Widget widget, NavigatorObserver obv) {
  return MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        home: widget,
        navigatorObservers: [obv],
      ));
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MocksAPI extends Mock implements API {}

class MockAuth extends Mock implements Auth {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setupFirebaseAuthMocks();
  final MockHttpClient mockHttpClient = MockHttpClient();
  setUpAll(() async {
    await Firebase.initializeApp();
    registerFallbackValue(mockHttpClient);
  });
  testWidgets('Login Page', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    final mockAuth = MockAuth();

    await tester.runAsync(() async {
      await mockNetworkImagesFor(
        () async {
          await tester.pumpWidget(buildTestableWidget(Login(spotiauth: mockAuth), mockObserver));
          expect(find.byType(Text), findsWidgets);
          expect(find.byType(InkWell), findsWidgets);
          expect(find.byType(Image), findsWidgets);
          //verify(() => mockAuth.login()).called(1);

          /// Verify that a push event happened
        },
      );
    });
  });

  testWidgets('Login action', (WidgetTester tester) async {
    final mockAuth = MockAuth();
    final mockObserver = MockNavigatorObserver();
    await mockNetworkImagesFor(() async {
      await tester.runAsync(() async {
        await tester.pumpWidget(buildTestableWidget(Login(spotiauth: mockAuth), mockObserver));
        await tester.pumpAndSettle();
        when(() => mockAuth.login(any())).thenAnswer((((realInvocation) => Future.value(true))));
        await tester.tap(find.byType(InkWell));
        await tester.pump();
        //expect(find.byType(CircularProgressIndicator), findsWidgets);
      });
    });
  });
}
