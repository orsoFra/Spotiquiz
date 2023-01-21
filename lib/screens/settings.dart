import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:spotiquiz/screens/languages.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/services/data.dart';
import 'package:spotiquiz/widgets/policy_conditions_dialog.dart';
import 'package:animations/animations.dart';
import 'package:rating_dialog/rating_dialog.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          // GENERAL SECTION
          SettingsSection(
            title: const Text('General'),
              tiles: [
                // Info app: version, developers,
                SettingsTile.navigation(
                  leading: const Icon(Icons.info),
                  title: const Text('Info App'),
                  onPressed: (BuildContext context){
                    //
                  },
                ),
                // language
                SettingsTile.navigation(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    value: const Text('English'),
                    onPressed: (BuildContext context){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguagesPage()));
                    },
                ),
              ]),

          // ACCOUNT SECTION
          SettingsSection(
              title: const Text('Account'),
              tiles: [
                // logout
                SettingsTile.navigation(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onPressed: (BuildContext context){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Login()));
                  },
                )
              ]),

          // TERMS AND POLICY SECTION
          SettingsSection(
              title: const Text('Policy & Conditions'),
              tiles: [
                // logout
                SettingsTile.navigation(
                  leading: const Icon(Icons.account_balance),
                  title: const Text("Terms of Service"),
                  onPressed: (BuildContext context){
                    // open dialog of terms  of service
                    showModal(
                        context: context,
                        configuration: const FadeScaleTransitionConfiguration(),
                        builder: (context) {
                          return PolicyConditionsDialog(
                            mdFileName: 'terms_and_conditions.md',
                          );
                    },);
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.policy),
                  title: const Text('Privacy Policy'),
                  onPressed: (BuildContext context){
                    // open dialog of privacy policy
                    showModal(
                      context: context,
                      configuration: const FadeScaleTransitionConfiguration(),
                      builder: (context) {
                        return PolicyConditionsDialog(
                          mdFileName: 'privacy_policy.md',
                        );
                      },);
                  },
                ),
              ]),

          // FEEDBACK
          SettingsSection(
              title: const Text('Feedback'),
              tiles: [
                // Info app: version, developers,
                SettingsTile.navigation(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Report A Bug'),
                  onPressed: (BuildContext context){
                    showDialog(
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            title: const Text('Report a Bug!'),
                            content: TextField(
                              controller: myController,
                              decoration: InputDecoration(hintText: 'Enter your comment here.'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    // store bugs
                                    storeBugs(myController.text);
                                    Fluttertoast.showToast(
                                        msg: "Thank you for reporting the Bug!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
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
                  onPressed: (BuildContext context){
                    showDialog(
                        context: context,
                        builder: (context){
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
                            image: const FlutterLogo(size: 100),
                            submitButtonText: 'Submit',
                            commentHint: 'Set your custom comment hint',
                            onCancelled: () => print('cancelled'),
                            onSubmitted: (response){
                              // store feedback
                              storeFeedbacks(response.rating.toInt(), response.comment);
                              print('rating: ${response.rating}, comment: ${response.comment}');
                              Fluttertoast.showToast(
                                  msg: "Thank you for the Feedback!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0
                              );
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
