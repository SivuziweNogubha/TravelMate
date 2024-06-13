import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetailsScreen extends StatefulWidget {
  final String liftId;
  final String offeredBy;
  final String departureLocation;
  final String destinationLocation;
  final DateTime departureDateTime;
  final int availableSeats;
  final String photoUrl;

  const RideDetailsScreen({
    required this.liftId,
    required this.offeredBy,
    required this.departureLocation,
    required this.destinationLocation,
    required this.departureDateTime,
    required this.availableSeats,
    required this.photoUrl,
  });

  @override
  _RideDetailsScreenState createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  late GoogleMapController _googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-26.232590, 28.240967), // Use your coordinates here
              zoom: 14.4746,
            ),
            onMapCreated: (controller) {
              _googleMapController = controller;
            },
            markers: _createMarkers(),
            polylines: _createPolylines(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(widget.photoUrl),
                    ),
                    title: Text('Offered by: ${widget.offeredBy}'),
                    subtitle: Text('Departure: ${widget.departureLocation}\nDestination: ${widget.destinationLocation}'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement confirm functionality
                        },
                        child: Text('Confirm'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement cancel functionality
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('departure'),
        position: LatLng(-26.232590, 28.240967), // Use your departure coordinates here
        infoWindow: InfoWindow(title: 'Departure'),
      ),
      Marker(
        markerId: MarkerId('destination'),
        position: LatLng(-26.232590, 28.240967), // Use your destination coordinates here
        infoWindow: InfoWindow(title: 'Destination'),
      ),
    };
  }

  Set<Polyline> _createPolylines() {
    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: [
          LatLng(-26.232590, 28.240967), // Use your departure coordinates here
          LatLng(-26.232590, 28.240967), // Use your destination coordinates here
        ],
        color: Colors.blue,
        width: 5,
      ),
    };
  }
}
