
class Lift {
  final String liftId;
  final String offeredBy;
  final String departureStreet;
  final String departureTown;
  final String destinationStreet;
  final String destinationTown;
  final DateTime departureDateTime;
  final int availableSeats;

  Lift({
    required this.liftId,
    required this.offeredBy,
    required this.departureStreet,
    required this.departureTown,
    required this.destinationStreet,
    required this.destinationTown,
    required this.departureDateTime,
    required this.availableSeats,
  });

  Lift.fromJson(Map<String, Object?> jsonMap)
      : this(
    liftId: jsonMap['liftId'] as String,
    offeredBy: jsonMap['offeredBy'] as String,
    departureStreet: jsonMap['departureStreet'] as String,
    departureTown: jsonMap['departureTown'] as String,
    destinationStreet: jsonMap['destinationStreet'] as String,
    destinationTown: jsonMap['destinationTown'] as String,
    departureDateTime: DateTime.parse(jsonMap['departureDateTime'] as String),
    availableSeats: jsonMap['availableSeats'] as int,
  );

  Map<String, Object?> toJson() {
    return {
      'liftId': liftId,
      'offeredBy': offeredBy,
      'departureStreet': departureStreet,
      'departureTown': departureTown,
      'destinationStreet': destinationStreet,
      'destinationTown': destinationTown,
      'departureDateTime': departureDateTime.toIso8601String(),
      'availableSeats': availableSeats,
    };
  }

  @override
  String toString() {
    return 'Lift{liftId: $liftId, offeredBy: $offeredBy, departureStreet: $departureStreet, departureTown: $departureTown,'
      '  destinationStreet: $destinationStreet,destinationTown: $destinationTown, departureDateTime: $departureDateTime, availableSeats: $availableSeats}';
  }
}