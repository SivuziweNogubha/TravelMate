import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/lift.dart';
import '../repository/lifts_repository.dart';

class LiftOfferViewModel extends ChangeNotifier {
  final LiftsRepository _liftRepository = LiftsRepository();
  final String _userId;

  LiftOfferViewModel(this._userId);

  Future<void> offerRide({
    required String departureLocation,
    required String destinationLocation,
    required DateTime departureDateTime,
    required int availableSeats,
  }) async {
    final lift = Lift(
      liftId: '',
      offeredBy: _userId,
      departureLocation: departureLocation,
      destinationLocation: destinationLocation,
      departureDateTime: departureDateTime,
      // departureTime: Timestamp.fromDate(departureDateTime),
      availableSeats: availableSeats,
      // liftStatus: 'pending',
      passengers: [],
      // bookingTime: Timestamp.now(),
      // driverId: _userId,
      // Set other fields as needed
    );

    try {
      await _liftRepository.createLift(lift);
      // Optionally, you can perform additional actions on successful lift creation
    } catch (e) {
      // Handle the error
    }
  }


  Future<void> updateLift({
    required String liftId,
    required String departureLocation,
    required String destinationLocation,
    required DateTime departureDateTime,
    required int availableSeats,
  }) async {
    final lift = Lift(
      liftId: liftId,
      offeredBy: _userId,
      departureLocation: departureLocation,
      destinationLocation: destinationLocation,
      departureDateTime: departureDateTime,
      // departureTime: Timestamp.fromDate(departureDateTime),
      availableSeats: availableSeats,
      // liftStatus: 'pending', // Assuming you want to keep the lift status as 'pending'
      passengers: [], // Assuming you don't want to update the passengers list
      // bookingTime: Timestamp.now(),
      // driverId: _userId,
      // Set other fields as needed
    );

    try {
      await _liftRepository.updateLift(lift);
      // Optionally, you can perform additional actions on successful lift update
    } catch (e) {
      // Handle the error
    }
  }
}
