// pet_model.dart

class Pet {
  final String imageUrl;
  final DateTime date;
  final String location;
  final String breed;
  final String gender;
  final String size;
  final String color;
  final String actionstaken;
  final String condition;
  final String postedBy;

  Pet({
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.breed,
    required this.gender,
    required this.size,
    required this.color,
    required this.actionstaken,
    required this.condition,
    required this.postedBy,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      imageUrl: json['imageUrl'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      breed: json['breed'],
      gender: json['gender'],
      size: json['size'],
      color: json['color'],
      actionstaken: json['actions taken'],
      condition: json['condition'],
      postedBy: json['postedBy'],
    );
  }
}