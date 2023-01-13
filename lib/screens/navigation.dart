import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spotiquiz/screens/homepage.dart';
import 'package:spotiquiz/screens/leaderboard_page.dart';
import 'package:spotiquiz/screens/userpage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 1;
  static const List<Widget> _pages = <Widget>[Leaderboard(), MyHomePage(title: ''), UserPage()];
  @override
  Widget build(BuildContext context) {
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
              icon: Icons.leaderboard,
              //text: 'Leaderboard',
            ),
            GButton(
              icon: Icons.home,
              //text: 'Home',
            ),
            GButton(
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
    setState(() {
      _selectedIndex = index;
    });
  }
}
