import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifts_app/model/wallet.dart';
import 'package:lifts_app/repository/wallet_repo.dart';
import 'package:logger/logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/BookingModel.dart';
import '../model/lift.dart';

/// Manages storing and retrieval of Lifts from Firebase
/// The idea is that you use a class like this in LiftsViewModel, instead of using FirebaseFirestore SDK directly from views
class LiftsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var logger = Logger();

  Stream<QuerySnapshot> getJoinedLifts(String userId) {
    return _firestore
        .collection('lifts')
        .where('passengers', arrayContains: userId)
        .snapshots();
  }

  Future<void> cancelLift(String liftId, String userId) async {
    DocumentReference liftDoc = _firestore.collection('lifts').doc(liftId);
    DocumentReference BookingDoc = _firestore.collection('bookings').doc(liftId);

    await liftDoc.update({
      'passengers': FieldValue.arrayRemove([userId]),
      'status': 'cancelled',
    });

    await liftDoc.update({
      'availableSeats': FieldValue.increment(1)
    });
  }




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
    }
  }




  Future<void> deleteLift(String liftId) async {
    try {
      await _firestore.collection('lifts').doc(liftId).delete();
      logger.i('Lift deleted with ID: $liftId');
    } catch (error) {
      logger.e('Error deleting lift: $error');
      // Handle errors appropriately
    }
  }


  Future<List<DocumentSnapshot>> searchRides(
      String destination, DateTime selectedDate, String currentUserId) async {
    Query query = _firestore.collection('lifts')
        .where('destinationLocation', isEqualTo: destination)
        .where('offeredBy',isNotEqualTo: currentUserId)
        .where('departureDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDate))
        .where('departureDateTime', isLessThanOrEqualTo: Timestamp.fromDate(selectedDate.add(Duration(days: 1))));

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs;
  }


  Future<void> joinLift(BuildContext context, String liftId, String userId, WalletRepository _walletRepository) async {
    try {
      // Check if the user has a wallet
      bool hasWallet = await _walletRepository.userHasWallet(userId);
      if (!hasWallet) {
        // Create a wallet if the user doesn't have one
        await _walletRepository.createWallet(userId);
      }

      // Fetch the lift data
      DocumentSnapshot liftSnapshot = await _firestore.collection('lifts').doc(liftId).get();
      Map<String, dynamic> liftData = liftSnapshot.data() as Map<String, dynamic>;

      // Get available seats, passengers list, and lift status
      int availableSeats = liftData['availableSeats'];
      List<String> passengers = List<String>.from(liftData['passengers']);
      String liftStatus = liftData['status'];

      // Fetch the cost of the lift (assuming it's stored in the lift data)
      double liftCost = liftData['price'];

      // Check if there are available seats and lift is pending
      if (availableSeats > 0 && liftStatus == 'pending'||liftStatus == 'cancelled') {
        // Deduct the cost from the user's wallet balance
        await _walletRepository.updateWalletBalance(userId, -liftCost);

        // Create a booking
        String bookingId = _firestore.collection('bookings').doc().id;
        Booking booking = Booking(
          bookingId: bookingId,
          userId: userId,
          liftId: liftId,
          confirmed: true,
        );
        await createBooking(booking);

        // Update the lift data
        passengers.add(userId);
        String updatedStatus = 'confirmed';

        await _firestore.collection('lifts').doc(liftId).update({
          'availableSeats': availableSeats - 1,
          'passengers': passengers,
          'status': updatedStatus,
        });

        // Notify the user of the successful booking
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lift booked successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No available seats left or lift is not pending')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking lift: $e')),
      );
    }
  }




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
      final existingBookingQuery = await _firestore
          .collection('bookings')
          .where('liftId', isEqualTo: booking.liftId)
          .where('userId', isEqualTo: booking.userId)
          .get();

      if (existingBookingQuery.docs.isNotEmpty) {
        logger.w('Booking already exists for this lift and user');
        return;
      }

      await _firestore.collection('bookings').add(booking.toJson());
      logger.i('Booking created with ID: ${booking.bookingId}');
    } catch (error) {
      logger.e('Error creating booking: $error');
    }
  }


  //NOT USED, NEEDS TO BE USED
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

  //NOT USED, NEEDS TO BE USED
  Future<void> confirmBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'confirmed': true,
    });
  }
  //NOT USED, NEEDS TO BE USED
  Future<void> cancelBooking(String bookingId) async {
    // try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'confirmed': false,
      });

  }
}
