
class Lift {
  final String liftId;
  final String offeredBy;
  final String departureLocation;
  // final String departureTown;
  final String destinationLocation;
  // final String destinationTown;
  final DateTime departureDateTime;
  final int availableSeats;

  Lift({
    required this.liftId,
    required this.offeredBy,
    required this.departureLocation,
    required this.destinationLocation,
    required this.departureDateTime,
    required this.availableSeats,
  });

  Lift.fromJson(Map<String, Object?> jsonMap)
      : this(
    liftId: jsonMap['liftId'] as String,
    offeredBy: jsonMap['offeredBy'] as String,
    departureLocation: jsonMap['departureLoaction'] as String,
    destinationLocation: jsonMap['destinationLocation'] as String,
    departureDateTime: DateTime.parse(jsonMap['departureDateTime'] as String),
    availableSeats: jsonMap['availableSeats'] as int,
  );

  Map<String, Object?> toJson() {
    return {
      'liftId': liftId,
      'offeredBy': offeredBy,
      'departureLoaction': departureLocation,
      'destinationLoaction': destinationLocation,
      'departureDateTime': departureDateTime.toIso8601String(),
      'availableSeats': availableSeats,
    };
  }

  @override
  String toString() {
    return 'Lift{liftId: $liftId, offeredBy: $offeredBy, departureLocation: $departureLocation,'
      '  destinationLocation: $destinationLocation, departureDateTime: $departureDateTime, availableSeats: $availableSeats}';
  }
}