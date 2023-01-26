import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/screens/navigation.dart';
import 'package:spotiquiz/screens/settings.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotiquiz/services/firebase_test_service.dart';
import 'package:spotiquiz/widgets/policy_conditions_dialog.dart';

Widget buildTestableWidget(Widget widget) {
  return MediaQuery(data: const MediaQueryData(), child: MaterialApp(home: widget));
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('test sections text', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
      await widgetTester.pump();
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Policy & Conditions'), findsOneWidget);
      expect(find.text('Feedback'), findsOneWidget);
    });
  });

  testWidgets('test icon', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
      await widgetTester.pump();
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byIcon(Icons.account_balance), findsOneWidget);
      expect(find.byIcon(Icons.policy), findsOneWidget);
      expect(find.byIcon(Icons.bug_report), findsOneWidget);
      expect(find.byIcon(Icons.feedback), findsOneWidget);
    });
  });

  // non torna da rivedere

  testWidgets('test logout button action', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await mockNetworkImagesFor(() async {
        await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
        await widgetTester.pump();
        expect(find.text('Logout'), findsOneWidget);
        await widgetTester.tap(find.text('Logout'));
        await widgetTester.pumpAndSettle();
      });
      expect(find.text('Login with Spotify'), findsOneWidget);
    });
  });

  testWidgets('test alert dialog when we click on Terms of Service', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
      await widgetTester.pump();
      var button = find.text('Terms of Service');
      await widgetTester.tap(button);
      await widgetTester.pump();
      expect(find.byType(PolicyConditionsDialog), findsOneWidget);
    });
  });

  testWidgets('test alert dialog when we click on Privacy Policy', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
      await widgetTester.pump();
      var button = find.text('Privacy Policy');
      await widgetTester.tap(button);
      await widgetTester.pump();
      expect(find.byType(PolicyConditionsDialog), findsOneWidget);
    });
  });

  testWidgets('test the input text dialog when we click on Report a bug', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
      await widgetTester.pump();
      var button = find.text('Report A Bug');
      await widgetTester.tap(button);
      await widgetTester.pump();
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  // non torna
  /*
  testWidgets('test the input text dialog when we click on Send a feedback', (widgetTester) async {
    await widgetTester.runAsync(() async {
      await widgetTester.pumpWidget(buildTestableWidget(const SettingPage()));
      await widgetTester.pump();
      //var button = find.text('Send Feedback');
      await widgetTester.ensureVisible(find.text('Send Feedback'));
      await widgetTester.tap(find.text('Send Feedback'));
      await widgetTester.pumpAndSettle();
      expect(find.byType(RatingDialog), findsOneWidget);
    });
  });
   */

}
