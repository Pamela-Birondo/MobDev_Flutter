import 'package:flutter/material.dart';
import 'navigation.dart'; // Import the navigation page file

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9, // Adjust the height as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start, // Align children to the top
              children: [
                Image.asset(
                  'images/logo.png', // Replace 'assets/logo.png' with the path to your logo image
                  height: 250, // Adjust height as needed
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: 320, // Set width to occupy the full width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0), // Adjust border radius as needed
                    border: Border.all(color: Colors.grey), // Optional border color
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      border: InputBorder.none, // Remove TextField's border
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 320, // Set width to occupy the full width
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0), // Adjust border radius as needed
                    border: Border.all(color: Colors.grey), // Optional border color
                  ),
                  child: const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      border: InputBorder.none, // Remove TextField's border
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 320, // Set width of the button
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the navigation page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NavigationPage()), // Replace NavigationPage() with your navigation page
                      );
                    },
                    child: const Text('Login'),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Don't have an account? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                InkWell(
                  onTap: () {
                    // Navigate to the sign-up page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()), 
                      );
                  },
                  child: const Text(
                    'Sign up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 143, 43, 129),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                Image.asset(
                  'images/logo.png', 
                  height: 150,
                ),
                const SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), 
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 300, // Set width of the button
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NavigationPage()), // Replace NavigationPage() with your navigation page
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}