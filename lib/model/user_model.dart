// Created a Model to get access to firestore to store our data
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  final String? photoURL;
  final double? cash;




  UserModel({this.uid, this.email, this.firstName, this.lastName, this.photoURL, this.cash
  });

  // receiving data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],



    );
  }
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      uid: doc["uid"],
      firstName: doc["firstName"],
      lastName: doc["lastName"],
      email: doc["email"],
      photoURL: doc["profilePhoto"],
      cash: doc["cash"],
    );
  }


    Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,


    };
  }
}