import 'package:flutter/material.dart';
import 'pages/navigation.dart';
import 'pages/login.dart'; 

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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
