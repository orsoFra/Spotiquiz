import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import '../models/MyStorage.dart';
import '../services/data.dart';

final sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() {
    //getInfoUser();
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 25, 20, 20),
          elevation: 0,
          title: Text("Your Profile"),
        ),
        body: RefreshIndicator(
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              FutureBuilder<List>(
                future: Future.wait([api.getInfoUser(http.Client()), getUserData()]), // a Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator(
                        color: Color.fromARGB(255, 49, 45, 45),
                      );
                    case ConnectionState.done:
                      if(!snapshot.hasData) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 49, 45, 45),
                        );
                      } else {
                        return Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 110,
                                      backgroundColor: Color.fromARGB(255, 49, 45, 45),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data![0]['imageUrl']),
                                        radius: 100,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            Text(
                              snapshot.data![0]['display_name'],
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data![0]['email'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data![0]['product'] + " user ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                              },
                              child: Container(
                                height: queryData.size.height * 0.05,
                                width: queryData.size.width * 0.5,
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    api.flushCredentials();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                                  },
                                  style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                                  child: Text("LOGOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),

                            Text('Quiz done: ${snapshot.data![1]['numQuizzes']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text('Quiz perfect: ${snapshot.data![1]['numPerfectQuizzes']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ],
                        );
                      }
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return new Text('Result: ${snapshot.data}');
                  }
                },
              ),
            ]),
          ),
          onRefresh: () async {
            setState(() {});
          },
        ));
  }
}
