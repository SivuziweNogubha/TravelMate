
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
