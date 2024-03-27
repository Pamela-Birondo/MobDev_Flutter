//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter/services.dart' show rootBundle;
//import 'dart:ui' as ui;
import 'feeds.dart'; // Import the file where FeedsPage is defined


class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<searchPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(10.678245, 122.962325); // USLS

  // Define markers
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    // Define marker
    Marker marker = Marker(
      markerId: const MarkerId('17th St. Lacson'),
      position: const LatLng(10.680506933232477, 122.95628329507663),
      infoWindow: const InfoWindow(
        title: '17th St. Lacson',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // Change marker color here
    );

Marker marker1 = Marker(
      markerId: const MarkerId('Bata'),
      position: const LatLng(10.702464595332325, 122.97429610418756), 
      infoWindow: const InfoWindow(
        title: 'Bata',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // Change marker color here
    );

    Marker marker2 = Marker(
      markerId: const MarkerId('Mansilingan'),
      position: const LatLng(10.629613355330536, 122.98361335090269), 
      infoWindow: const InfoWindow(
        title: 'Mansilingan',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // Change marker color here
    );
    
Marker marker3 = Marker(
      markerId: const MarkerId('Talisay'),
      position: const LatLng(10.737838492102869, 122.96609732243917), 
      infoWindow: const InfoWindow(
        title: 'Talisay',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // Change marker color here
    );

Marker marker4 = Marker(
      markerId: const MarkerId('Tangub'),
      position: const LatLng(10.628187207632113, 122.92798683897753), 
      infoWindow: const InfoWindow(
        title: 'Tangub',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // Change marker color here
    );


setState(() {
      // Set markers
      _markers.add(marker);
      _markers.add(marker1);
      _markers.add(marker2);
      _markers.add(marker3);
      _markers.add(marker4);
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
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 12.0,
              ),
              markers: _markers, // Add markers to the map
            ),
          ),
          // Information cards
SizedBox(
  height: 150, // height sang pageview
  child: PageView(
    scrollDirection: Axis.horizontal,
    children: [
      GestureDetector(
        onTap: () {
          // Handle tap for the first card by navigating to feeds.dart
          Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const FeedsPage()),
          );
          print('Tapped on the first card');
        },
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            title: Row(
              children: [
                SizedBox(
                  width: 220,
                  height: 250,
                  child: Image.asset(
                    'images/stray1.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 0), // space between the image and the text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pets),
                        SizedBox(width: 5),
                        Text(
                          'Aspin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 5),
                        Text('Mansilingan'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 5),
                        Text('March 11, 2024'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          // Handle tap for the second card
          Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const FeedsPage()),
          );
          print('Tapped on the second card');
        },
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            title: Row(
              children: [
                SizedBox(
                  width: 220,
                  height: 250,
                  child: Image.asset(
                    'images/stray3.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 0), // space between the image and the text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pets),
                        SizedBox(width: 5),
                        Text(
                          'Puspin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 5),
                        Text('17th St. Lacson'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 5),
                        Text('Feb 6, 2024'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          // Handle tap for the third card
          Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => const FeedsPage()),
          );
          print('Tapped on the third card');
        },
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            title: Row(
              children: [
                SizedBox(
                  width: 220,
                  height: 250,
                  child: Image.asset(
                    'images/stray2.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 0), // space between the image and the text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pets),
                        SizedBox(width: 5),
                        Text(
                          'Aspin',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 5),
                        Text('Bata'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 5),
                        Text('Dec 10, 2023'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),
           ],
          ),
         );
  }

  //void _onMapCreated(GoogleMapController controller) {
    //setState(() {
     // mapController = controller;
    //});
  //}
}
