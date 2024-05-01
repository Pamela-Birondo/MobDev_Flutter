import 'package:flutter/material.dart';
import 'navigation.dart'; // Import the navigation page file
import 'Database_helper.dart'; // Import the DatabaseHelper class


class LoginPage extends StatefulWidget {
    const LoginPage({Key? key}) : super(key: key);

    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    // Controllers for capturing user inputs
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Create an instance of DatabaseHelper
    final dbHelper = DatabaseHelper.instance;

    // Function to validate the user's credentials
    Future<bool> validateUser(String email, String password) async {
        return await dbHelper.validateUser(email, password);
    }

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
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Image.asset(
                                    'images/logo.png',
                                    height: 250,
                                ),
                                const SizedBox(height: 10.0),
                                // Email text field
                                Container(
                                    width: 320,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        border: Border.all(color: Colors.grey),
                                    ),
                                    child: TextField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                            hintText: 'Enter your email',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                            prefixIcon: Icon(Icons.email),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 16.0),
                                // Password text field
                                Container(
                                    width: 320,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.0),
                                        border: Border.all(color: Colors.grey),
                                    ),
                                    child: TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                            hintText: 'Enter your password',
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                            prefixIcon: Icon(Icons.lock),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 16.0),
                                // Login button
                                SizedBox(
                                    width: 320,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                            // Get the email and password from the controllers
                                            String email = emailController.text;
                                            String password = passwordController.text;

                                            // Validate the user's credentials
                                            bool isValid = await validateUser(email, password);

                                            if (isValid) {
                                                // If the credentials are valid, navigate to the navigation page
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const NavigationPage()),
                                                );
                                            } else {
                                                // If the credentials are invalid, show an error message
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Invalid email or password')),
                                                );
                                            }
                                        },
                                        child: const Text('Login'),
                                    ),
                                ),
                                const SizedBox(height: 8.0),
                                const Text(
                                    "Don't have an account?",
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

    @override
    void dispose() {
        // Dispose of text controllers when the widget is disposed
        emailController.dispose();
        passwordController.dispose();
        super.dispose();
    }
}
class SignUpPage extends StatefulWidget {
    const SignUpPage({Key? key}) : super(key: key);

    @override
    _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
    // Controllers to capture user inputs
    final TextEditingController nameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    // Create an instance of DatabaseHelper
    final dbHelper = DatabaseHelper.instance;

    // Function to insert user data
   Future<void> insertUserData() async {
    try {
        // Create a map to hold user data
        Map<String, dynamic> userData = {
            'name': nameController.text,
            'username': usernameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'password': passwordController.text,
        };

        // Insert the user data into the database
        int id = await dbHelper.insertUser(userData);
        print('User inserted with ID: $id');
    } catch (e) {
        print('Error inserting user data: $e');
    }
}

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Sign Up'),
            ),
            body: SingleChildScrollView(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Image.asset(
                                    'images/logo.png',
                                    height: 150,
                                ),
                                const SizedBox(height: 10.0),
                                // Name text field
                                TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                        hintText: 'Name',
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 10.0),
                                // Username text field
                                TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        hintText: 'Username',
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 10.0),
                                // Email text field
                                TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: 'Email',
                                        prefixIcon: const Icon(Icons.email),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 10.0),
                                // Phone text field
                                TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                        hintText: 'Phone',
                                        prefixIcon: const Icon(Icons.phone),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 10.0),
                                // Password text field
                                TextField(
                                    controller: passwordController,
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
                                // Confirm Password text field
                                TextField(
                                    controller: confirmPasswordController,
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
                                // Sign Up button
                                SizedBox(
                                    width: 300,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                            // Validate and insert user data
                                            if (passwordController.text == confirmPasswordController.text) {
                                                await insertUserData();
                                                // Navigate to the next page
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const NavigationPage()),
                                                );
                                            } else {
                                                // Show error message if passwords don't match
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Passwords do not match!')),
                                                );
                                            }
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

    @override
    void dispose() {
        // Dispose of text controllers when the widget is disposed
        nameController.dispose();
        usernameController.dispose();
        emailController.dispose();
        phoneController.dispose();
        passwordController.dispose();
        confirmPasswordController.dispose();
        super.dispose();
    }
}