import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
const sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);
final autha = Auth();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotiquiz',
      home: MainPage(
        auth: autha,
        api: api,
        storage: storage,
      ),
    );
  }
}
