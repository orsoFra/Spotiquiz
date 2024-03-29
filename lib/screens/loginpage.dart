import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/services/auth.dart';
import 'navigation.dart';

class Login extends StatelessWidget {
  const Login({super.key, required this.spotiauth});
  final Auth spotiauth;

  Future<bool> loginZ() async {
    bool result = await spotiauth.login(http.Client());
    print('Prompt login' + result.toString());
    return result;
    //accesstoken = await storage.read(key: 'acces_token');
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 20, 20),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: queryData.size.height * 0.1)),
            Container(
                height: 200,
                child: const Image(image: AssetImage('assets/img/start_screen-transformed.png'))
            ),
            Container(
              height: 150,
              child: const Center(
                  child: Text(
                "Login with Spotify",
                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
            const Padding(padding: const EdgeInsets.symmetric(vertical: 20)),
            InkWell(
              onTap: () async {
                if (await loginZ()) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Navigation()));
              },
              child: Container(
                height: queryData.size.height * 0.08,
                width: queryData.size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 128, 5, 195),
                      Color.fromARGB(255, 182, 80, 245),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            /*MaterialButton(
              onPressed: (() {
                if (loginZ()) Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
              }),
              color: Color.fromARGB(255, 24, 74, 255),
              minWidth: 300,
              height: 40,
              textColor: Colors.white,
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}
