import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotiquiz/firebase_options.dart';
import 'package:spotiquiz/main.dart';


addDelay(int millis) async {
  await Future.delayed(Duration(milliseconds: millis));
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // fullyLive ensures that every frame is shown, suitable for heavy animations and navigation
  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  testWidgets("Test to Check the Complete app flow", (tester) async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    addDelay(2000);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Leaderboard')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('Podium')), findsWidgets);
    await tester.pumpAndSettle();
    addDelay(3000);
  });
}
