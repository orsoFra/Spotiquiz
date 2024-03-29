import 'package:flutter/material.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

void initState() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 1;
  static List<Widget> _pages = <Widget>[Leaderboard(), MyHomePage(title: ''), UserPage()];
  @override
  Widget build(BuildContext context) {
    initState();
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        //height: queryData.size.height * 0.07,
        child: GNav(
          style: GnavStyle.google,
          rippleColor: const Color.fromARGB(255, 49, 45, 45),
          backgroundColor: Color.fromARGB(255, 30, 25, 25),
          activeColor: Color.fromARGB(255, 128, 5, 195),
          color: const Color.fromARGB(255, 49, 45, 45),
          curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          iconSize: 27,
          haptic: true,
          tabs: const <GButton>[
            GButton(
              key: Key('Leaderboard'),
              icon: Icons.leaderboard,
              //text: 'Leaderboard',
            ),
            GButton(
              key: Key('Home'),
              icon: Icons.home,
              //text: 'Home',
            ),
            GButton(
              key: Key('Person'),
              icon: Icons.person,
              //text: 'Profile',
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (this.mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
