import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:spotiquiz/screens/languages.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/widgets/policy_conditions_dialog.dart';
import 'package:animations/animations.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../models/MyStorage.dart';
import '../services/api.dart';

final auth = Auth();
final sStorage = FlutterSecureStorage();
final storage = new MyStorage(sStorage);
final api = API(storage);
final dApi = Data(api: api);

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 20, 20),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Color.fromARGB(255, 25, 20, 20),
        elevation: 0,
      ),
      body: SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: const Color(0xff191414),
        ),

        // darkTheme: ColorScheme.dark(
        //   background: const Color(0xff121212),
        // ),
        sections: [
          // GENERAL SECTION
          SettingsSection(
              title: const Text(
                'General',
                style: TextStyle(color: Color(0xffb650f5)),
              ),
              tiles: [
                // Info app: version, developers,
                SettingsTile.navigation(
                  leading: const Icon(Icons.info),
                  title: const Text('Info App'),
                  onPressed: (BuildContext context) {
                    //
                  },
                ),
                // language
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: const Text('English'),
                  onPressed: (BuildContext context) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguagesPage()));
                  },
                ),
              ]),

          // ACCOUNT SECTION
          SettingsSection(
              title: Text(
                'Account',
                style: TextStyle(color: Color(0xffb650f5)),
              ),
              tiles: [
                // logout
                SettingsTile.navigation(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onPressed: (BuildContext context) {
                    api.flushCredentials();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Login(
                              spotiauth: auth,
                            )));
                  },
                )
              ]),

          // TERMS AND POLICY SECTION
          SettingsSection(
              title: const Text(
                'Policy & Conditions',
                style: TextStyle(color: Color(0xffb650f5)),
              ),
              tiles: [
                // logout
                SettingsTile.navigation(
                  leading: const Icon(Icons.account_balance),
                  title: const Text("Terms of Service"),
                  onPressed: (BuildContext context) {
                    // open dialog of terms  of service
                    showModal(
                      context: context,
                      configuration: const FadeScaleTransitionConfiguration(),
                      builder: (context) {
                        return PolicyConditionsDialog(
                          mdFileName: 'terms_and_conditions.md',
                        );
                      },
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.policy),
                  title: const Text('Privacy Policy'),
                  onPressed: (BuildContext context) {
                    // open dialog of privacy policy
                    showModal(
                      context: context,
                      configuration: const FadeScaleTransitionConfiguration(),
                      builder: (context) {
                        return PolicyConditionsDialog(
                          mdFileName: 'privacy_policy.md',
                        );
                      },
                    );
                  },
                ),
              ]),

          // FEEDBACK
          SettingsSection(
              title: const Text(
                'Feedback',
                style: TextStyle(color: Color(0xffb650f5)),
              ),
              tiles: [
                // Info app: version, developers,
                SettingsTile.navigation(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Report A Bug'),
                  onPressed: (BuildContext context) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Report a Bug!'),
                          content: TextField(
                            controller: myController,
                            decoration: InputDecoration(hintText: 'Enter your comment here.'),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // store bugs
                                  dApi.storeBugs(myController.text);
                                  Fluttertoast.showToast(
                                      msg: "Thank you for reporting the Bug!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      fontSize: 16.0);
                                },
                                child: const Text('SUBMIT'))
                          ],
                        );
                      },
                    );
                  },
                ),
                // language
                SettingsTile.navigation(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Send Feedback'),
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return RatingDialog(
                            title: const Text(
                              'Send a Feedback!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            message: const Text(
                              'Tap a star to set your rating. Add more description here if you want.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15),
                            ),
                            image: const Image(image: AssetImage('assets/img/start_screen_l.png')),
                            submitButtonText: 'Submit',
                            commentHint: 'Set your custom comment hint',
                            onCancelled: () => print('cancelled'),
                            onSubmitted: (response) {
                              // store feedback
                              dApi.storeFeedbacks(response.rating.toInt(), response.comment);
                              Fluttertoast.showToast(
                                  msg: "Thank you for the Feedback!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            },
                          );
                        });
                  },
                ),
              ]),
        ],
      ),
    );
  }
}
