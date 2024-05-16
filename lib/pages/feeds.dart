import 'dart:io';

import 'package:flutter/material.dart';
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

  List<Pet> _filterPets(List<Pet> pets, String query) {
    // Filter pets based on the query
    final filteredPets = pets.where((pet) {
      return pet.breed.toLowerCase().contains(query.toLowerCase()) ||
          pet.color.toLowerCase().contains(query.toLowerCase()) ||
          pet.gender.toLowerCase().contains(query.toLowerCase()) ||
          pet.postedBy.toLowerCase().contains(query.toLowerCase()) ||
          pet.location.toLowerCase().contains(query.toLowerCase());
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

class InformationCard extends StatelessWidget {
  final double width;
  final Pet pet;

  const InformationCard({
    Key? key,
    required this.width,
    required this.pet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Stray Information'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(
                      File(pet.images),
                      width: 400,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    _buildCardItem('Posted by', pet.postedBy, 150.0),
                    SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCardItem('Date', pet.date, 150.0),
                                _buildCardItem('Location', pet.location, 150.0),
                                _buildCardItem('Breed', pet.breed, 150.0),
                                _buildCardItem('Gender', pet.gender, 150.0),
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
                                _buildCardItem('Size', pet.size, 150.0),
                                _buildCardItem('Color', pet.color, 150.0),
                                _buildCardItem('Actions Taken', pet.actionTaken, 150.0),
                                _buildCardItem('Condition', pet.condition, 150.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Comments:',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person),
                            ),
                            title: Text('Ella'),
                            subtitle: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 131, 131, 131),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Going...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person),
                            ),
                            title: Text('Jia'),
                            subtitle: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 131, 131, 131),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person),
                            ),
                            title: Text('Casandra'),
                            subtitle: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 131, 131, 131),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Comment.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // Add comments 
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type your comment here...',
                                border: OutlineInputBorder(),
                              ),
                              // Add controller or onChanged handler as needed
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // functionality here
                          },
                          child: Text('Post'),
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
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: SizedBox(
        width: width,
        child: Card(
          margin: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                File(pet.images),
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
                          _buildCardItem('Date', pet.date, 200.0),
                          _buildCardItem('Location', pet.location, 200.0),
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
                          _buildCardItem('Breed', pet.breed, 200.0),
                          _buildCardItem('Gender', pet.gender, 200.0),
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
    if (title == 'Posted by') {
      return Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 158, 158, 158),
            child: Icon(Icons.person),
          ),
          SizedBox(width: 8.0),
          SizedBox(
            width: itemWidth - 48.0, // Adjusted width considering CircleAvatar and SizedBox
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: itemWidth,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          margin: EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 234, 184, 87),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}