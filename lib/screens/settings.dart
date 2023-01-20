import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:spotiquiz/screens/languages.dart';
import 'package:spotiquiz/screens/loginpage.dart';
import 'package:spotiquiz/services/auth.dart';
import 'package:spotiquiz/widgets/policy_conditions_dialog.dart';
import 'package:animations/animations.dart';

final auth = Auth();

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SettingsList(
        sections: [
          // GENERAL SECTION
          SettingsSection(title: Text('General'), tiles: [
            // Info app: version, developers,
            SettingsTile.navigation(
              leading: Icon(Icons.info),
              title: Text('Info App'),
              onPressed: (BuildContext context) {
                //
              },
            ),
            // language
            SettingsTile.navigation(
              leading: Icon(Icons.language),
              title: Text('Language'),
              value: Text('English'),
              onPressed: (BuildContext context) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguagesPage()));
              },
            ),
          ]),

          // ACCOUNT SECTION
          SettingsSection(title: Text('Account'), tiles: [
            // logout
            SettingsTile.navigation(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onPressed: (BuildContext context) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Login(
                          spotiauth: auth,
                        )));
              },
            )
          ]),

          // TERMS AND POLICY SECTION
          SettingsSection(title: Text('Policy & Conditions'), tiles: [
            // logout
            SettingsTile.navigation(
              leading: Icon(Icons.account_balance),
              title: Text("Terms of Service"),
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
              leading: Icon(Icons.policy),
              title: Text('Privacy Policy'),
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
          SettingsSection(title: Text('Feedback'), tiles: [
            // Info app: version, developers,
            SettingsTile.navigation(
              leading: Icon(Icons.bug_report),
              title: Text('Report A Bug'),
              onPressed: (BuildContext context) {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguagesPage()));
              },
            ),
            // language
            SettingsTile.navigation(
              leading: Icon(Icons.feedback),
              title: Text('Send Feedback'),
              onPressed: (BuildContext context) {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguagesPage()));
              },
            ),
          ]),
        ],
      ),
    );
  }
}
