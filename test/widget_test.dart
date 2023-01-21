// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/screens/main_page.dart';
import 'package:mockito/mockito.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/services/auth.dart';
import 'widget_test.mocks.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockStorage extends Mock implements IStorage {}

class MocksAPI extends Mock implements API {}

@GenerateMocks([Auth])
void main() {
  testWidgets('Login Page', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    final mockAuth = MockAuth();
    // Build our app and trigger a frame
    //await tester.pumpWidget(const MyApp());

    await tester.runAsync(() async {
      await mockNetworkImagesFor(
        () async {
          await tester.pumpWidget(buildTestableWidget(Login(
            spotiauth: mockAuth,
          )));
          expect(find.byType(Text), findsWidgets);
          expect(find.byType(InkWell), findsWidgets);
          expect(find.byType(Image), findsWidgets);
          //verify(() => mockAuth.login()).called(1);

          /// Verify that a push event happened
        },
      );
    });

    /*
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);*/
  });

  testWidgets('Login action', (WidgetTester tester) async {
    final mockAuth = MockAuth();
    when(() => mockAuth.login()).thenAnswer((((realInvocation) => (() => Future.value(true)))));
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();
  });
}
