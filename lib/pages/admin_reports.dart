import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paw_rescuer/pages/Database_helper.dart';
import 'package:flutter_paw_rescuer/pages/pet_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({Key? key}) : super(key: key);

  @override
  _AdminReportsPageState createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  List<Pet> reportedPosts = []; // Change to list of reported posts

  @override
  void initState() {
    super.initState();
    _fetchReportedPosts(); // Fetch reported posts when the page initializes
  }

  Future<void> _fetchReportedPosts() async {
    try {
      // Retrieve reported posts from the database
      var results = await DatabaseHelper.instance.getReportedPosts();
      List<Pet> pets = results.map((row) => Pet.fromMap(row)).toList();
      setState(() {
        reportedPosts = pets; // Update the reported posts list
      });
    } catch (error) {
      print('Error fetching reported posts: $error');
      // Handle error
    }
  }
  Future<String> getLocationName(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Unknown location';
      } else {
        return 'Unknown location';
      }
    } catch (e) {
      print('Error performing reverse geocoding: $e');
      return 'Unknown location';
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Reported Posts'),
    ),
    body: ListView.builder(
  itemCount: reportedPosts.length,
  itemBuilder: (context, index) {
    Pet pet = reportedPosts[index];
    // Extract post details from the pet object
    String title = pet.breed;
    String description = pet.details;
    String imagePath = pet.images; // Assuming imagePath is the path to the local image file
    String gender = pet.gender;
    String size = pet.size;
    String color = pet.color;
    String actionTaken = pet.actionTaken;
    String condition = pet.condition;
    double locationLat = pet.locationLat;
    double locationLng = pet.locationLng;
    String postedBy = pet.postedBy;
    bool isRescued = pet.isRescued;

    return FutureBuilder<String>(
      future: getLocationName(LatLng(locationLat, locationLng)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching location name
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error message if location name fetching fails
        } else {
          String locationName = snapshot.data ?? 'Unknown location'; // Use location name if available, otherwise show "Unknown location"
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 170, // Adjust the width as needed
                    height: 220, // Adjust the height as needed
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          description,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 2),
                        // Additional details
                        Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Gender:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $gender'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Size:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $size'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Color:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $color'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Action Taken:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $actionTaken'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Condition:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $condition'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Location:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $locationName'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Posted By:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' $postedBy'),
    ],
  ),
),
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: 'Is Rescued:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(text: ' ${isRescued ? 'Yes' : 'No'}'),
    ],
  ),
),

                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Show delete confirmation dialog and pass the ID
                      showDeleteConfirmationDialog(context, pet.id);

                  },
                ),
              ],
            ),
          ),
        );
      }
  }
  );
}
  )
  );
}


 void showDeleteConfirmationDialog(BuildContext context, int strayId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the method to delete the stray item
                _deleteStrayItem(strayId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteStrayItem(int strayId) async {
  try {
    // Call the deleteStray method from the DatabaseHelper class
    final rowsAffected = await DatabaseHelper.instance.deleteStray(strayId);
    
    if (rowsAffected > 0) {
      // The deletion was successful
      print('Deleted stray item with ID: $strayId');
      // You might want to notify the user that the item was deleted
    } else {
      // No rows were affected, indicating that the item with the given ID was not found
      print('No stray item found with ID: $strayId');
      // You might want to notify the user that the item was not found
    }
  } catch (error) {
    // An error occurred while deleting the stray item
    print('Error deleting stray item with ID: $strayId');
    print(error);
    // You might want to notify the user that an error occurred
  }
}
}