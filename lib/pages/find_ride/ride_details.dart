import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import '../../model/BookingModel.dart';
import '../../model/lift.dart';
import '../../repository/lifts_repository.dart';
import '../../utils/important_constants.dart';
import 'Map.dart';

class ConfirmRidePage extends StatelessWidget {
  final LatLng departureLocation;
  final LatLng destinationLocation;
  late final String offeredBy;
  final String offeredByName;
  final String offeredByPhotoUrl;
  final String destination;
  final String departure;
  final String image;
  final int seat;
  final String liftId;
  final double price;

  ConfirmRidePage({
    required this.departureLocation,
    required this.destinationLocation,
    required this.offeredBy,
    required this.offeredByName,
    required this.offeredByPhotoUrl,
    required this.destination,
    required this.departure,
    required this.price,
    required this.liftId,
    required this.image,
    required this.seat,
  });

  @override
  Widget build(BuildContext context) {
    double midLatitude = (departureLocation.latitude + destinationLocation.latitude) / 2;
    double midLongitude = (departureLocation.longitude + destinationLocation.longitude) / 2;
    double adjustedMidLatitude = midLatitude + 0.0050;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> joinLift(String liftId, String userId) async {
      try {
        DocumentSnapshot liftSnapshot = await _firestore.collection('lifts').doc(liftId).get();
        Map<String, dynamic> liftData = liftSnapshot.data() as Map<String, dynamic>;

        int availableSeats = liftData['availableSeats'];
        List<String> passengers = List<String>.from(liftData['passengers']);
        if (availableSeats > 0) {
          String bookingId = _firestore.collection('bookings').doc().id;
          Booking booking = Booking(
            bookingId: bookingId,
            userId: userId,
            liftId: liftId,
            confirmed: true,
          );
          final _liftsRepository = LiftsRepository();

          await _liftsRepository.createBooking(booking);

          passengers.add(userId);
          await _firestore.collection('lifts').doc(liftId).update({
            'availableSeats': availableSeats - 1,
            'passengers': passengers,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lift booked successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No available seats left')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking lift: $e')),
        );
      }
    }


    Material confirmride(String liftId){
      return Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(30),
        color: primary,
        child: MaterialButton(
          onPressed: () async {
            String mylift = liftId;
            String userId = FirebaseAuth.instance.currentUser!.uid;
            await joinLift(mylift, userId);
          },
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          child: Text(
            "Join Ride",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          textColor: Colors.white,
        ),
      );
    }
    Lift lift = Lift(
      liftId: liftId,
      offeredBy: offeredBy,
      departureLocation: departure,
      departureLat: departureLocation.latitude,
      departureLng: departureLocation.longitude,
      destinationLocation: destination,
      destinationLat: destinationLocation.latitude,
      destinationLng: destinationLocation.longitude,
      departureDateTime: DateTime.now(), // Adjust accordingly
      availableSeats: seat, // Adjust accordingly
      destinationImage: image, // Adjust accordingly
      price: price,
    );



    return Scaffold(

      body: LayoutBuilder(
        builder: (context,constraints) {
          return Stack(
            children: [
              googleMap(
                lift,
                {
                  Marker(
                    markerId: MarkerId('departure'),
                    position: departureLocation,
                    infoWindow: InfoWindow(title: 'Departure Location'),
                  ),
                  Marker(
                    markerId: MarkerId('destination'),
                    position: destinationLocation,
                    infoWindow: InfoWindow(title: 'Destination Location'),
                  ),
                },
                {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: [departureLocation, destinationLocation],
                    color: Colors.blue,
                    width: 4,
                  ),
                },
                constraints,
              ),
              Positioned(
                top: 25.0,
                left: 16.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8), // Greyish background color with opacity
                      shape: BoxShape.rectangle, // Shape of the container (circular in this case)
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: ImageIcon(
                      AssetImage('assets/back.png'),
                      color: Colors.white, // Color of the icon (white)
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40, // Adjust the radius as needed for the desired size
                                    backgroundColor: Colors.grey[300], // Optional background color for the avatar
                                    backgroundImage: NetworkImage(
                                      offeredByPhotoUrl,
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        offeredByPhotoUrl,
                                        fit: BoxFit.contain, // Ensure the image fits perfectly within the CircleAvatar
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offeredByName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                          fontFamily: 'Aeonik',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: Colors.green,
                                          ),
                                          child: const Text(
                                            "Available",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Aeonik',
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          // Text('Trip Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          // SizedBox(height: 8.0),
                          const Text(
                            "Trip Route",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Aeonik',
                            ),
                          ),
                          Text(
                            "${departure} → ${destination}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Aeonik',
                            ),
                          ),
                          Text('Trip fare: R$price'),
                          SizedBox(height: 8.0),
                          SizedBox(height: 16.0),
                          confirmride(liftId),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
