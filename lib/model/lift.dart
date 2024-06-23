import 'package:cloud_firestore/cloud_firestore.dart';

class Lift {
  final String liftId;
  final String offeredBy;
  final String departureLocation;
  final String status;
  final double departureLat;
  final double departureLng;
  final String destinationLocation;
  final double destinationLat;
  final double destinationLng;
  final DateTime departureDateTime;
  final int availableSeats;
  final String destinationImage;
  final double price; // Add the price field
  List<String> passengers;

  Lift({
    required this.liftId,
    required this.offeredBy,
    required this.status,
    required this.departureLocation,
    required this.departureLat,
    required this.departureLng,
    required this.destinationLocation,
    required this.destinationLat,
    required this.destinationLng,
    required this.departureDateTime,
    required this.availableSeats,
    required this.destinationImage,
    required this.price, // Add this parameter
    this.passengers = const [],
  });

  Lift.fromJson(Map<String, Object?> jsonMap)
      : this(
    liftId: jsonMap['liftId'] as String,
    offeredBy: jsonMap['offeredBy'] as String,
    status: jsonMap['status'] as String,
    departureLocation: jsonMap['departureLocation'] as String,
    departureLat: jsonMap['departureLat'] as double,
    departureLng: jsonMap['departureLng'] as double,
    destinationLocation: jsonMap['destinationLocation'] as String,
    destinationLat: jsonMap['destinationLat'] as double,
    destinationLng: jsonMap['destinationLng'] as double,
    departureDateTime: (jsonMap['departureDateTime'] as Timestamp).toDate(),
    availableSeats: jsonMap['availableSeats'] as int,
    destinationImage: jsonMap['destinationImage'] as String,
    price: jsonMap['price'] as double, // Add this line
    passengers: (jsonMap['passengers'] as List<dynamic>).cast<String>(),
  );

  Map<String, Object?> toJson() {
    return {
      'liftId': liftId,
      'offeredBy': offeredBy,
      'status': status,
      'departureLocation': departureLocation,
      'departureLat': departureLat,
      'departureLng': departureLng,
      'destinationLocation': destinationLocation,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'departureDateTime': departureDateTime,
      'availableSeats': availableSeats,
      'destinationImage': destinationImage,
      'price': price, // Add this line
      'passengers': passengers,
    };
  }
}
