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
              title: const Text('Stray Information'),
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
                    _buildCardItem('Posted by', widget.pet.postedBy, 150.0),
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
    String displayValue = value.toString();
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
}