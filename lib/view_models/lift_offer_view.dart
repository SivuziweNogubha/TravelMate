import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/lift.dart';
import '../repository/lifts_repository.dart';
import 'package:lifts_app/src/google_maps_service.dart';

class LiftOfferViewModel extends ChangeNotifier {
  final LiftsRepository _liftRepository = LiftsRepository();
  final String _userId;
  GoogleMapsService service = GoogleMapsService();


  LiftOfferViewModel(this._userId);

  Future<void> offerRide({
    required String departureLocation,
    required String destinationLocation,
    required DateTime departureDateTime,
    required int availableSeats,
    required double price,


  }) async {
    // Fetch the destination photo URL from the API
    String destinationImageUrl = await service.getDestinationPhotoUrl(destinationLocation);

    GeoPoint departureCoordinates = await service.getLocationCoordinates(departureLocation);
    GeoPoint destinationCoordinates = await service.getLocationCoordinates(destinationLocation);


    final lift = Lift(
      liftId: '',
      offeredBy: _userId,
      departureLocation: departureLocation,
      destinationLocation: destinationLocation,
      departureDateTime: departureDateTime,
      availableSeats: availableSeats,
      departureLat: departureCoordinates.latitude,
      departureLng: departureCoordinates.longitude,
      destinationLat: destinationCoordinates.latitude,
      destinationLng: destinationCoordinates.longitude,
      destinationImage: destinationImageUrl, // Include the destinationImage
      passengers: [],
      status: 'pending',
      price: price,
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
    required double price,
  }) async {
    // Fetch the destination photo URL from the API
    String destinationImageUrl = await service.getDestinationPhotoUrl(destinationLocation);

    GeoPoint departureCoordinates = await service.getLocationCoordinates(departureLocation);
    GeoPoint destinationCoordinates = await service.getLocationCoordinates(destinationLocation);


    final lift = Lift(
      liftId: '',
      offeredBy: _userId,
      departureLocation: departureLocation,
      destinationLocation: destinationLocation,
      departureDateTime: departureDateTime,
      availableSeats: availableSeats,
      departureLat: departureCoordinates.latitude,
      departureLng: departureCoordinates.longitude,
      destinationLat: destinationCoordinates.latitude,
      destinationLng: destinationCoordinates.longitude,
      destinationImage: destinationImageUrl, // Include the destinationImage
      passengers: [],
      status: 'pending',
      price: price,
    );
    try {
      await _liftRepository.updateLift(lift);
      // Optionally, you can perform additional actions on successful lift update
    } catch (e) {
      // Handle the error
    }
  }
}