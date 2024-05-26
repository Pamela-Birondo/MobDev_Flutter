import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/services.dart' show rootBundle;
//import 'dart:convert';
import 'pet_model.dart';
//import 'package:intl/intl.dart';
import 'Database_helper.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  late Future<List<Pet>> _futurePets;
  late TextEditingController _searchController;
  bool _isSearchVisible = false;
  int _selectedFeed = 0; // 0 for rescued, 1 for not rescued
  

  @override
  void initState() {
    super.initState();
    _futurePets = _loadPets();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Pet>> _loadPets() async {
  return DatabaseHelper.instance.getStrays().then((strays) {
    final List<Pet> pets = strays.map((stray) => Pet.fromMap(stray)).toList();

 // Split into rescued and not rescued lists
    final rescuedPets = pets.where((pet) => pet.isRescued).toList();
    final notRescuedPets = pets.where((pet) => !pet.isRescued).toList();

    print('Loaded ${rescuedPets.length} rescued pets');
    print('Loaded ${notRescuedPets.length} not rescued pets');
    
    // Return appropriate list based on selected feed
    return _selectedFeed == 0 ? rescuedPets : notRescuedPets;
  }

    // Logging to check isRescued values
    /*pets.forEach((pet) {
      print('Is Rescued: ${pet.isRescued}');
    });

    return pets;
  });*/
  );
  }

  Future<List<Pet>> _filterPets(List<Pet> pets, String query) async {
  // Create a list to store futures of location names
  final List<Future<String>> locationNameFutures = [];

  // Populate the list with futures of location names
  for (final pet in pets) {
    locationNameFutures.add(pet.getLocationName as Future<String>);
  }

  // Wait for all futures to complete
  final List<String> locationNames = await Future.wait(locationNameFutures);

  // Filter pets based on the query
  final filteredPets = pets.where((pet) {
    final locationName = locationNames[pets.indexOf(pet)];
    return pet.breed.toLowerCase().contains(query.toLowerCase()) ||
        pet.color.toLowerCase().contains(query.toLowerCase()) ||
        pet.gender.toLowerCase().contains(query.toLowerCase()) ||
        pet.postedBy.toLowerCase().contains(query.toLowerCase()) ||
        locationName.toLowerCase().contains(query.toLowerCase());
  }).toList();

    // Further filter based on the selected feed
    return filteredPets.where((pet) {
      // Check if selected feed is rescued or not rescued
      if (_selectedFeed == 0) {
        // Return only pets that have been rescued
        return pet.isRescued;
      } else {
        // Return only pets that haven't been rescued
        return !pet.isRescued;
      }
    }).toList();
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

Future<List<Pet>> _loadRescuedPets() async {
  print('Loading rescued pets...');
  return _loadPets().then((pets) {
    final rescuedPets = pets.where((pet) => pet.isRescued).toList();
    print('Loaded ${rescuedPets.length} rescued pets');
    return rescuedPets;
  });
}

Future<List<Pet>> _loadNotRescuedPets() async {
  print('Loading not rescued pets...');
  return _loadPets().then((pets) {
    final notRescuedPets = pets.where((pet) => !pet.isRescued).toList();
    print('Loaded ${notRescuedPets.length} not rescued pets');
    return notRescuedPets;
  });
}


 void _onToggleFeed(int index) {
  setState(() {
    _selectedFeed = index;
    if (_selectedFeed == 0) {
      // Load rescued pets
      _futurePets = _loadRescuedPets();
    } else {
      // Load not rescued pets
      _futurePets = _loadNotRescuedPets();
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchVisible
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {}); // Update the UI when text changes
                },
              )
            : const Text(''),
        actions: [
          // Search toggle button
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: _toggleSearchVisibility,
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle buttons for feed selection
          ToggleButtons(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Text('Rescued'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: Text('Not Rescued'),
              ),
            ],
            isSelected: [_selectedFeed == 0, _selectedFeed == 1],
            onPressed: _onToggleFeed,
          ),
          // Expanded widget for displaying the feed
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: _futurePets,
              builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
    return Center(
      child: Text('Error loading data: ${snapshot.error}'),
    );
  } else {
    final List<Pet> pets = snapshot.data!;
    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return InformationCard(
          width: 500,
          pet: pet,
        );
      },
    );
  }
},
            ),
          ),
        ],
      ),
    );
  }
}

class InformationCard extends StatefulWidget {
  final double width;
  final Pet pet;

  const InformationCard({
    Key? key,
    required this.width,
    required this.pet,
  }) : super(key: key);

  @override
  _InformationCardState createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  late Future<String> _locationNameFuture;

