import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/BookingModel.dart';
import '../model/lift.dart';

/// Manages storing and retrieval of Lifts from Firebase
/// The idea is that you use a class like this in LiftsViewModel, instead of using FirebaseFirestore SDK directly from views
class LiftsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();

  Future<void> createLift(Lift lift) async {
    await _firestore.collection('lifts').add(lift.toJson());
  }

  Future<List<Lift>> getUpcomingLiftsByUserId(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('lifts')
        .where('offeredBy', isEqualTo: userId)
        .where('departureDateTime', isGreaterThan: DateTime.now())
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Lift.fromJson(data);
    }).toList();
  }

  Future<void> completeLift(String liftId) async {
    await _firestore.collection('lifts').doc(liftId).update({
      'liftStatus': 'completed',
    });
  }
  /// Updates an existing Lift document in Firestore
  Future<void> updateLift(Lift lift) async {
    try {
      await _firestore.collection('lifts').doc(lift.liftId).update(lift.toJson());
      logger.i('Lift updated with ID: ${lift.liftId}');
    } catch (error) {
      logger.e('Error updating lift: $error');
      // Handle errors appropriately
    }
  }

  Future<void> cancelLift(String liftId) async {
    await _firestore.collection('lifts').doc(liftId).update({
      'liftStatus': 'cancelled',
    });
  }


  /// Deletes an existing Lift document from Firestore
  Future<void> deleteLift(String liftId) async {
    try {
      await _firestore.collection('lifts').doc(liftId).delete();
      logger.i('Lift deleted with ID: $liftId');
    } catch (error) {
      logger.e('Error deleting lift: $error');
      // Handle errors appropriately
    }
  }


  Future<List<Map<String, dynamic>>> fetchAvailableRides(
      String destination, DateTime dateTime) async {
    try {
      final querySnapshot = await _firestore
          .collection('lifts')
          .where('destinationLocation', isEqualTo: destination)
          .where('departureDateTime', isGreaterThanOrEqualTo: dateTime)
          .get();

      final availableRides = querySnapshot.docs
          .map((docSnapshot) => docSnapshot.data())
          .toList();

      return availableRides;
    } catch (error) {
      logger.e('Error fetching available rides: $error');
      return [];
    }
  }
  Future<List<DocumentSnapshot>> searchRides(
      String destination, DateTime selectedDate, String currentUserId) async {
    Query query = _firestore.collection('lifts')
        .where('destinationLoaction', isEqualTo: destination)
        .where('offeredBy',isNotEqualTo: currentUserId)
        .where('departureDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate))
        .where('departureDateTime', isLessThanOrEqualTo: Timestamp.fromDate(selectedDate.add(Duration(days: 1))));

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs;
  }

  Future<void> joinLift(String liftId, String userId) async {
    DocumentReference liftDoc = _firestore.collection('lifts').doc(liftId);

    await liftDoc.update({
      'passengers': FieldValue.arrayUnion([userId])
    });

    await liftDoc.update({'availableSeats': FieldValue.increment(-1)});

    DocumentReference userDoc = _firestore.collection('users').doc(userId);

    await userDoc.update({
      'confirmedLifts': FieldValue.arrayUnion([liftId])
    });
  }

  // Future<List<Lift>> searchLifts(String pickupLocation, String destinationLocation) async {
  //   try {
  //     var querySnapshot = await _firestore
  //         .collection("lifts")
  //         .where("pickupLocation", isEqualTo: pickupLocation)
  //         .where("destinationLocation", isEqualTo: destinationLocation)
  //         .get();
  //
  //     return querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Lift.fromJson(data);
  //     }).toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<void> deleteUserData(String userId) async {
    try {
      final bookingsCollection = _firestore.collection("bookings");
      final liftsCollection = _firestore.collection("lifts");

      var liftsSnapshot = await liftsCollection
          .where("driverId", isEqualTo: userId)
          .get();

      for (var doc in liftsSnapshot.docs) {
        if (doc["liftStatus"] == "pending") {
          await liftsCollection.doc(doc.id).update({
            "liftStatus": "cancelled",
          });
        }
      }

      var bookingsSnapshot = await _firestore
          .collection("bookings")
          .where("userId", isEqualTo: userId)
          .get();

      for (var doc in bookingsSnapshot.docs) {
        var liftDoc = await liftsCollection.doc(doc["liftId"]).get();
        if (liftDoc["liftStatus"] == "pending") {
          await liftsCollection.doc(doc["liftId"]).update({
            "bookedSeats": FieldValue.increment(-1),
          });
        }
        await bookingsCollection.doc(doc.id).delete();
      }
    } catch (e) {
      print('Error deleting user data: $e');
    }
  }


  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toJson());
      logger.i('Booking created with ID: ${booking.bookingId}');
    } catch (error) {
      logger.e('Error creating booking: $error');
    }
  }

  Future<List<Booking>> getBookingsByUserId(String userId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Booking.fromJson(data);
    }).toList();
  }


  Future<void> confirmBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'confirmed': true,
    });
  }

  Future<void> cancelBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'confirmed': false,
    });
  }
}
