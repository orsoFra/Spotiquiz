import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotiquiz/firebase_options.dart';
import 'package:spotiquiz/main_test.dart' as app;
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/widgets/policy_conditions_dialog.dart';

addDelay(int millis) async {
  await Future.delayed(Duration(milliseconds: millis));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test to Check the homepage", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    expect(find.textContaining('RANDOM'), findsWidgets);
    expect(find.textContaining('LISTENING'), findsWidgets);
    expect(find.textContaining('SILENT'), findsWidgets);

    //await addDelay(2000);
  });

  testWidgets("Test to Check the leaderboard", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    expect(find.textContaining('RANDOM'), findsWidgets);
    expect(find.textContaining('LISTENING'), findsWidgets);
    expect(find.textContaining('SILENT'), findsWidgets);
    await tester.tap(find.byKey(const Key('Leaderboard')));
    await tester.pump(Duration(seconds: 4));
    expect(find.byType(Podium), findsWidgets);
    expect(find.byType(Container), findsWidgets);
    //await addDelay(2000);
  });

  testWidgets("Test to Check the Userpage", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    expect(find.textContaining('RANDOM'), findsWidgets);
    expect(find.textContaining('LISTENING'), findsWidgets);
    expect(find.textContaining('SILENT'), findsWidgets);
    await tester.tap(find.byKey(const Key('Person')));

    await tester.pumpAndSettle();
    expect(find.byType(CircleAvatar), findsWidgets);
    //await addDelay(2000);
  });

  testWidgets("Test to swipe quizzes", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    expect(find.textContaining('RANDOM'), findsWidgets);
    expect(find.textContaining('LISTENING'), findsWidgets);
    expect(find.textContaining('SILENT'), findsWidgets);
    await tester.drag(find.byType(Swiper), Offset(500.0, 1));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Swiper), Offset(500.0, 1));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Swiper), Offset(500.0, 1));
    //await addDelay(2000);
  });

  testWidgets("Test to start quizzes and quit", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Swiper));
    await tester.pump(Duration(seconds: 5));
    //await addDelay(1000);
    await tester.tap(find.text('Quit'));
    await tester.pumpAndSettle();
    //await addDelay(2000);
  });

  testWidgets("Test to start quiz and go on", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Swiper));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.tap(find.byKey(Key('0')));
    await tester.pump(Duration(seconds: 5));
    await tester.pumpAndSettle();
    //await addDelay(2000);
  });

  testWidgets("Test to access settings", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Person')));
    await tester.pumpAndSettle();
    expect(find.byType(CircleAvatar), findsWidgets);
    await addDelay(2000);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
  });

  testWidgets("Test to languages", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Person')));

    await tester.pumpAndSettle();
    expect(find.byType(CircleAvatar), findsWidgets);
    await addDelay(2000);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Language'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Only English currently supported'), findsWidgets);
  });

  testWidgets("Test to terms and conditions", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Person')));

    await tester.pumpAndSettle();
    expect(find.byType(CircleAvatar), findsWidgets);
    await addDelay(2000);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Terms of Service'));
    await tester.pumpAndSettle();
    expect(find.byType(PolicyConditionsDialog), findsWidgets);
  });

  testWidgets("Test to logout", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Person')));

    await tester.pumpAndSettle();
    expect(find.byType(CircleAvatar), findsWidgets);
    await addDelay(2000);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Logout'));
    await tester.pumpAndSettle();
  });
}
