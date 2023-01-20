import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spotiquiz/main.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/services/api.dart';
import 'package:http/http.dart' as http;
import '../models/MyStorage.dart';
import '../services/data.dart';
import 'package:spotiquiz/services/scalesize.dart';

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
        body: OrientationLayoutBuilder(
          portrait: (context) {
            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
                  return Grid(
                    queryData: queryData,
                    txtSize: 40,
                    imgSize: 120,
                    tabFactor: 0.7,
                  );
                } else
                  return Grid(
                    queryData: queryData,
                    txtSize: 20,
                    imgSize: 100,
                    tabFactor: 1,
                  );
              },
            );
          },
          landscape: (context) {
            return RefreshIndicator(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  FutureBuilder<List>(
                    future: Future.wait([api.getInfoUser(http.Client()), getUserData()]), // a Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if (!snapshot.hasData) {
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
                                      radius: 130,
                                      backgroundColor: const Color.fromARGB(255, 49, 45, 45),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data![0]['imageUrl']),
                                        radius: 120,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                            Text(
                              snapshot.data![0]['display_name'],
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data![0]['email'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              snapshot.data![0]['product'] + " user ",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                            // HISTORY VIEW
                            Container(
                              width: queryData.size.width * 0.75,
                              padding: EdgeInsets.symmetric(vertical: queryData.size.height * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  // first
                                  Container(
                                      width: queryData.size.width * 0.12,
                                      height: queryData.size.width * 0.12,
                                      padding: EdgeInsets.all(queryData.size.width * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromARGB(255, 120, 120, 120),
                                            Color.fromARGB(255, 209, 209, 209),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.done,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${snapshot.data![1]['numQuizzes']}',
                                              textScaleFactor: ScaleSize.textScaleFactor(context),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Completed',
                                            textScaleFactor: ScaleSize.textScaleFactor(context),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )),
                                  // second
                                  Container(
                                      width: queryData.size.width * 0.12,
                                      height: queryData.size.width * 0.12,
                                      padding: EdgeInsets.all(queryData.size.width * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromARGB(255, 120, 120, 120),
                                            Color.fromARGB(255, 209, 209, 209),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.star_rate,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${snapshot.data![1]['numPerfectQuizzes']}',
                                              textScaleFactor: ScaleSize.textScaleFactor(context),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Perfect',
                                            textScaleFactor: ScaleSize.textScaleFactor(context),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )),
                                  // third
                                  Container(
                                      width: queryData.size.width * 0.12,
                                      height: queryData.size.width * 0.12,
                                      padding: EdgeInsets.all(queryData.size.width * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromARGB(255, 120, 120, 120),
                                            Color.fromARGB(255, 209, 209, 209),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.emoji_events,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${snapshot.data![1]['totalScore']}',
                                              textScaleFactor: ScaleSize.textScaleFactor(context),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Score',
                                            textScaleFactor: ScaleSize.textScaleFactor(context),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )),
                                  // fourth
                                  Container(
                                      width: queryData.size.width * 0.12,
                                      height: queryData.size.width * 0.12,
                                      padding: EdgeInsets.all(queryData.size.width * 0.01),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromARGB(255, 120, 120, 120),
                                            Color.fromARGB(255, 209, 209, 209),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.bar_chart,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${snapshot.data![1]['avgScore']}',
                                              textScaleFactor: ScaleSize.textScaleFactor(context),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Average',
                                            textScaleFactor: ScaleSize.textScaleFactor(context),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),

                            // LOGOUT BUTTON
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                              },
                              child: Container(
                                height: queryData.size.height * 0.05,
                                width: queryData.size.width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
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
                                  child: const Text("LOGOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      /*default:
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        else
                          return new Text('Result: ${snapshot.data}');*/
                    },
                  ),
                ]),
              ),
              onRefresh: () async {
                setState(() {});
              },
            );
          },
        ));
  }
}

class Grid extends StatefulWidget {
  const Grid({super.key, required this.queryData, required this.txtSize, required this.imgSize, required this.tabFactor});
  final MediaQueryData queryData;
  final double txtSize;
  final double imgSize;
  final double tabFactor; //reduce dimension of boxes in tablet

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          FutureBuilder<List>(
            future: Future.wait([api.getInfoUser(http.Client()), getUserData()]), // a Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  width: widget.queryData.size.width,
                  height: widget.queryData.size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color.fromARGB(255, 49, 45, 45),
                      ),
                    ],
                  ),
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
                              radius: widget.imgSize + 10,
                              backgroundColor: const Color.fromARGB(255, 49, 45, 45),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data![0]['imageUrl']),
                                radius: widget.imgSize,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text(
                      snapshot.data![0]['display_name'],
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      snapshot.data![0]['email'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      snapshot.data![0]['product'] + " user ",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                    // HISTORY VIEW
                    Container(
                      width: widget.queryData.size.width * widget.tabFactor,
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        //childAspectRatio: queryData.size.width /
                        //((queryData).size.height / 1.4),
                        //crossAxisSpacing: 2,
                        //mainAxisSpacing: 2,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: <Widget>[
                          // first
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Container(
                                padding: EdgeInsets.all(widget.queryData.size.width * 0.01 * widget.tabFactor),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 120, 120, 120),
                                      Color.fromARGB(255, 209, 209, 209),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: widget.txtSize,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${snapshot.data![1]['numQuizzes']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.txtSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Completed',
                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.txtSize / 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          // second
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Container(
                                padding: EdgeInsets.all(widget.queryData.size.width * 0.01 * widget.tabFactor),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 120, 120, 120),
                                      Color.fromARGB(255, 209, 209, 209),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_rate,
                                      size: widget.txtSize,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${snapshot.data![1]['numPerfectQuizzes']}',
                                        textScaleFactor: ScaleSize.textScaleFactor(context),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.txtSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Perfect',
                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.txtSize / 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          // third
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Container(
                                padding: EdgeInsets.all(widget.queryData.size.width * 0.01 * widget.tabFactor),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 120, 120, 120),
                                      Color.fromARGB(255, 209, 209, 209),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.emoji_events,
                                      size: widget.txtSize,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${snapshot.data![1]['totalScore']}',
                                        textScaleFactor: ScaleSize.textScaleFactor(context),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.txtSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Score',
                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.txtSize / 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          // fourth
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Container(
                                padding: EdgeInsets.all(widget.queryData.size.width * 0.01 * widget.tabFactor),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(255, 120, 120, 120),
                                      Color.fromARGB(255, 209, 209, 209),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bar_chart,
                                      size: widget.txtSize,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${snapshot.data![1]['avgScore']}',
                                        textScaleFactor: ScaleSize.textScaleFactor(context),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: widget.txtSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Average',
                                      textScaleFactor: ScaleSize.textScaleFactor(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: widget.txtSize / 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),

                    // LOGOUT BUTTON
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserPage()));
                      },
                      child: Container(
                        height: widget.queryData.size.height * 0.05,
                        width: widget.queryData.size.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
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
                          child: const Text("LOGOUT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ]),
      ),
      onRefresh: () async {
        setState(() {});
      },
    );
  }
}
