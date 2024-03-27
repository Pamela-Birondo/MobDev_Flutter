import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/login.dart';
import 'package:image_picker/image_picker.dart';

class profilePage extends StatelessWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('images/pp.jpg'),
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
            ItemProfile('Name', 'Ming Ming', Icons.person),
            const SizedBox(height: 10),
            ItemProfile('Phone', '03107085816', Icons.phone),
            const SizedBox(height: 10),
            ItemProfile('Address', 'Mandalagan, Bacolod city', Icons.location_on),
            const SizedBox(height: 10),
            ItemProfile('Email', 'mingming24@gmail.com', Icons.email),
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
                  backgroundColor: Color.fromARGB(255, 247, 225, 154), 
                ),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
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
            color: Color.fromARGB(255, 218, 204, 19).withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          )
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