import 'package:flutter/material.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/main_page.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/MyStorage.dart';

// Create storage

Future main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotiquiz',
      home: const MainPage(),
    );
  }
}
