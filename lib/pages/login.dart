import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/home.dart';
import 'navigation.dart'; // Import the navigation page file
import 'Database_helper.dart'; // Import the DatabaseHelper class
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import for handling File objects
import 'package:shared_preferences/shared_preferences.dart';
import 'org_signUp.dart';


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
    Future<Map<String, dynamic>> validateUser(String email, String password) async {
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

      // Debugging: Check the values of email and password
      print('Attempting to validate user with email: $email and password: [hidden]');

      // Create an instance of DatabaseHelper
      final dbHelper = DatabaseHelper.instance;

      // Validate user credentials using dbHelper
      Map<String, dynamic> userData = await dbHelper.validateUser(email, password);
      bool isValid = userData.isNotEmpty;

      // Debugging: Check the result of the validation
      print('Validation result: $isValid');

      // Proceed based on the validation result
      if (isValid) {
        // Extract the user role from the userData
        bool isAdmin = userData['isAdmin'];

        // If the user is an admin, navigate to the Admin Dashboard
        if (isAdmin) {
          Navigator.pushNamed(context, '/admin_home');
        } else {
          // If the user is not an admin, navigate to the regular user navigation page
          Navigator.pushNamed(context, '/navigation');
        }
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
                                    "Don't have an account? Sign up",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                ),
                                Row(
  mainAxisAlignment: MainAxisAlignment.center, // Center the row contents
  children: [
    InkWell(
      onTap: () {
        // Navigate to the sign-up page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpPage()),
        );
      },
      child: const Text(
        'User' '   |',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 143, 43, 129),
          decoration: TextDecoration.none,
        ),
      ),
    ),
    const SizedBox(width: 8.0), // Add spacing between the two InkWell widgets
    InkWell(
      onTap: () {
        // Handle the action for the second InkWell here
        // For example, navigate to a 'Forgot Password' page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrgSignUp()),
        );
      },
      child: const Text(
        'Organization',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 143, 43, 129),
          decoration: TextDecoration.none,
        ),
      ),
    ),
  ],
)
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
    final TextEditingController addressController = TextEditingController(); // Controller for address field

    // File to hold the profile image
    File? _profileImage;

    // Create an instance of DatabaseHelper
    final dbHelper = DatabaseHelper.instance;

    // Function to pick an image from the gallery
    Future<void> _pickImage() async {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

        if (pickedImage != null) {
            setState(() {
                _profileImage = File(pickedImage.path);
            });
        }
    }

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
                'profileImage': _profileImage?.path, // Add the profile image path if chosen
                'address': addressController.text,
            };

            // Insert the user data into the database
            int id = await dbHelper.insertUser(userData);
            print('User inserted with ID: $id');

            // Navigate to HomePage after successful insertion
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homePage()), // Replace `HomePage()` with the correct import for your HomePage
        );

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
                                const SizedBox(height: 40),
                                // CircleAvatar for profile image
                                Stack(
                                    children: [
                                        CircleAvatar(
                                            radius: 70,
                                            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null, // Initially empty
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                ),
                                                child: IconButton(
                                                    onPressed: _pickImage,
                                                    icon: const Icon(Icons.add_a_photo),
                                                    iconSize: 30,
                                                    color: Theme.of(context).primaryColor,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 20),
                                // Name text field
                                ItemProfileTextField('Name', 'Name', Icons.person, controller: nameController),
                                const SizedBox(height: 10),
                                // Username text field
                                ItemProfileTextField('Username', 'Username', Icons.person, controller: usernameController),
                                const SizedBox(height: 10),
                                // Email text field
                                ItemProfileTextField('Email', 'Email', Icons.email, controller: emailController),
                                const SizedBox(height: 10),
                                // Phone text field
                                ItemProfileTextField('Phone', 'Phone', Icons.phone, controller: phoneController),
                                const SizedBox(height: 10),
                                // Address text field
                                ItemProfileTextField('Address', 'Address', Icons.location_on, controller: addressController),
                                const SizedBox(height: 10),
                                // Password text field
                                ItemProfileTextField('Password', 'Password', Icons.lock, obscureText: true, controller: passwordController),
                                const SizedBox(height: 10),
                                // Confirm Password text field
                                ItemProfileTextField('Confirm Password', 'Confirm Password', Icons.lock, obscureText: true, controller: confirmPasswordController),
                                const SizedBox(height: 50),
                                // Sign Up button
                                SizedBox(
                                    width: 300,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                            // Validate and insert user data
                                            if (passwordController.text == confirmPasswordController.text) {
                                                await insertUserData();
                                                // Navigate to the next page (update this with your next page navigation logic)
                                                Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationPage()),
        );
                                            } else {
                                                // Show error message if passwords don't match
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Passwords do not match!')),
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
        addressController.dispose();
        super.dispose();
    }
}

class ItemProfileTextField extends StatelessWidget {
    final String title;
    final String hintText;
    final IconData iconData;
    final TextEditingController? controller;
    final bool obscureText;

    const ItemProfileTextField(this.title, this.hintText, this.iconData, {this.controller, this.obscureText = false});

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                    ),
                ],
            ),
            child: ListTile(
                title: Text(title),
                subtitle: TextFormField(
                    controller: controller,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                        hintText: hintText,
                    ),
                ),
                leading: Icon(iconData),
                tileColor: Colors.white,
            ),
        );
    }
}