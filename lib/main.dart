import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/admin_navigation.dart';
import 'pages/navigation.dart';
import 'pages/login.dart';
import 'pages/admin_home.dart'; // Import admin dashboard page

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true), 
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(), 
        '/navigation': (context) => NavigationPage(),
        '/admin_home': (context) => AdminNavigationPage(), // Add route for admin dashboard
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