  @override
  void initState() {
    super.initState();
    LatLng petLocation = LatLng(widget.pet.locationLat, widget.pet.locationLng);
    _locationNameFuture = widget.pet.getLocationName(petLocation);
  }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    'Stray Information',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.flag,
                    color: const Color.fromARGB(255, 207, 14, 0),
                  ),
                  onPressed: () {
                    reportPost(widget.pet.id);
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(widget.pet.images),
                    width: 400,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCardItem('Posted by', 'Pam', 150.0),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Call function to edit the post
                              editPost(widget.pet.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Show delete confirmation dialog and pass the ID
                              showDeleteConfirmationDialog(context, widget.pet.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCardItem('Date', widget.pet.date, 150.0),
                              FutureBuilder<String>(
                                future: _locationNameFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return _buildCardItem('Location', 'Loading...', 150.0);
                                  } else if (snapshot.hasError) {
                                    return _buildCardItem('Location', 'Error', 150.0);
                                  } else {
                                    return _buildCardItem('Location', snapshot.data!, 150.0);
                                  }
                                },
                              ),
                              _buildCardItem('Breed', widget.pet.breed, 150.0),
                              _buildCardItem('Gender', widget.pet.gender, 150.0),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCardItem('Size', widget.pet.size, 150.0),
                              _buildCardItem('Color', widget.pet.color, 150.0),
                              _buildCardItem('Actions Taken', widget.pet.actionTaken, 150.0),
                              _buildCardItem('Condition', widget.pet.condition, 150.0),
                            ],
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                  SizedBox(
  height: 80.0, // Set your desired height
  child: Expanded(
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardItem('Details', widget.pet.details, 320.0),
        ],
      ),
    ),
  ),
),

                  const SizedBox(height: 5),
                  const Text(
                    'Comments:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: const Icon(Icons.person),
                          ),
                          title: const Text('Ella'),
                          subtitle: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 131, 131, 131),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Going...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: const Icon(Icons.person),
                          ),
                          title: const Text('Jia'),
                          subtitle: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 131, 131, 131),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: const Icon(Icons.person),
                          ),
                          title: const Text('Casandra'),
                          subtitle: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 131, 131, 131),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Text(
                              'Comment.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Type your comment here...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // functionality here
                        },
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
    child: SizedBox(
      width: widget.width,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(widget.pet.images),
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardItem('Date', widget.pet.date, 200.0),
                        FutureBuilder<String>(
                          future: _locationNameFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _buildCardItem('Location', 'Loading...', 200.0);
                            } else if (snapshot.hasError) {
                              return _buildCardItem('Location', 'Error', 200.0);
                            } else {
                              return _buildCardItem('Location', snapshot.data!, 200.0);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardItem('Breed', widget.pet.breed, 200.0),
                        _buildCardItem('Gender', widget.pet.gender, 200.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCardItem(String title, dynamic value, double itemWidth) {
    String displayValue = value?.toString() ?? 'Unknown';

    if (value is DateTime) {
      displayValue = DateFormat.yMMMMd().format(value);
    }

    return Container(
      width: itemWidth,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 184, 87),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            displayValue,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
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

 void editPost(int postId) {
  // Retrieve the pet details using the postId and open the edit dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Define controllers for the text fields
      
      TextEditingController detailsController = TextEditingController(text: widget.pet.details);
      
      // Initialize variables with current pet details
      String gender = widget.pet.gender;
      String size = widget.pet.size;
      String breed = widget.pet.breed;
      String color = widget.pet.color;
      String actionTaken = widget.pet.actionTaken;
      String condition = widget.pet.condition;
      
      return AlertDialog(
        title: const Text('Edit Post'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              
              // Gender selection
              DropdownButtonFormField<String>(
                value: gender,
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  gender = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              
              // Size selection
              DropdownButtonFormField<String>(
                value: size,
                items: ['Small', 'Medium', 'Large'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  size = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Size'),
              ),
              
              // Breed selection
              DropdownButtonFormField<String>(
                value: breed,
                items: ['Aspin', 'Puspin', 'Chihuahua', 'Poodle', 'Shih Tzu', 'Persian Cat'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  breed = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Breed'),
              ),
              
              // Color selection
              DropdownButtonFormField<String>(
                value: color,
                items: ['Solid', 'Bi-Color', 'Tri-color'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  color = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              
              // Action taken selection
              DropdownButtonFormField<String>(
                value: actionTaken,
                items: ['No Actions Taken', 'Adopted', 'Fostered', 'Brought to Shelter'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  actionTaken = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Actions Taken'),
              ),
              
              // Condition selection
              DropdownButtonFormField<String>(
                value: condition,
                items: ['Injured', 'Fine'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  condition = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Condition'),
              ),
              
              // Details text field
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Details'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Prepare the updated data
              Map<String, dynamic> updatedStrayData = {
                'gender': gender,
                'size': size,
                'breed': breed,
                'color': color,
                'actionTaken': actionTaken,
                'condition': condition,
                'details': detailsController.text,
                'locationLat': widget.pet.locationLat,
                'locationLng': widget.pet.locationLng,
                'isRescued': actionTaken != 'No Actions Taken' ? 1 : 0,
              };
              
              // Call the updateStray method
              DatabaseHelper dbHelper = DatabaseHelper.instance;
              dbHelper.updateStray(postId, updatedStrayData).then((rowsAffected) {
                if (rowsAffected > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post updated successfully.')),
                  );
                  setState(() {
                    // Update the pet details locally
                    widget.pet.gender = gender;
                    widget.pet.size = size;
                    widget.pet.breed = breed;
                    widget.pet.color = color;
                    widget.pet.actionTaken = actionTaken;
                    widget.pet.condition = condition;
                    widget.pet.details = detailsController.text;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error updating post.')),
                  );
                }
              }).catchError((error) {
                print('Error updating post: $error');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('An error occurred while updating the post.')),
                );
              });
              
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
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
void reportPost(int postId) async {
  try {
    // Update the post's status to indicate it has been reported
    await DatabaseHelper.instance.reportPost(postId);
    // Optionally, you can show a message to the user indicating that the post has been reported
  } catch (error) {
    // Handle any errors that occur during reporting
    print('Error reporting post: $error');
    // Optionally, show an error message to the user
  }
}

  // Other widget code
}

