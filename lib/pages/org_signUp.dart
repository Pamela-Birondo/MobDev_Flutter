import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/admin_home.dart';
import 'package:flutter_paw_rescuer/pages/home.dart';
import 'admin_navigation.dart'; // Import the navigation page file
import 'Database_helper.dart'; // Import the DatabaseHelper class
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import for handling File objects
import 'package:shared_preferences/shared_preferences.dart';

class OrgSignUp extends StatefulWidget {
    const OrgSignUp({Key? key}) : super(key: key);

    @override
    _OrgSignUpPage  createState() => _OrgSignUpPage ();
}

class _OrgSignUpPage extends State<OrgSignUp> {
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
    Future<void> insertOrgData() async {
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
            int id = await dbHelper.insertOrgData(userData);
            print('User inserted with ID: $id');

            // Navigate to HomePage after successful insertion
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => adminhomePage()), // Replace `HomePage()` with the correct import for your HomePage
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
                                ItemProfileTextField('Organization Name', 'Organization Name', Icons.person, controller: nameController),
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
        await insertOrgData();
        // Navigate to the LoginPage after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminNavigationPage()),
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