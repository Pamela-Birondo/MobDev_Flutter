import 'dart:io'; // Import the dart:io package for File class
//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter/services.dart' show rootBundle;
//import 'dart:ui' as ui;
import 'feeds.dart'; // Import the file where FeedsPage is defined
import 'Database_helper.dart';
import 'package:geocoding/geocoding.dart';


// Define the SearchPage widget
class adminsearchPage extends StatefulWidget {
    const adminsearchPage({Key? key}) : super(key: key);

    @override
    _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<adminsearchPage> {
    // Define variables
    late GoogleMapController mapController;
    final LatLng _center = const LatLng(10.678245, 122.962325); // USLS
    Set<Marker> _markers = {}; // Set of markers
    List<Map<String, dynamic>> firstThreeStrays = []; // Data for first three stray records
    Map<String, dynamic>? currentStray; // Holds the stray data for the tapped marker

    // Create an instance of DatabaseHelper
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    @override
    void initState() {
        super.initState();
        // Load the first three stray records when the widget is initialized
        loadFirstThreeStrays();
    }

    // Function to load the first three stray records
    Future<void> loadFirstThreeStrays() async {
        try {
            // Retrieve the first three records from the stray table
            List<Map<String, dynamic>> strays = await dbHelper.getFirstThreeStrays();
            // Update the state variable with the retrieved data
            setState(() {
                firstThreeStrays = strays;
            });
            // Load markers for all stray data
            loadAllStrayMarkers();
        } catch (e) {
            print('Error loading first three strays: $e');
        }
    }

    // Function to load markers for all stray data
    Future<void> loadAllStrayMarkers() async {
        try {
            // Retrieve all stray data
            List<Map<String, dynamic>> allStrays = await dbHelper.getStrays();
            Set<Marker> newMarkers = {}; // Use a temporary set to avoid modifying state directly

            for (var stray in allStrays) {
                // Get the location name (reverse geocode)
                String locationName = await _getLocationName(LatLng(stray['locationLat'], stray['locationLng']));

                // Create a marker with an onTap callback
                Marker marker = Marker(
                    markerId: MarkerId(stray['id'].toString()),
                    position: LatLng(stray['locationLat'], stray['locationLng']),
                    infoWindow: InfoWindow(
                        title: 'Stray: ${stray['breed']}',
                        snippet: 'Location: $locationName',
                        onTap: () => onMarkerTapped(stray),
                    ),
                );

                newMarkers.add(marker); // Add the marker to the temporary set
            }

            setState(() {
                _markers = newMarkers; // Update the state with the new markers
            });
        } catch (e) {
            print('Error loading markers: $e');
        }
    }

    // Function to reverse geocode and get the location name
    Future<String> _getLocationName(LatLng location) async {
        try {
            // Use the geocoding package to perform reverse geocoding
            List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
            if (placemarks.isNotEmpty) {
                // Return the location name
                return placemarks.first.locality ?? 'Unknown location';
            } else {
                return 'Unknown location';
            }
        } catch (e) {
            print('Error performing reverse geocoding: $e');
            return 'Unknown location';
        }
    }

    // Function to handle marker tap events
    void onMarkerTapped(Map<String, dynamic> stray) {
        setState(() {
            // Update the current stray data when a marker is tapped
            currentStray = stray;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Map'),
            ),
            body: Column(
                children: [
                    // Google Maps widget
                    Expanded(
                        child: GoogleMap(
                            onMapCreated: (controller) {
                                mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 12.0,
                            ),
                            markers: _markers, // Add markers to the map
                        ),
                    ),
                    // Information cards
                    if (currentStray != null)
                        GestureDetector(
                            onTap: () {
                                // Redirect the user to the FeedsPage when the information card is tapped
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FeedsPage()),
                                );
                            },
                            child: FutureBuilder<String>(
                                future: _getLocationName(LatLng(currentStray!['locationLat'], currentStray!['locationLng'])),
                                builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Display a loading indicator while waiting for data
                                        return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                        // Handle the error case
                                        return Text('Error: ${snapshot.error}');
                                    } else {
                                        // Display the card with the location name
                                        String locationName = snapshot.data ?? 'Unknown location';
                                        return Card(
                                            child: ListTile(
                                                contentPadding: const EdgeInsets.all(15),
                                                title: Row(
                                                    children: [
                                                        // Use MultiImageWidget here to handle multiple images
                                                        SizedBox(
                                                            width: 220,
                                                            height: 120,
                                                            child: currentStray!['images'] != null && currentStray!['images'].isNotEmpty
                                                                ? Image.file(
                                                                    File(currentStray!['images'].split(',')[0]), // Display one image (first) from the multiple images uploaded
                                                                    fit: BoxFit.contain,
                                                                )
                                                                : Image.asset(
                                                                    'images/placeholder.jpg',
                                                                    fit: BoxFit.contain,
                                                                ),
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                Row(
                                                                    children: [
                                                                        const Icon(Icons.pets),
                                                                        const SizedBox(width: 5),
                                                                        Text(
                                                                            currentStray!['breed'],
                                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                    ],
                                                                ),
                                                                Row(
                                                                    children: [
                                                                        const Icon(Icons.location_on),
                                                                        const SizedBox(width: 5),
                                                                        Text(locationName),
                                                                    ],
                                                                ),
                                                                Row(
                                                                    children: [
                                                                        const Icon(Icons.calendar_today),
                                                                        const SizedBox(width: 5),
                                                                        Text(currentStray!['date']),
                                                                    ],
                                                                ),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                            ),
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