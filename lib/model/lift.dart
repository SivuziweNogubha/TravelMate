
import 'package:cloud_firestore/cloud_firestore.dart';

class Lift {
  final String liftId;
  final String offeredBy;
  final String departureLocation;
  // final String departureTown;
  final String destinationLocation;
  // final String destinationTown;
  final DateTime departureDateTime;
  final int availableSeats;
  List<String> passengers;


  Lift({
    required this.liftId,
    required this.offeredBy,
    required this.departureLocation,
    required this.destinationLocation,
    required this.departureDateTime,
    required this.availableSeats,
    this.passengers = const [],
  });

  Lift.fromJson(Map<String, Object?> jsonMap)
      : this(
    liftId: jsonMap['liftId'] as String,
    offeredBy: jsonMap['offeredBy'] as String,
    departureLocation: jsonMap['departureLoaction'] as String,
    destinationLocation: jsonMap['destinationLocation'] as String,
    departureDateTime: (jsonMap['departureDateTime'] as Timestamp).toDate(),
    availableSeats: jsonMap['availableSeats'] as int,
    passengers: jsonMap['availableSeats'] as List<String>,
  );

  Map<String, Object?> toJson() {
    return {
      'liftId': liftId,
      'offeredBy': offeredBy,
      'departureLoaction': departureLocation,
      'destinationLoaction': destinationLocation,
      'departureDateTime': departureDateTime,
      'availableSeats': availableSeats,
      'passengers': passengers,
    };
  }

  @override
  String toString() {
    return 'Lift{liftId: $liftId, offeredBy: $offeredBy, departureLocation: $departureLocation,'
      '  destinationLocation: $destinationLocation, departureDateTime: $departureDateTime, availableSeats: $availableSeats,passengers:$passengers}';
  }
}