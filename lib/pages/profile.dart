import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/Database_helper.dart';
import 'package:flutter_paw_rescuer/pages/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the necessary package


class profilePage extends StatefulWidget {
  final int userId;

  const profilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class UserData {
  final String name;
  final String phone;
  final String address;
  final String email;
  final String profileImage;

  UserData({
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.profileImage,
  });
}

class _ProfilePageState extends State<profilePage> {
  late Future<UserData> userDataFuture = Future.value(UserData(
    name: '',
    phone: '',
    address: '',
    email: '',
    profileImage: '',
  ));
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
  int? userId = await getCurrentUserId();
  print('Current User ID: $userId'); // Print the current user ID

  if (userId != null) {
    dbHelper.getUserById(userId).then((userDataMap) {
      print('User Data Map: $userDataMap'); // Print the user data retrieved from the database
      setState(() {
        userDataFuture = Future.value(mapToUserData(userDataMap));
      });
    }).catchError((error) {
      print('Error retrieving user data: $error'); // Print any errors encountered during data retrieval
    });
  } else {
    print('User ID is null'); // Print if the user ID is null
    // Handle the case where user ID is not available (user not logged in)
  }
}

  Future<int?> getCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  UserData mapToUserData(Map<String, dynamic>? userDataMap) {
    if (userDataMap == null) {
      return UserData(
        name: '',
        phone: '',
        address: '',
        email: '',
        profileImage: '',
      );
    }
    return UserData(
      name: userDataMap['name'] ?? '',
      phone: userDataMap['phone'] ?? '',
      address: userDataMap['address'] ?? '',
      email: userDataMap['email'] ?? '',
      profileImage: userDataMap['profileImage'] ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserData>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if there was an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Show a message if no data is found
            return Center(child: Text('No user data found.'));
          } else {
            // Fetch user data
            UserData userData = snapshot.data!;

            // Convert profileImage path to an ImageProvider
            ImageProvider profileImageProvider;
            if (userData.profileImage.isNotEmpty) {
              profileImageProvider = FileImage(File(userData.profileImage));
            } else {
              profileImageProvider = const AssetImage('images/pp.jpg');
            }

            // Display user data
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: profileImageProvider, // Assign the profile image provider
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 250, 242, 242),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditProfilePage()),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            iconSize: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Display user details
                  ItemProfile('Name', userData.name, Icons.person),
                  const SizedBox(height: 10),
                  ItemProfile('Phone', userData.phone, Icons.phone),
                  const SizedBox(height: 10),
                  ItemProfile('Address', userData.address, Icons.location_on),
                  const SizedBox(height: 10),
                  ItemProfile('Email', userData.email, Icons.email),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: const Color.fromARGB(255, 247, 225, 154),
                      ),
                      child: const Text('Log Out'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class ItemProfile extends StatelessWidget {
    final String title;
    final String subtitle;
    final IconData iconData;

    const ItemProfile(this.title, this.subtitle, this.iconData);

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        color: const Color.fromARGB(255, 218, 204, 19).withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                    ),
                ],
            ),
            child: ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                leading: Icon(iconData),
                tileColor: const Color.fromARGB(255, 255, 255, 255),
            ),
        );
    }
}
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('images/pp.jpg') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 250, 242, 242),
                      ),
                      child: IconButton(
                        onPressed: _getImageFromGallery,
                        icon: const Icon(Icons.add_a_photo),
                        iconSize: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ItemProfileTextField('Name', 'Ming Ming', Icons.person),
              const SizedBox(height: 10),
              ItemProfileTextField('Phone', '03107085816', Icons.phone),
              const SizedBox(height: 10),
              ItemProfileTextField('Address', 'Mandalagan, Bacolod city', Icons.location_on),
              const SizedBox(height: 10),
              ItemProfileTextField('Email', 'mingming24@gmail.com', Icons.email),
              const SizedBox(height: 50),
              SizedBox(
              width: 250, 
              child: ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Color.fromARGB(255, 247, 225, 154), 
                ),
                child: const Text('Save'),
              ),
            ),
            ]
        ),
      ),
      )
    );
  }
}

class ItemProfileTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final IconData iconData;

  const ItemProfileTextField(this.title, this.hintText, this.iconData);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Color.fromARGB(255, 218, 204, 19).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
        leading: Icon(iconData),
        tileColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}