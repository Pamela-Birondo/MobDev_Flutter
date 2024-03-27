import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class homePage extends StatelessWidget {
  const homePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffeab857)),
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
  // String? _selectedItem1;
  // String? _selectedItem2;
  List<bool> _isSelected1 = [false, false];
  List<bool> _isSelected2 = [false, false, false];
  int? _selectedItem1Index;
  int? _selectedItem2Index;
  int? _selectedItem3Index;
  int? _selectedItem4Index;

  Future<void> _loadAssets() async {
    final picker = ImagePicker();
    List<XFile>? resultList;
    try {
      resultList = await picker.pickMultiImage();
    } catch (e) {
      print('Error picking images: $e');
    }

    if (resultList != null) {
      setState(() {
        _images = resultList!;
      });
    }
  }

  List<File> getFilesFromXFiles(List<XFile> xFiles) {
    return xFiles.map((xFile) => File(xFile.path)).toList();
  }

  void _navigateToMapScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text("Select Images"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 290, // Adjust the height as needed
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
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
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      width: 100,
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
      width: 100,
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
    Container(
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
    ),
  ],
),
const SizedBox(height: 20), // Add space between the rows
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
            children: <Widget>[
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
        const SizedBox(width: 20), // Add space between the toggle buttons
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
            children: <Widget>[
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
    const SizedBox(height: 20), // Add space between the rows
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      width: 170, // Adjust the width as needed
      margin: const EdgeInsets.only(right: 10), // Add margin
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
        underline: SizedBox(),
        hint: const Text(' Select Breed               '),
        items: const <DropdownMenuItem<int>>[
          DropdownMenuItem<int>(
            value: 0,
            child: Text(' Aspin'),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text(' Puspin'),
          ),
          DropdownMenuItem<int>(
            value: 2,
            child: Text(' Chihuahua'),
          ),
          DropdownMenuItem<int>(
            value: 3,
            child: Text(' Poodle'),
          ),
          DropdownMenuItem<int>(
            value: 4,
            child: Text(' Shih Tzu'),
          ),
          DropdownMenuItem<int>(
            value: 5,
            child: Text(' Persian Cat'),
          ),
        ],
      ),
    ),
    Container(
      width: 170, // Adjust the width as needed
      margin: const EdgeInsets.only(left: 10), // Add margin
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
        underline: SizedBox(),
        hint: const Text(' Select Color               '),
        items: const <DropdownMenuItem<int>>[
          DropdownMenuItem<int>(
            value: 0,
            child: Text(' Solid'),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text(' Bi-Color'),
          ),
          DropdownMenuItem<int>(
            value: 2,
            child: Text(' Tri-color'),
          ),
        ],
      ),
    ),
  ],
),
const SizedBox(height: 10), // Add space between the rows
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Container(
      width: 170, // Adjust the width as needed
      margin: const EdgeInsets.only(right: 10), // Add margin
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
        underline: SizedBox(),
        hint: const Text(' Actions Taken            '),
        items: const <DropdownMenuItem<int>>[
          DropdownMenuItem<int>(
            value: 0,
            child: Text(' No Actions Taken'),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text(' Adopted'),
          ),
          DropdownMenuItem<int>(
            value: 2,
            child: Text(' Fostered'),
          ),
          DropdownMenuItem<int>(
            value: 3,
            child: Text(' Brought to Shelter'),
          ),
        ],
      ),
    ),
    Container(
      width: 170, // Adjust the width as needed
      margin: const EdgeInsets.only(left: 10), // Add margin
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
        underline: SizedBox(),
        hint: const Text(' Condition                   '),
        items: const <DropdownMenuItem<int>>[
          DropdownMenuItem<int>(
            value: 0,
            child: Text(' Injured'),
          ),
          DropdownMenuItem<int>(
            value: 1,
            child: Text(' Fine'),
          ),
        ],
      ),
    ),
  ],
),
const SizedBox(height: 25),
                  const SizedBox(
  width: 350, // Adjust the width of the text input
  child: Padding(
    padding: EdgeInsets.all(5.0), // Add padding to all sides
    child: TextField(
      maxLines: null, // Allow multiple lines of text
      decoration: InputDecoration(
        hintText: '  Other Details', // Placeholder text for the input field
        border: OutlineInputBorder(), // Border for the input field
        contentPadding: EdgeInsets.symmetric(vertical: 25.0), // Adjust vertical padding
      ),
    ),
  ),
),
    const SizedBox(height: 30), // Add space between the text input and the next row
    SizedBox(
      width: 150, // Adjust the width of the save button
      child: ElevatedButton(
        onPressed: () {
          // Add your save functionality here
        },
        child: const Text('Save'),
      ),
    ),
  ],
),
            const SizedBox(height: 2), // Add space between the text input and the next row
          ],
        ),
      ),
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
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
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedDate = value;
        });
      }
    });
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {}; // Set to store markers

  final LatLng _center = const LatLng(10.678245, 122.962325); // USLS
  LatLng? _selectedLocation;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          // Google Maps widget
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
}
void _saveLocation() {
    //logic to save the selected location
    //pass _selectedLocation to another screen or widget 
    print('Location saved: $_SecondRouteState');
  }
