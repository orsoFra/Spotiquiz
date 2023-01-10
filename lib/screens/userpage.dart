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
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 25, 20, 20),
          elevation: 0,
          title: Text("Your Profile"),
        ),
        body: Column(children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          FutureBuilder<Map<String, dynamic>>(
            future: api.getInfoUser(http.Client()), // a Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Awaiting result...');
                case ConnectionState.done:
                  return Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  backgroundImage: NetworkImage(snapshot.data!['imageUrl']),
                                  radius: 100,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      Text(
                        snapshot.data!['display_name'],
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        snapshot.data!['email'],
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        snapshot.data!['product'] + " user ",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      Container(
                        child: MaterialButton(
                          color: Color.fromARGB(255, 14, 65, 91),
                          child: Text("Logout"),
                          onPressed: () {
                            api.flushCredentials();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                          },
                        ),
                      )
                    ],
                  );

                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return new Text('Result: ${snapshot.data}');
              }
            },
          ),
          Text('Recent Quizzes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          FutureBuilder<List<dynamic>>(
            future: api.getUserQuizScores('21q4wwalokcky25op74guvjcq', http.Client()), // a Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Awaiting result...');
                case ConnectionState.done:
                  print(snapshot.data);
                  print(snapshot.data?.length);
                  var l = snapshot.data?.length;
                  var result = snapshot.data!;
                  return ListView.builder(
                      itemCount: l,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return ListTile(title: Text(result[index]['points'].toString()), subtitle: Text(result[index]['date'].toString().substring(0, 10)));
                      }));

                default:
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  else
                    return new Text('Result: ${snapshot.data}');
              }
            },
          ),
        ]));
  }
}
