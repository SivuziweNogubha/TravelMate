
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
    // required this.departureTown,
    required this.destinationLocation,
    // required this.destinationTown,
    required this.departureDateTime,
    required this.availableSeats,
  });

  Lift.fromJson(Map<String, Object?> jsonMap)
      : this(
    liftId: jsonMap['liftId'] as String,
    offeredBy: jsonMap['offeredBy'] as String,
    departureLocation: jsonMap['departureLoaction'] as String,
    // departureTown: jsonMap['departureTown'] as String,
    destinationLocation: jsonMap['destinationLocation'] as String,
    // destinationTown: jsonMap['destinationTown'] as String,
    departureDateTime: DateTime.parse(jsonMap['departureDateTime'] as String),
    availableSeats: jsonMap['availableSeats'] as int,
  );

  Map<String, Object?> toJson() {
    return {
      'liftId': liftId,
      'offeredBy': offeredBy,
      'departureLoaction': departureLocation,
      // 'departureTown': departureTown,
      'destinationLoaction': destinationLocation,
      // 'destinationTown': destinationTown,
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