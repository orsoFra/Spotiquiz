import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:spotiquiz/models/MyStorage.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/screens/navigation.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spotiquiz/screens/homepage_tablet.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.api, required this.auth, required this.storage});
  final API api;
  final Auth auth;
  final MyStorage storage;

  Future<bool> checkLogin() async {
    await dotenv.load(fileName: ".env");
    var test = await storage.read(key: 'access_token');
    if (test != null) {
      //IF there is an access token -> not first login

      if (!await api.tryToken()) {
        //if the token is expired
        auth.refresh(http.Client()); //refresh it
        print('VALID TOKEN! \n');
      }
      auth.refresh(http.Client());
      return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data.toString());

          if (snapshot.data.toString() == 'true') {
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                  return HomeTablet();
                } else
                  return Navigation();
              },
            );
          } else
            return Login(
              spotiauth: auth,
            );
        } else
          return Login(
            spotiauth: auth,
          );
      },
    );
  }
}
