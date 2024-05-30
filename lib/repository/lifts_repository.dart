import 'package:logger/logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<List<Lift>> searchLifts(String pickupLocation, String destinationLocation) async {
    try {
      var querySnapshot = await _firestore
          .collection("lifts")
          .where("pickupLocation", isEqualTo: pickupLocation)
          .where("destinationLocation", isEqualTo: destinationLocation)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Lift.fromJson(data);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

}
