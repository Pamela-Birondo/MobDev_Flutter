import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/admin_reports.dart';
import 'package:flutter_paw_rescuer/pages/admin_search.dart';
import 'admin_home.dart';
import 'admin_profile.dart';
import 'search.dart';
import 'Database_helper.dart'; // Import the DatabaseHelper class
import 'package:shared_preferences/shared_preferences.dart';

class AdminNavigationPage extends StatefulWidget {
  const AdminNavigationPage({Key? key}) : super(key: key);

  @override
  State<AdminNavigationPage> createState() => _AdminNavigationPageState();
}

class _AdminNavigationPageState extends State<AdminNavigationPage> {
  int currentPageIndex = 0;
  int? id; // Declare userId variable

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<int?> getAuthenticatedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('authenticatedUserId');
  }

  Future<void> fetchUserId() async {
    try {
      // Retrieve the authenticated user's email
      String email = await getAuthenticatedUserEmail();

      // Get the user data based on the email
      Map<String, dynamic>? user = await DatabaseHelper.instance.getUserByEmail(email);

      if (user != null) {
        // Extract the user ID from the user data
        setState(() {
          id = user['id'];
        });
      } else {
        print('User not found with email: $email');
      }
    } catch (error) {
      // Handle any errors that occur during the database fetch
      print('Error fetching user ID: $error');
    }
  }

  Future<String> getAuthenticatedUserEmail() async {
    int? id = await getAuthenticatedUserId();

    if (id != null) {
      // Retrieve the user data by ID using your database helper
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      Map<String, dynamic>? user = await dbHelper.getOrgById(id);

      if (user != null && user.containsKey('email')) {
        // Return the email of the authenticated user
        return user['email'] as String;
      } else {
        // Handle case where user data is not found or email is not present
        print('User data not found for ID: $id');
        return '';
      }
    } else {
      // If no user ID is stored, the user is not authenticated
      print('No authenticated user ID found');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentPageIndex == 0) {
          return false;
        } else {
          setState(() {
            currentPageIndex = 0;
          });
          return false;
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
                Icons.flag_rounded,
                color: Color.fromARGB(255, 39, 37, 37),
              ),
              label: 'Reports',
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
          adminhomePage(),
          adminsearchPage(),
          // Provide default values or placeholder data for initial AdminReportsPage view
          AdminReportsPage(
          ),
          adminprofilePage(userId: id ?? 0),
        ][currentPageIndex],
      ),
    );
  }
}
