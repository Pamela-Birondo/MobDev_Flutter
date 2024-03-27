import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'pet_model.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  late Future<List<Pet>> _futurePets;
  late TextEditingController _searchController;
  bool _isSearchVisible = false;

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
    final String jsonString = await rootBundle.loadString('assets/pets.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Pet.fromJson(json)).toList();
  }

  List<Pet> _filterPets(List<Pet> pets, String query) {
    if (query.isEmpty) {
      return pets;
    }
    return pets.where((pet) {
      return pet.breed.toLowerCase().contains(query.toLowerCase()) ||
          pet.color.toLowerCase().contains(query.toLowerCase()) ||
          pet.gender.toLowerCase().contains(query.toLowerCase()) ||
          pet.postedBy.toLowerCase().contains(query.toLowerCase()) ||
          pet.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
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
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: _toggleSearchVisibility,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: _futurePets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else {
                  final List<Pet> pets = snapshot.data!;
                  final filteredPets = _filterPets(
                    pets,
                    _searchController.text,
                  );
                  return ListView.builder(
                    itemCount: filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = filteredPets[index];
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
    return SizedBox(
      width: width,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              pet.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${pet.date}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Location: ${pet.location}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Breed: ${pet.breed}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Gender: ${pet.gender}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Size: ${pet.size}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Color: ${pet.color}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Actions Taken: ${pet.actionstaken}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Condition: ${pet.condition}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    'Posted by: ${pet.postedBy}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}