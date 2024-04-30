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
  final bool isRescued;

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
    required this.isRescued,
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
        // Handle null values and convert isRescued from JSON to boolean
        isRescued: json['isRescued'] != null
            ? (json['isRescued'] is bool
                ? json['isRescued']
                : json['isRescued'].toString().toLowerCase() == 'true')
            : false,
    );
}
}