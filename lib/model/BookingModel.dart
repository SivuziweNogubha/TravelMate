// class Bookingmodel {
//   String? passengerId;
//   String? LiftId;
//   bool? confirmed;
//
//   Bookingmodel({this.passengerId,this.confirmed,this.LiftId
//   });
//
//   factory Bookingmodel.fromMap(map) {
//     return Bookingmodel(
//       passengerId: map['passenger_id'],
//       LiftId: map['lift_id'],
//       confirmed: map['confirmed'],
//
//     );
//   }
//
//
//   Map<String,dynamic> toMap() {
//     return {
//       'passenger_id': passengerId,
//       'lift_id': LiftId,
//       'confirmed': confirmed,
//
//     };
//   }
//
// }

class Booking {
  final String bookingId;
  final String userId;
  final String liftId;
  final bool confirmed;

  Booking({
    required this.bookingId,
    required this.userId,
    required this.liftId,
    required this.confirmed,
  });

  Booking.fromJson(Map<String, Object?> jsonMap)
      : this(
    bookingId: jsonMap['bookingId'] as String,
    userId: jsonMap['userId'] as String,
    liftId: jsonMap['liftId'] as String,
    confirmed: jsonMap['confirmed'] as bool,
  );

  Map<String, Object?> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'liftId': liftId,
      'confirmed': confirmed,
    };
  }

  @override
  String toString() {
    return 'Booking{bookingId: $bookingId, userId: $userId, liftId: $liftId, confirmed: $confirmed}';
  }
}
