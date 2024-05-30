import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  final _searchController = TextEditingController();


  static const CameraPosition _kGooglePlex = CameraPosition(
    target:  LatLng(-26.232590, 28.240967),
    zoom: 14.4746,
  );

  static final Marker _KGooglePlexMarker = Marker(
    markerId: MarkerId('_KGooglePlexMarker'),
    infoWindow: InfoWindow(title: 'Google Plex'),
    icon: BitmapDescriptor.defaultMarker,
    position:  LatLng(-26.2041, 28.0473),
  );


  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target:LatLng(-26.2041, 28.0473),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );


  static final Marker _KLakeMarker = Marker(
    markerId: MarkerId('_KLakeMaker'),
    infoWindow: InfoWindow(title: 'lake'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(37.43296265331129, -122.08832357078792),
  );


  static final Polyline _KPolyline = Polyline(
    polylineId: PolylineId('_KPolyline'),
    points: [
      LatLng(37.42796133580664, -122.085749655962),
      LatLng(37.43296265331129, -122.08832357078792),
    ],
    width: 5,
  );


  static final Polygon _KPolygon = Polygon(
    polygonId: PolygonId('_KPolygon'),
    points: [
      LatLng(-26.2041, 28.0473),
    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,
    
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
              )),
              IconButton(
                  onPressed:() {},
                  icon: Icon(Icons.search)
              )
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              markers: {_KGooglePlexMarker,
                // _KLakeMarker
              },
              // polylines: {
              //   _KPolyline,
              // },
              // polygons: {
              //   _KPolygon,
              // },
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  Future<void> _goToDestination() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}