import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';

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
    double midLatitude = (departureLocation.latitude + destinationLocation.latitude) / 2;
    double midLongitude = (departureLocation.longitude + destinationLocation.longitude) / 2;
    double adjustedMidLatitude = midLatitude + 0.0050;

    final confirmButton = Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: primary,
      child: MaterialButton(
        onPressed: () {
          //
        },
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          "Confirm Ride",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        textColor: Colors.white,
      ),
    );

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: const Color(0x44000000),
      //   title: Text(
      //     'Confirm Ride',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 20,
      //       fontWeight: FontWeight.w500,
      //       decoration: TextDecoration.none,
      //       fontFamily: 'Aeonik',
      //     ),
      //   ),
      // ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                adjustedMidLatitude,
                midLongitude,
              ),
              zoom: 13,
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
                      Text('Trip Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8.0),
                      Text('Departure: $departure'),
                      Text('Destination: $destination'),
                      SizedBox(height: 8.0),
                      Text('Offered By: $offeredByName'),
                      SizedBox(height: 8.0),
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
                      SizedBox(height: 16.0),
                      confirmButton,
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
