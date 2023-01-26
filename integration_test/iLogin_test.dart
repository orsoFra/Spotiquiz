import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotiquiz/firebase_options.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/main.dart' as app;

addDelay(int millis) async {
  await Future.delayed(Duration(milliseconds: millis));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test to Check the Complete app flow", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    app.main();
    await tester.pumpAndSettle();
    addDelay(2000);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Person')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('Podium')), findsWidgets);
    await tester.pumpAndSettle();
    addDelay(3000);
  });
}
