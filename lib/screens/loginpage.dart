import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool loginZ() {
    final spotiauth = Auth();
    spotiauth.login();
    print('Promp login');
    return true;
    //accesstoken = await storage.read(key: 'acces_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 65, 91),
      body: Center(
        child: Column(
          children: [
            const Padding(padding: const EdgeInsets.symmetric(vertical: 40)),
            Container(
                height: 150,
                child: Image.network(
                  "https://i.pinimg.com/originals/b7/8d/e5/b78de50ead1fe734e86da657e6ef804a.jpg",
                  fit: BoxFit.fill,
                )),
            Container(
              width: 200,
              height: 150,
              child: const Center(
                  child: Text(
                "Login with Spotfiy",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
            ),
            const Padding(padding: const EdgeInsets.symmetric(vertical: 10)),
            MaterialButton(
              onPressed: (() {
                if (loginZ())
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            title: 'home',
                          )));
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
          ],
        ),
      ),
    );
  }
}
