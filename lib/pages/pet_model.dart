import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pet {
  final int id;
  final String images;
  final DateTime date;
  final String gender;
  final String size;
  final String breed;
  final String color;
  final String actionTaken;
  final String condition;
  final String details;
  final double locationLat; // Latitude attribute
  final double locationLng; // Longitude attribute
  final String postedBy;
  final bool isRescued;

  Pet({
    required this.id,
    required this.images,
    required this.date,
    required this.gender,
    required this.size,
    required this.breed,
    required this.color,
    required this.actionTaken,
    required this.condition,
    required this.details,
    required this.locationLat,
    required this.locationLng,
    required this.postedBy,
    required this.isRescued,
  });

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

  factory Pet.fromMap(Map<String, dynamic> map) {
    final dateParts = map['date'].split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
    final date = DateTime(year, month, day);

    return Pet(
      id: map['id'],
      images: map['images'] ?? '',
      date: date,
      gender: map['gender'] ?? '',
      size: map['size'] ?? '',
      breed: map['breed'] ?? '',
      color: map['color'] ?? '',
      actionTaken: map['actionTaken'] ?? '',
      condition: map['condition'] ?? '',
      details: map['details'] ?? '',
      locationLat: map['locationLat'],
      locationLng: map['locationLng'],
      postedBy: map['postedBy'] ?? '',
      isRescued: map['isRescued'] == 1,
    );
  }

  static fromJson(json) {}
}
