//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Lift {
//   final String liftId;
//   final String offeredBy;
//   final String departureLocation;
//   // final String departureTown;
//   final String destinationLocation;
//   // final String destinationTown;
//   final DateTime departureDateTime;
//   final int availableSeats;
//   List<String> passengers;
//
//
//   Lift({
//     required this.liftId,
//     required this.offeredBy,
//     required this.departureLocation,
//     required this.destinationLocation,
//     required this.departureDateTime,
//     required this.availableSeats,
//     this.passengers = const [],
//   });
//
//   Lift.fromJson(Map<String, Object?> jsonMap)
//       : this(
//     liftId: jsonMap['liftId'] as String,
//     offeredBy: jsonMap['offeredBy'] as String,
//     departureLocation: jsonMap['departureLoaction'] as String,
//     destinationLocation: jsonMap['destinationLocation'] as String,
//     departureDateTime: (jsonMap['departureDateTime'] as Timestamp).toDate(),
//     availableSeats: jsonMap['availableSeats'] as int,
//     passengers: jsonMap['availableSeats'] as List<String>,
//   );
//
//   Map<String, Object?> toJson() {
//     return {
//       'liftId': liftId,
//       'offeredBy': offeredBy,
//       'departureLoaction': departureLocation,
//       'destinationLoaction': destinationLocation,
//       'departureDateTime': departureDateTime,
//       'availableSeats': availableSeats,
//       'passengers': passengers,
//     };
//   }
//
//   @override
//   String toString() {
//     return 'Lift{liftId: $liftId, offeredBy: $offeredBy, departureLocation: $departureLocation,'
//       '  destinationLocation: $destinationLocation, departureDateTime: $departureDateTime, availableSeats: $availableSeats,passengers:$passengers}';
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

// class Lift {
//   final String liftId;
//   final String offeredBy;
//   final String departureLocation;
//   final String destinationLocation;
//   final DateTime departureDateTime;
//   final int availableSeats;
//   final String destinationImage; // Add this line
//   List<String> passengers;
//
//   Lift({
//     required this.liftId,
//     required this.offeredBy,
//     required this.departureLocation,
//     required this.destinationLocation,
//     required this.departureDateTime,
//     required this.availableSeats,
//     required this.destinationImage, // Add this parameter
//     this.passengers = const [],
//   });
//
//   // Update the fromJson constructor to include destinationImage
//   Lift.fromJson(Map<String, Object?> jsonMap)
//       : this(
//     liftId: jsonMap['liftId'] as String,
//     offeredBy: jsonMap['offeredBy'] as String,
//     departureLocation: jsonMap['departureLoaction'] as String,
//     destinationLocation: jsonMap['destinationLocation'] as String,
//     departureDateTime: (jsonMap['departureDateTime'] as Timestamp).toDate(),
//     availableSeats: jsonMap['availableSeats'] as int,
//     destinationImage: jsonMap['destinationImage'] as String, // Add this line
//     passengers: (jsonMap['passengers'] as List<dynamic>).cast<String>(),
//   );
//
//   // Update the toJson method to include destinationImage
//   Map<String, Object?> toJson() {
//     return {
//       'liftId': liftId,
//       'offeredBy': offeredBy,
//       'departureLoaction': departureLocation,
//       'destinationLoaction': destinationLocation,
//       'departureDateTime': departureDateTime,
//       'availableSeats': availableSeats,
//       'destinationImage': destinationImage, // Add this line
//       'passengers': passengers,
//     };
//   }
// }
class Lift {
  final String liftId;
  final String offeredBy;
  final String departureLocation;
  final double departureLat;
  final double departureLng;
  final String destinationLocation;
  final double destinationLat;
  final double destinationLng;
  final DateTime departureDateTime;
  final int availableSeats;
  final String destinationImage;
  List<String> passengers;

  Lift({
    required this.liftId,
    required this.offeredBy,
    required this.departureLocation,
    required this.departureLat,
    required this.departureLng,
    required this.destinationLocation,
    required this.destinationLat,
    required this.destinationLng,
    required this.departureDateTime,
    required this.availableSeats,
    required this.destinationImage,
    this.passengers = const [],
  });

  Lift.fromJson(Map<String, Object?> jsonMap)
      : this(
    liftId: jsonMap['liftId'] as String,
    offeredBy: jsonMap['offeredBy'] as String,
    departureLocation: jsonMap['departureLocation'] as String,
    departureLat: jsonMap['departureLat'] as double,
    departureLng: jsonMap['departureLng'] as double,
    destinationLocation: jsonMap['destinationLocation'] as String,
    destinationLat: jsonMap['destinationLat'] as double,
    destinationLng: jsonMap['destinationLng'] as double,
    departureDateTime: (jsonMap['departureDateTime'] as Timestamp).toDate(),
    availableSeats: jsonMap['availableSeats'] as int,
    destinationImage: jsonMap['destinationImage'] as String,
    passengers: (jsonMap['passengers'] as List<dynamic>).cast<String>(),
  );

  Map<String, Object?> toJson() {
    return {
      'liftId': liftId,
      'offeredBy': offeredBy,
      'departureLocation': departureLocation,
      'departureLat': departureLat,
      'departureLng': departureLng,
      'destinationLocation': destinationLocation,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'departureDateTime': departureDateTime,
      'availableSeats': availableSeats,
      'destinationImage': destinationImage,
      'passengers': passengers,
    };
  }
}