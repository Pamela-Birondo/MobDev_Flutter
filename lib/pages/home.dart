import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'Database_helper.dart'; 

class homePage extends StatelessWidget {
  const homePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 234, 184, 87)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Paw Rescuer'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 250,
              child: Image.asset('images/logo.png'),
            ),
            const SizedBox(height: 5),
            Container(
              width: 300,
              child:  Text(
                'Every paw has a story, and you are here to be the hero.',
                textAlign: TextAlign.center,
                style: GoogleFonts.averiaSerifLibre(
                  fontSize: 20,
                ), 
              )
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 190,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondRoute()),
                  );
                },
                child: const Text('Need a Rescue!'),
              ),
            ),
            const SizedBox(height: 90),
            SizedBox(
              height: 310,
              child: Image.asset('images/bg.png'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
    const SecondRoute({Key? key}) : super(key: key);

    @override
    State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
    List<XFile> _images = [];
    DateTime selectedDate = DateTime.now();
    List<bool> _isSelected1 = [false, false];
    List<bool> _isSelected2 = [false, false, false];
    int? _selectedItem1Index;
    int? _selectedItem2Index;
    int? _selectedItem3Index;
    int? _selectedItem4Index;
    LatLng? _selectedLocation; // Declare the selected location

    // Create an instance of DatabaseHelper
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    // Function to load images
    Future<void> _loadAssets() async {
        final picker = ImagePicker();
        List<XFile>? resultList;
        try {
            resultList = await picker.pickMultiImage();
        } catch (e) {
            print('Error picking images: $e');
        }
        setState(() {
            _images = resultList ?? [];
        });
    }

    // Function to convert XFiles to Files
    List<File> getFilesFromXFiles(List<XFile> xFiles) {
        return xFiles.map((xFile) => File(xFile.path)).toList();
    }

    // Function to save data
Future<void> _saveData() async {
  try {
    // Extract data from the user interface
    List<File> imageFiles = getFilesFromXFiles(_images);
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    String gender = _isSelected1[0] ? 'Male' : 'Female';
    String size = ['Small', 'Medium', 'Large']
        [_isSelected2.indexWhere((element) => element)];
    String breed = [
      'Aspin',
      'Puspin',
      'Chihuahua',
      'Poodle',
      'Shih Tzu',
      'Persian Cat'
    ][_selectedItem1Index ?? 0];
    String color = ['Solid', 'Bi-Color', 'Tri-color']
        [_selectedItem2Index ?? 0];
    String actionTaken = ['No Actions Taken', 'Adopted', 'Fostered', 'Brought to Shelter']
        [_selectedItem3Index ?? 0];
    String condition = ['Injured', 'Fine'][_selectedItem4Index ?? 0];
    // Retrieve other details from a text input
    String details = '';
    // Determine if the pet is rescued based on actionTaken
    int isRescued = actionTaken != 'No Actions Taken' ? 1 : 0;

    // Debug prints
    print('Formatted Date: $formattedDate');
    print('Gender: $gender');
    print('Size: $size');
    print('Breed: $breed');
    print('Color: $color');
    print('Action Taken: $actionTaken');
    print('Condition: $condition');
    print('Details: $details');
    print('Is Rescued: $isRescued');

    // Prepare data as a Map<String, dynamic>
    Map<String, dynamic> strayData = {
      'images': imageFiles.map((file) => file.path).join(','), // Convert image file paths to comma-separated string
      'date': formattedDate,
      'gender': gender,
      'size': size,
      'breed': breed,
      'color': color,
      'actionTaken': actionTaken,
      'condition': condition,
      'details': details,
      'locationLat': _selectedLocation?.latitude ?? 0, // Add selected location latitude
      'locationLng': _selectedLocation?.longitude ?? 0, // Add selected location longitude
      'isRescued': isRescued, // Set the isRescued property
    };

    // Save the data using DatabaseHelper
    int id = await dbHelper.insertStray(strayData);

    // Provide feedback to the user
    if (id > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully with ID: $id')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving data.')),
      );
    }
  } catch (e) {
    print('Error saving data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred while saving data.')),
    );
  }
}

    // Function to navigate to MapScreen
    void _navigateToMapScreen(BuildContext context) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapScreen(
                    onLocationSelected: (LatLng location) {
                        // Set the selected location from MapScreen
                        setState(() {
                            _selectedLocation = location;
                        });
                    },
                ),
            ),
        );
    }

    // Function to select a date
    Future<void> _selectDate(BuildContext context) async {
        final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            builder: (BuildContext context, Widget? child) {
                return Theme(
                    data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light().copyWith(
                            primary: Colors.redAccent,
                        ),
                    ),
                    child: child!,
                );
            },
        );

        if (pickedDate != null && pickedDate != selectedDate) {
            setState(() {
                selectedDate = pickedDate;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                // Title and other AppBar configurations
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        // Image grid for images
                        SizedBox(
                            height: 290, // Adjust the height as needed
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color.fromARGB(255, 19, 19, 19)),
                                    ),
                                    child: GridView.builder(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 4.0,
                                            mainAxisSpacing: 4.0,
                                        ),
                                        itemCount: _images.length,
                                        itemBuilder: (BuildContext context, int index) {
                                            return Image.file(
                                                File(_images[index].path),
                                                fit: BoxFit.cover,
                                            );
                                        },
                                    ),
                                ),
                            ),
                        ),
                        // Icon buttons for image selection, map navigation, and date selection
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Container(
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 255, 246, 221),
                                    ),
                                    child: IconButton(
                                        onPressed: _loadAssets,
                                        icon: const Icon(Icons.add_photo_alternate),
                                        iconSize: 30,
                                        color: Colors.black,
                                    ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 255, 246, 221),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                            _navigateToMapScreen(context);
                                        },
                                        icon: const Icon(Icons.location_on),
                                        iconSize: 30,
                                        color: Colors.black,
                                    ),
                                ),
                                const SizedBox(width: 10),
                                /*Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(255, 255, 246, 221),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                            _selectDate(context);
                                        },
                                        icon: const Icon(Icons.calendar_today),
                                        iconSize: 30,
                                        color: Colors.black,
                                    ),
                                ),*/
                            ],
                        ),
                        const SizedBox(height: 20),
                        // Gender selection using ToggleButtons
                        Column(
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color.fromARGB(255, 161, 160, 160),
                                                ),
                                                borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: ToggleButtons(
                                                isSelected: _isSelected1,
                                                onPressed: (int index) {
                                                    setState(() {
                                                        for (int buttonIndex = 0;
                                                             buttonIndex < _isSelected1.length;
                                                             buttonIndex++) {
                                                            if (buttonIndex == index) {
                                                                _isSelected1[buttonIndex] = true;
                                                            } else {
                                                                _isSelected1[buttonIndex] = false;
                                                            }
                                                        }
                                                    });
                                                },
                                                children:  <Widget>[
                                                    Container(
                                                        constraints: const BoxConstraints(minWidth: 60),
                                                        child: const Text('Male', textAlign: TextAlign.center),
                                                    ),
                                                    Container(
                                                        constraints: const BoxConstraints(minWidth: 60),
                                                        child: const Text('Female', textAlign: TextAlign.center),
                                                    ),
                                                ],
                                            ),
                                        ),
                                        const SizedBox(width: 20),
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color.fromARGB(255, 155, 155, 155),
                                                ),
                                                borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: ToggleButtons(
                                                isSelected: _isSelected2,
                                                onPressed: (int index) {
                                                    setState(() {
                                                        for (int buttonIndex = 0;
                                                             buttonIndex < _isSelected2.length;
                                                             buttonIndex++) {
                                                            if (buttonIndex == index) {
                                                                _isSelected2[buttonIndex] = true;
                                                            } else {
                                                                _isSelected2[buttonIndex] = false;
                                                            }
                                                        }
                                                    });
                                                },
                                                children:  <Widget>[
                                                    Container(
                                                        constraints: const BoxConstraints(minWidth: 60),
                                                        child: const Text('Small', textAlign: TextAlign.center),
                                                    ),
                                                    Container(
                                                        constraints: const BoxConstraints(minWidth: 60),
                                                        child: const Text('Medium', textAlign: TextAlign.center),
                                                    ),
                                                    Container(
                                                        constraints: const BoxConstraints(minWidth: 60),
                                                        child: const Text('Large', textAlign: TextAlign.center),
                                                    ),
                                                ],
                                            ),
                                        )
                                    ],
                                ),
                                const SizedBox(height: 20),
                                // Breed and color selection using dropdown buttons
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Container(
                                            width: 170,
                                            margin: const EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: DropdownButton<int>(
                                                value: _selectedItem1Index,
                                                onChanged: (int? newIndex) {
                                                    setState(() {
                                                        _selectedItem1Index = newIndex;
                                                    });
                                                },
                                                dropdownColor: Colors.white,
                                                underline: const SizedBox(),
                                                hint: const Text(' Select Breed               '),
                                                items: const <DropdownMenuItem<int>>[
                                                    DropdownMenuItem<int>(
                                                        value: 0,
                                                        child: const Text('Aspin'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 1,
                                                        child: const Text('Puspin'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 2,
                                                        child: const Text('Chihuahua'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 3,
                                                        child: const Text('Poodle'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 4,
                                                        child: const Text('Shih Tzu'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 5,
                                                        child: const Text('Persian Cat'),
                                                    ),
                                                ],
                                            ),
                                        ),
                                        Container(
                                            width: 170,
                                            margin: const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: DropdownButton<int>(
                                                value: _selectedItem2Index,
                                                onChanged: (int? newIndex) {
                                                    setState(() {
                                                        _selectedItem2Index = newIndex;
                                                    });
                                                },
                                                dropdownColor: Colors.white,
                                                underline: const SizedBox(),
                                                hint: const Text(' Select Color               '),
                                                items: const <DropdownMenuItem<int>>[
                                                    DropdownMenuItem<int>(
                                                        value: 0,
                                                        child: const Text('Solid'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 1,
                                                        child: const Text('Bi-Color'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 2,
                                                        child: const Text('Tri-color'),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 10),
                                // Actions taken and condition selection
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        Container(
                                            width: 170,
                                            margin: const EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: DropdownButton<int>(
                                                value: _selectedItem3Index,
                                                onChanged: (int? newIndex) {
                                                    setState(() {
                                                        _selectedItem3Index = newIndex;
                                                    });
                                                },
                                                dropdownColor: Colors.white,
                                                underline: const SizedBox(),
                                                hint: const Text('Actions Taken             '),
                                                items: const <DropdownMenuItem<int>>[
                                                    DropdownMenuItem<int>(
                                                        value: 0,
                                                        child: const Text('No Actions Taken'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 1,
                                                        child: const Text('Adopted'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 2,
                                                        child: const Text('Fostered'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 3,
                                                        child: const Text('Brought to Shelter'),
                                                    ),
                                                ],
                                            ),
                                        ),
                                        Container(
                                            width: 170,
                                            margin: const EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: DropdownButton<int>(
                                                value: _selectedItem4Index,
                                                onChanged: (int? newIndex) {
                                                    setState(() {
                                                        _selectedItem4Index = newIndex;
                                                    });
                                                },
                                                dropdownColor: Colors.white,
                                                underline: const SizedBox(),
                                                hint: const Text('Condition                    '),
                                                items: const <DropdownMenuItem<int>>[
                                                    DropdownMenuItem<int>(
                                                        value: 0,
                                                        child: const Text('Injured'),
                                                    ),
                                                    DropdownMenuItem<int>(
                                                        value: 1,
                                                        child: const Text('Fine'),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 25),
                                // Text input for other details
                                const SizedBox(
                                    width: 350,
                                    child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: TextField(
                                            maxLines: null,
                                            decoration: InputDecoration(
                                                hintText: 'Other Details',
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.symmetric(vertical: 25.0),
                                            ),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 30),
                                // Save button to save the data
                                SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                        onPressed: _saveData,
                                        child: const Text('Save'),
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
            ),
        );
}
}


class MapScreen extends StatefulWidget {
    final Function(LatLng) onLocationSelected; // Callback function to pass the selected location

    const MapScreen({Key? key, required this.onLocationSelected}) : super(key: key);

    @override
    _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<MapScreen> {
    late GoogleMapController mapController;
    final Set<Marker> _markers = {}; // Set to store markers
    final LatLng _center = const LatLng(10.678245, 122.962325); // USLS
    LatLng? _selectedLocation;

    // Create an instance of DatabaseHelper (if needed)
    final DatabaseHelper dbHelper = DatabaseHelper.instance;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Map'),
            ),
            body: Stack(
                children: [
                    GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 12.0,
                        ),
                        markers: _markers,
                        onTap: _addMarker,
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ElevatedButton(
                                onPressed: _selectedLocation != null ? _saveLocation : null,
                                child: const Text('Save Location'),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    void _onMapCreated(GoogleMapController controller) {
        setState(() {
            mapController = controller;
        });
    }

    void _addMarker(LatLng position) {
        setState(() {
            _selectedLocation = position;
            _markers.clear();
            _markers.add(
                Marker(
                    markerId: MarkerId(position.toString()),
                    position: position,
                    infoWindow: InfoWindow(
                        title: 'Selected Location',
                        snippet: 'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
                    ),
                    icon: BitmapDescriptor.defaultMarker,
                ),
            );
        });
    }

    // Function to save the selected location
    Future<void> _saveLocation() async {
        // Call the callback function to pass the selected location back to SecondRoute
        if (_selectedLocation != null) {
            widget.onLocationSelected(_selectedLocation!);
            Navigator.pop(context); // Navigate back to SecondRoute
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No location selected.')),
            );
        }
    }
}