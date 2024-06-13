import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmRidePage extends StatelessWidget {
  final LatLng departureLocation;
  final LatLng destinationLocation;
  final String offeredBy;
  final String offeredByName;
  final String offeredByPhotoUrl;
  final String destination;
  final String departure;

  ConfirmRidePage({
    required this.departureLocation,
    required this.destinationLocation,
    required this.offeredBy,
    required this.offeredByName,
    required this.offeredByPhotoUrl,
    required this.destination,
    required this.departure,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Confirm Ride'),
        // backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  (departureLocation.latitude + destinationLocation.latitude) / 2,
                  (departureLocation.longitude + destinationLocation.longitude) / 2,
                ),
                zoom: 12,
              ),
              markers: {
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
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: [departureLocation, destinationLocation],
                  color: Colors.blue,
                  width: 4,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Trip Details'),
                Text('Departure: ${departure}'),
                Text('Destination: ${destination}'),
                // Display user details
                Text('Offered By: $offeredByName'),
                // Display user profile picture
                CircleAvatar(
                  backgroundImage: NetworkImage(offeredByPhotoUrl),
                ),
                // Display trip details here
                // Offered by, price, etc.
                ElevatedButton(
                  onPressed: () {
                    // Implement booking functionality
                    // Navigate to confirmation page or perform booking action
                  },
                  child: Text('Confirm Ride'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to FindRide page
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
