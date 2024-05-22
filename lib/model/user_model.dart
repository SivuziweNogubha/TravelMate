// Created a Model to get access to firestore to store our data
class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? driverLicenseNumber;
  String? vehicleModel;
  String? insuranceInfo;


  UserModel({this.uid, this.email, this.firstName, this.lastName, this.driverLicenseNumber, this.vehicleModel,this.insuranceInfo
  });

  // receiving data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      // driverLicenseNumber: map['driverLicenseNumber'],
      // vehicleModel: map['vehicleModel'],
      // insuranceInfo: map['insuranceInfo'],

    );
  }


  Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      // 'driverLicenseNumber': driverLicenseNumber,
      // 'vehicleModel': vehicleModel,
      // 'insuranceInfo': insuranceInfo,


    };
  }
}