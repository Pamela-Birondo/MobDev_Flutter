import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'search.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    //final ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex == 0) {
          // If the user is on the home page, don't allow navigation back to login page
          return false;
        } else {
          // Allow navigation back to previous page
          setState(() {
            currentPageIndex = 0; // Redirect to home page
          });
          return false; // Prevent default behavior (popping the route)
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: const Color(0xffeab857),
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 56, 3, 3),
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.map_sharp,
                color: Color.fromARGB(255, 39, 37, 37),
              ),
              label: 'Map',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person,
                color: Color.fromARGB(255, 39, 37, 37),
              ),
              label: 'Profile',
            ),
          ],
        ),
        body: <Widget>[
          /// Home page
          homePage(),

          // Notification Page
          searchPage(),

          /// Messages page
          profilePage(),
        ][currentPageIndex],
      ),
    );
  }
}