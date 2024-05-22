class Bookingmodel {
  String? passengerId;
  String? LiftId;
  bool? confirmed;

  Bookingmodel({this.passengerId,this.confirmed,this.LiftId
  });

  factory Bookingmodel.fromMap(map) {
    return Bookingmodel(
      passengerId: map['passenger_id'],
      LiftId: map['lift_id'],
      confirmed: map['confirmed'],

    );
  }


  Map<String,dynamic> toMap() {
    return {
      'passenger_id': passengerId,
      'lift_id': LiftId,
      'confirmed': confirmed,

    };
  }

}